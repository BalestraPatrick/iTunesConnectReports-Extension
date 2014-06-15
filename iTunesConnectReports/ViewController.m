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
    
    
    NSURL *statusURL = [[NSURL alloc] initWithString:@"http://appfigures.com/itcstatus"];
    NSURLRequest *request = [NSURLRequest requestWithURL:statusURL];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.webView.delegate = self;
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    self.answerLabel.alpha = 0.0;

    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSString *source = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    if (source) {
        if ([source containsString:@"haveTodays"]) {
            NSRange range = [source rangeOfString:@"haveTodays"];
            range.length +=7;
            
            NSString *newString = [source substringWithRange:range];
            
            NSCharacterSet *replaceCharachter = [NSCharacterSet characterSetWithCharactersInString:@"\""];
            newString = [[newString componentsSeparatedByCharactersInSet:replaceCharachter] componentsJoinedByString: @""];
            
            NSArray *values = [newString componentsSeparatedByString:@":"];
            if (values) {
                if ([[values firstObject] isEqualToString:@"haveTodays"]) {
                    if ([[values objectAtIndex:1] isEqualToString:@"false"]) {
                        // NOT RELEASED YET
                        NSLog(@"Not yet");
                        self.answerLabel.text = @"No.";
                        self.answerLabel.textColor = [UIColor redColor];
                    } else {
                        // YEAH, REPORTS ALREADY RELEASED
                        NSLog(@"YEAH");
                        self.answerLabel.text = @"Yes.";
                        self.answerLabel.textColor = [UIColor greenColor];
                    }
                    [webView stopLoading];
                    [UIView animateWithDuration:0.25 animations:^{
                        self.answerLabel.alpha = 1.0;
                    }];
                }
            }
            
        }
    }
    
}


@end
