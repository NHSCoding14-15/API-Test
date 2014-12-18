//
//  ViewController.m
//  API Test
//
//  Created by David Kopala on 12/8/14.
//  Copyright (c) 2014 David Kopala. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *requsetURL;
@property (strong, nonatomic) IBOutlet UIButton *requestButton;
@property (strong, nonatomic) IBOutlet UITextView *responseField;
@property (strong, nonatomic) IBOutlet UITextField *postDataField;
@property (strong, nonatomic) IBOutlet UISlider *requestType;
@property (strong, nonatomic) IBOutlet UILabel *GET;
@property (strong, nonatomic) IBOutlet UILabel *POST;
@property (strong, nonatomic) IBOutlet UILabel *PUT;
@property (strong, nonatomic) IBOutlet UILabel *DELETE;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self update];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)requsetTypeChange:(id)sender {
}

- (IBAction)buttonResponse:(id)sender {
    [self update];
    int index = (int)[self.requestType value];
    switch (index) {
        case 0:
            [self functionGET];
            break;
        case 1:
            [self functionPOST];
        default:
            break;
    }
}

- (IBAction)requsetChange:(id)sender {
    float index = [self.requestType value];
    NSLog(@"Index: %f", index);
    float selection = roundf(index);
    NSLog(@"Selection: @%f", selection);
    self.requestType.value = selection;
    [self update];
}

- (void) update {
    int index = (int)[self.requestType value];
    int selection = round(index);
    if (selection == 1) {
        self.postDataField.hidden = NO;
    } else if (selection == 2) {
        self.postDataField.hidden = NO;
    } else {
        self.postDataField.hidden = YES;
    }
}

- (void) functionGET{
    NSString *URLText = [self.requsetURL text];
    NSURL *url = [NSURL URLWithString:URLText];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error)
     {
         if (data.length > 0 && error == nil) {
             NSString *receivedDataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             self.responseField.text = receivedDataString;
         } else {
             self.responseField.text = @"Connection Complete, No Data";
         }
     }];
}

- (void) functionPOST {
    NSString *URLString = self.requsetURL.text;
    NSString *postRequest = [self.postDataField text];
    NSData *postData = [postRequest dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init ];
    [request setURL:[NSURL URLWithString:URLString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection Could Not Be Made");
    }

}

- (void) functionPUT {
    
}

- (void) functionDELETE {
    
}

@end
