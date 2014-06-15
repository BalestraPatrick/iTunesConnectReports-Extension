//
//  ViewController.swift
//  iTunesConnectReports
//
//  Created by Vladislav Jevremović on 6/15/14.
//  Copyright (c) 2014 Vladislav Jevremović. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {
    
    var webView: UIWebView?
    @IBOutlet var answerLabel: UILabel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusURL = NSURL(string: "http://appfigures.com/itcstatus")
        let request = NSURLRequest(URL: statusURL)
        
        webView = UIWebView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        webView!.delegate = self
        webView!.loadRequest(request)
        view.addSubview(webView)
        
        answerLabel.alpha = 0.0
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        let sourceOptional: NSString! = webView.stringByEvaluatingJavaScriptFromString("document.body.innerHTML")
        if let source = sourceOptional {
            if source.containsString("haveTodays") {
                var range = source.rangeOfString("haveTodays")
                range = NSMakeRange(range.location, range.length + 7)
                
                var newString = source.substringWithRange(range)
                
                let replaceCharacter = NSCharacterSet(charactersInString: "\"")
                let newStringSplit: NSString[] = newString.componentsSeparatedByCharactersInSet(replaceCharacter)
                let newStringSplitArray = NSArray(array: newStringSplit)
                newString = newStringSplitArray.componentsJoinedByString("")
                
                let valuesOptional: NSArray? = newString.componentsSeparatedByString(":")
                if let values = valuesOptional {
                    if values.firstObject.isEqualToString("haveTodays") {
                        if values.objectAtIndex(1).isEqualToString("false") {
                            // NOT RELEASED YET
                            NSLog("Not yet")
                            answerLabel.text = "No."
                            answerLabel.textColor = UIColor.redColor()
                        } else {
                            // YEAH, REPORTS ALREADY RELEASED
                            NSLog("YEAH")
                            answerLabel.text = "Yes."
                            answerLabel.textColor = UIColor.greenColor()
                        }
                        webView.stopLoading()
                        UIView.animateWithDuration(0.25, animations: {
                            self.answerLabel.alpha = 1.0
                            })
                    }
                }
            }
        }
    }
}
