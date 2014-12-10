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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonResponse:(id)sender {
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

@end
