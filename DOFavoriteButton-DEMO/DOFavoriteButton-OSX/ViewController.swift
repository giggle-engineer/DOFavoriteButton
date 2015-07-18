//
//  ViewController.swift
//  DOFavoriteButton-OSX
//
//  Created by Chloe Stars on 7/17/15.
//  Copyright © 2015 Daiki Okumura. All rights reserved.
//

import Cocoa
import DOFavoriteButton

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = (self.view.frame.width - 44) / 4
        var x = width / 2
        let y = self.view.frame.height / 2
        
        // star button
        let starButton = DOFavoriteButton(frame: CGRectMake(x, y, 44, 44))
        self.view.addSubview(starButton)
        x += width
        
        // heart button
        let heartButton = DOFavoriteButton(frame: CGRectMake(x, y, 44, 44), image: NSImage(named: "heart"), imageFrame: CGRectMake(12, 12, 20, 20))
        heartButton.imageColorOn = NSColor(red: 254/255, green: 110/255, blue: 111/255, alpha: 1.0)
        heartButton.circleColor = NSColor(red: 254/255, green: 110/255, blue: 111/255, alpha: 1.0)
        heartButton.lineColor = NSColor(red: 226/255, green: 96/255, blue: 96/255, alpha: 1.0)
        heartButton.bordered = false
        self.view.addSubview(heartButton)
        x += width
        
        // like button
        let likeButton = DOFavoriteButton(frame: CGRectMake(x, y, 44, 44), image: NSImage(named: "like"), imageFrame: CGRectMake(12, 12, 20, 20))
        likeButton.imageColorOn = NSColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        likeButton.circleColor = NSColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        likeButton.lineColor = NSColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1.0)
        self.view.addSubview(likeButton)
        x += width
        
        // smile button
        let smileButton = DOFavoriteButton(frame: CGRectMake(x, y, 44, 44), image: NSImage(named: "smile"), imageFrame: CGRectMake(12, 12, 20, 20))
        smileButton.imageColorOn = NSColor(red: 45/255, green: 204/255, blue: 112/255, alpha: 1.0)
        smileButton.circleColor = NSColor(red: 45/255, green: 204/255, blue: 112/255, alpha: 1.0)
        smileButton.lineColor = NSColor(red: 45/255, green: 195/255, blue: 106/255, alpha: 1.0)
        self.view.addSubview(smileButton)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func liked(sender: DOFavoriteButton) {
        NSLog("button was pressed, state is: %@", !sender.selected)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

