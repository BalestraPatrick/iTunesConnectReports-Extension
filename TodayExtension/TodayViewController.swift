//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Patrick Balestra on 10/08/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding {
    
    @IBOutlet var answerLabel: NSTextField?

    override var nibName: String! {
        return "TodayViewController"
    }
    
    override func viewDidLoad() {
        self.answerLabel!.stringValue = ""
        checkStatus()
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInset: NSEdgeInsets) -> NSEdgeInsets {
        return NSEdgeInsetsMake(0, 0, 0, 0)
    }

    func checkStatus() {
        let url = NSURL(string: "http://www.patrickbalestra.com/iTC")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) -> Void in
            if !error {
                let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                println(dictionary)
                if dictionary["success"] {
                    let haveTodays = dictionary.valueForKey("haveTodays") as Bool
                    self.answerLabel!.textColor = haveTodays ? NSColor.greenColor() : NSColor.redColor()
                    self.answerLabel!.stringValue = haveTodays ? "Yes" : "No"
                }
            } else {
                self.answerLabel!.textColor = NSColor.redColor()
                self.answerLabel!.stringValue = "Error"
                println(error)
            }
        }
        task.resume()
    }

}
