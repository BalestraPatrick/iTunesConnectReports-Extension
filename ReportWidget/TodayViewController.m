//
//  TodayViewController.m
//  ReportWidget
//
//  Created by Patrick Balestra on 03/06/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

/*
 
    This project scrapes the appfigures.com/itcstatus to see if the iTunes Connect reports are avaiable for today. I didn't find an official API or a better way
    to do that so if you find one, just let me know.
    App icon is property of Apple.
 
*/

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@property (weak, nonatomic) IBOutlet UILabel *answerLabel;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setPreferredContentSize:CGSizeMake(300, 40)];
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect notificationCenterVibrancyEffect]];
    effectView.frame = self.view.bounds;
    effectView.autoresizingMask = self.view.autoresizingMask;
    
    __strong UIView *oldView = self.view;
    
    self.view = effectView;
    
    [effectView.contentView addSubview:oldView];
    
    self.view.tintColor = [UIColor lightTextColor];
    
    [self checkStatus];
    
    self.answerLabel.alpha = 0.0;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [UIView animateWithDuration:0.25 animations:^{
        self.answerLabel.alpha = 0.0;
    }];
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    defaultMarginInsets.bottom = 0;
    defaultMarginInsets.left = 0;
    return defaultMarginInsets;
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
                    });
                }
            }
        }
    }];
    
    [task resume];
}

@end
