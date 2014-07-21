//
//  ViewController.m
//  iTunesConnectReports
//
//  Created by Patrick Balestra on 03/06/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

/*
 
 This project scrapes the appfigures.com/itcstatus to see if the iTunes Connect reports are avaiable for today. I didn't find an official API or a better way
 to do that so if you find one, just let me know.
 App icon is property of Apple.
 
*/

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UIWebView *webView;

@property (weak, nonatomic) IBOutlet UILabel *answerLabel;


@end

@implementation ViewController


            
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self checkStatus];
    
    self.answerLabel.alpha = 0.0;
    
}

- (void)checkStatus {
    NSURL *url = [NSURL URLWithString:@"http://verbanounihockey.ch/patrick/iTC"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSError *jsonError = nil;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (!jsonError) {
                if (dictionary[@"success"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.answerLabel.text = dictionary[@"success"] ? @"Yes" : @"No";
                        [UIView animateWithDuration:0.25 animations:^{
                            self.answerLabel.alpha = 1.0;
                        }];
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    });
                }
            }
        }
    }];
    
    [task resume];
}

@end
