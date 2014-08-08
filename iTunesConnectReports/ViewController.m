//
//  ViewController.m
//  iTunesConnectReports
//
//  Created by Patrick Balestra on 03/06/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

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
    NSURL *url = [NSURL URLWithString:@"http://www.patrickbalestra.com/iTC"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSError *jsonError = nil;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (!jsonError) {
                if (dictionary[@"success"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSNumber *haveTodays = [dictionary valueForKey:@"haveTodays"];
                        self.answerLabel.text = haveTodays.boolValue ? @"Yes" : @"No";
                        self.answerLabel.textColor = haveTodays.boolValue ? [UIColor greenColor] : [UIColor redColor];
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
