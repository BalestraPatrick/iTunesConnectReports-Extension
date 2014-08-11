//
//  ViewController.swift
//  iTunesConnectReports
//
//  Created by Patrick Balestra on 23/07/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
                            
    @IBOutlet var answerLabel: NSTextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "iTunes Connect Reports"
        self.answerLabel!.stringValue = ""
        
        checkStatus()
        
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
            }
        }
        task.resume()
    }
}

