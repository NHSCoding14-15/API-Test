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
@property (strong, nonatomic) IBOutlet UISegmentedControl *requestType;
@property (strong, nonatomic) IBOutlet UITextField *postDataField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updatePostField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonResponse:(id)sender {
    NSString *URLText = [self.requsetURL text];
    NSURL *url = [NSURL URLWithString:URLText];
    NSString *type = [self.requestType titleForSegmentAtIndex:self.requestType.selectedSegmentIndex];
    if ([type isEqualToString:@"GET"]) {
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
    } else if ([type isEqualToString:@"POST"]) {
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
}
- (IBAction)requsetChange:(id)sender {
    [self updatePostField];
}

- (void) updatePostField {
    NSString *type = [self.requestType titleForSegmentAtIndex:self.requestType.selectedSegmentIndex];
    if ([type isEqualToString:@"GET"]) {
        self.postDataField.hidden = YES;
    } else if ([type isEqualToString:@"POST"]) {
        self.postDataField.hidden = NO;
    }
}

@end
