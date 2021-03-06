//
//  DOFavoriteButton.swift
//  DOFavoriteButton
//
//  Created by Daiki Okumura on 2015/07/09.
//  Copyright (c) 2015 Daiki Okumura. All rights reserved.
//
//  This software is released under the MIT License.
//  http://opensource.org/licenses/mit-license.php
//

import AppKit

@IBDesignable
public class DOFavoriteButton: NSButton {
    
    @IBInspectable override public var image: NSImage! {
        didSet {
            let frame = self.frame
            let imageFrame = CGRectMake(frame.size.width / 2 - frame.size.width / 4, frame.size.height / 2 - frame.size.height / 4, frame.size.width / 2, frame.size.height / 2)
            createLayers(image: image, imageFrame: imageFrame)
        }
    }
    
    private var imageShape: CAShapeLayer!
    @IBInspectable public var imageColorOn: NSColor! = NSColor(red: 255/255, green: 172/255, blue: 51/255, alpha: 1.0) {
        didSet {
            if (selected) {
                imageShape.fillColor = imageColorOn.CGColor
            }
        }
    }
    @IBInspectable public var imageColorOff: NSColor! = NSColor(red: 136/255, green: 153/255, blue: 166/255, alpha: 1.0) {
        didSet {
            if (!selected) {
                imageShape.fillColor = imageColorOff.CGColor
            }
        }
    }
    
    private var circleShape: CAShapeLayer!
    private var circleMask: CAShapeLayer!
    @IBInspectable public var circleColor: NSColor! = NSColor(red: 255/255, green: 172/255, blue: 51/255, alpha: 1.0) {
        didSet {
            circleShape.fillColor = circleColor.CGColor
        }
    }
    
    private var lines: [CAShapeLayer]! = []
    @IBInspectable public var lineColor: NSColor! = NSColor(red: 250/255, green: 120/255, blue: 68/255, alpha: 1.0) {
        didSet {
            for i in 0 ..< 5 {
                lines[i].strokeColor = lineColor.CGColor
            }
        }
    }
    
    private let circleTransform = CAKeyframeAnimation(keyPath: "transform")
    private let circleMaskTransform = CAKeyframeAnimation(keyPath: "transform")
    private let lineStrokeStart = CAKeyframeAnimation(keyPath: "strokeStart")
    private let lineStrokeEnd = CAKeyframeAnimation(keyPath: "strokeEnd")
    private let lineOpacity = CAKeyframeAnimation(keyPath: "opacity")
    private let imageTransform = CAKeyframeAnimation(keyPath: "transform")
    
    @IBInspectable public var duration: Double = 1.0 {
        didSet {
            circleTransform.duration = 0.333 * duration // 0.0333 * 10
            circleMaskTransform.duration = 0.333 * duration // 0.0333 * 10
            lineStrokeStart.duration = 0.6 * duration //0.0333 * 18
            lineStrokeEnd.duration = 0.6 * duration //0.0333 * 18
            lineOpacity.duration = 1.0 * duration //0.0333 * 30
            imageTransform.duration = 1.0 * duration //0.0333 * 30
        }
    }
    
    @IBInspectable public var selected : Bool {
        didSet {
            if (selected != oldValue) {
                if selected {
                    imageShape.fillColor = imageColorOn.CGColor
                } else {
                    deselect()
                }
            }
        }
    }
    
    public var alreadyCreatedLayer : Bool = false
    
    public convenience init() {
        self.init(frame: CGRectZero)
    }
    
    public override convenience init(frame: CGRect) {
        let image = NSImage(named: "star")
        self.init(frame: frame, image: image)
    }
    
    public convenience init(frame: CGRect, image: NSImage!) {
        let imageFrame = CGRectMake(frame.size.width / 2 - frame.size.width / 4, frame.size.height / 2 - frame.size.height / 4, frame.size.width / 2, frame.size.height / 2)
        self.init(frame: frame, image: image, imageFrame: imageFrame)
    }
    
    public init(frame: CGRect, image: NSImage!, imageFrame: CGRect) {
        self.selected = false
        super.init(frame: frame)
        self.image = image
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.selected = false
        super.init(coder: aDecoder)
    }
    
    public override func drawRect(dirtyRect: NSRect) {
        // do nothing, we got this :D
    }
    
    private func createLayers(image image: NSImage!, imageFrame: CGRect) {
        
        self.layer = CALayer()
        self.wantsLayer = true
        
        let imgCenterPoint = CGPointMake(imageFrame.origin.x + imageFrame.width / 2, imageFrame.origin.y + imageFrame.height / 2)
        let lineFrame = CGRectMake(imageFrame.origin.x - imageFrame.width / 4, imageFrame.origin.y - imageFrame.height / 4 , imageFrame.width * 1.5, imageFrame.height * 1.5)
        
        //===============
        // circle layer
        //===============
        circleShape = CAShapeLayer()
        circleShape.bounds = imageFrame
        circleShape.position = imgCenterPoint
        circleShape.path = NSBezierPath(ovalInRect: imageFrame).CGPath
        circleShape.fillColor = circleColor.CGColor
        circleShape.transform = CATransform3DMakeScale(0.0, 0.0, 1.0)
        self.layer!.addSublayer(circleShape)
        
        circleMask = CAShapeLayer()
        circleMask.bounds = imageFrame
        circleMask.position = imgCenterPoint
        circleMask.fillRule = kCAFillRuleEvenOdd
        circleShape.mask = circleMask
        
        let maskPath = NSBezierPath(rect: imageFrame)
        maskPath.addArcWithCenter(imgCenterPoint, radius: 0.1, startAngle: CGFloat(0.0), endAngle: CGFloat(M_PI * 2), clockwise: true)
        circleMask.path = maskPath.CGPath
        
        //===============
        // line layer
        //===============
        for i in 0 ..< 5 {
            let line = CAShapeLayer()
            line.bounds = lineFrame
            line.position = imgCenterPoint
            line.masksToBounds = true
            line.actions = ["strokeStart": NSNull(), "strokeEnd": NSNull()]
            line.strokeColor = lineColor.CGColor
            line.lineWidth = 1.25
            line.miterLimit = 1.25
            line.path = {
                let path = CGPathCreateMutable()
                CGPathMoveToPoint(path, nil, lineFrame.origin.x + lineFrame.width / 2, lineFrame.origin.y + lineFrame.height / 2)
                CGPathAddLineToPoint(path, nil, lineFrame.origin.x + lineFrame.width / 2, lineFrame.origin.y)
                return path
                }()
            line.lineCap = kCALineCapRound
            line.lineJoin = kCALineJoinRound
            line.strokeStart = 0.0
            line.strokeEnd = 0.0
            line.opacity = 0.0
            line.transform = CATransform3DMakeRotation(CGFloat(M_PI) / 5 * (CGFloat(i) * 2 + 1), 0.0, 0.0, 1.0)
            self.layer!.addSublayer(line)
            lines.append(line)
        }
        
        //===============
        // image layer
        //===============
        imageShape = CAShapeLayer()
        imageShape.bounds = imageFrame
        imageShape.position = imgCenterPoint
        imageShape.path = NSBezierPath(rect: imageFrame).CGPath
        imageShape.fillColor = imageColorOff.CGColor
        imageShape.actions = ["fillColor": NSNull()]
        self.layer!.addSublayer(imageShape)
        
        
        let imageData = image.TIFFRepresentation
        let source = CGImageSourceCreateWithData(imageData!, nil)
        let maskRef = CGImageSourceCreateImageAtIndex(source!, 0, nil)
        
        let imageMask = CALayer()
        imageMask.contents = maskRef
        imageMask.bounds = imageFrame
        imageMask.position = imgCenterPoint
        imageShape.mask = imageMask
        
        //==============================
        // circle transform animation
        //==============================
        circleTransform.duration = 0.333 // 0.0333 * 10
        circleTransform.values = [
            NSValue(CATransform3D: CATransform3DMakeScale(0.0,  0.0,  1.0)),    //  0/10
            NSValue(CATransform3D: CATransform3DMakeScale(0.5,  0.5,  1.0)),    //  1/10
            NSValue(CATransform3D: CATransform3DMakeScale(1.0,  1.0,  1.0)),    //  2/10
            NSValue(CATransform3D: CATransform3DMakeScale(1.2,  1.2,  1.0)),    //  3/10
            NSValue(CATransform3D: CATransform3DMakeScale(1.3,  1.3,  1.0)),    //  4/10
            NSValue(CATransform3D: CATransform3DMakeScale(1.37, 1.37, 1.0)),    //  5/10
            NSValue(CATransform3D: CATransform3DMakeScale(1.4,  1.4,  1.0)),    //  6/10
            NSValue(CATransform3D: CATransform3DMakeScale(1.4,  1.4,  1.0))     // 10/10
        ]
        circleTransform.keyTimes = [
            0.0,    //  0/10
            0.1,    //  1/10
            0.2,    //  2/10
            0.3,    //  3/10
            0.4,    //  4/10
            0.5,    //  5/10
            0.6,    //  6/10
            1.0     // 10/10
        ]
        
        circleMaskTransform.duration = 0.333 // 0.0333 * 10
        circleMaskTransform.values = [
            NSValue(CATransform3D: CATransform3DIdentity),                                                              //  0/10
            NSValue(CATransform3D: CATransform3DIdentity),                                                              //  2/10
            NSValue(CATransform3D: CATransform3DMakeScale(imageFrame.width * 1.25,  imageFrame.height * 1.25,  1.0)),   //  3/10
            NSValue(CATransform3D: CATransform3DMakeScale(imageFrame.width * 2.688, imageFrame.height * 2.688, 1.0)),   //  4/10
            NSValue(CATransform3D: CATransform3DMakeScale(imageFrame.width * 3.923, imageFrame.height * 3.923, 1.0)),   //  5/10
            NSValue(CATransform3D: CATransform3DMakeScale(imageFrame.width * 4.375, imageFrame.height * 4.375, 1.0)),   //  6/10
            NSValue(CATransform3D: CATransform3DMakeScale(imageFrame.width * 4.731, imageFrame.height * 4.731, 1.0)),   //  7/10
            NSValue(CATransform3D: CATransform3DMakeScale(imageFrame.width * 5.0,   imageFrame.height * 5.0,   1.0)),   //  9/10
            NSValue(CATransform3D: CATransform3DMakeScale(imageFrame.width * 5.0,   imageFrame.height * 5.0,   1.0))    // 10/10
        ]
        circleMaskTransform.keyTimes = [
            0.0,    //  0/10
            0.2,    //  2/10
            0.3,    //  3/10
            0.4,    //  4/10
            0.5,    //  5/10
            0.6,    //  6/10
            0.7,    //  7/10
            0.9,    //  9/10
            1.0     // 10/10
        ]
        
        //==============================
        // line stroke animation
        //==============================
        lineStrokeStart.duration = 0.6 //0.0333 * 18
        lineStrokeStart.values = [
            0.0,    //  0/18
            0.0,    //  1/18
            0.18,   //  2/18
            0.2,    //  3/18
            0.26,   //  4/18
            0.32,   //  5/18
            0.4,    //  6/18
            0.6,    //  7/18
            0.71,   //  8/18
            0.89,   // 17/18
            0.92    // 18/18
        ]
        lineStrokeStart.keyTimes = [
            0.0,    //  0/18
            0.056,  //  1/18
            0.111,  //  2/18
            0.167,  //  3/18
            0.222,  //  4/18
            0.278,  //  5/18
            0.333,  //  6/18
            0.389,  //  7/18
            0.444,  //  8/18
            0.944,  // 17/18
            1.0,    // 18/18
        ]
        
        lineStrokeEnd.duration = 0.6 //0.0333 * 18
        lineStrokeEnd.values = [
            0.0,    //  0/18
            0.0,    //  1/18
            0.32,   //  2/18
            0.48,   //  3/18
            0.64,   //  4/18
            0.68,   //  5/18
            0.92,   // 17/18
            0.92    // 18/18
        ]
        lineStrokeEnd.keyTimes = [
            0.0,    //  0/18
            0.056,  //  1/18
            0.111,  //  2/18
            0.167,  //  3/18
            0.222,  //  4/18
            0.278,  //  5/18
            0.944,  // 17/18
            1.0,    // 18/18
        ]
        
        lineOpacity.duration = 1.0 //0.0333 * 30
        lineOpacity.values = [
            1.0,    //  0/30
            1.0,    // 12/30
            0.0     // 17/30
        ]
        lineOpacity.keyTimes = [
            0.0,    //  0/30
            0.4,    // 12/30
            0.567   // 17/30
        ]
        
        //==============================
        // image transform animation
        //==============================
        imageTransform.duration = 1.0 //0.0333 * 30
        imageTransform.values = [
            NSValue(CATransform3D: CATransform3DMakeScale(0.0,   0.0,   1.0)),  //  0/30
            NSValue(CATransform3D: CATransform3DMakeScale(0.0,   0.0,   1.0)),  //  3/30
            NSValue(CATransform3D: CATransform3DMakeScale(1.2,   1.2,   1.0)),  //  9/30
            NSValue(CATransform3D: CATransform3DMakeScale(1.25,  1.25,  1.0)),  // 10/30
            NSValue(CATransform3D: CATransform3DMakeScale(1.2,   1.2,   1.0)),  // 11/30
            NSValue(CATransform3D: CATransform3DMakeScale(0.9,   0.9,   1.0)),  // 14/30
            NSValue(CATransform3D: CATransform3DMakeScale(0.875, 0.875, 1.0)),  // 15/30
            NSValue(CATransform3D: CATransform3DMakeScale(0.875, 0.875, 1.0)),  // 16/30
            NSValue(CATransform3D: CATransform3DMakeScale(0.9,   0.9,   1.0)),  // 17/30
            NSValue(CATransform3D: CATransform3DMakeScale(1.013, 1.013, 1.0)),  // 20/30
            NSValue(CATransform3D: CATransform3DMakeScale(1.025, 1.025, 1.0)),  // 21/30
            NSValue(CATransform3D: CATransform3DMakeScale(1.013, 1.013, 1.0)),  // 22/30
            NSValue(CATransform3D: CATransform3DMakeScale(0.96,  0.96,  1.0)),  // 25/30
            NSValue(CATransform3D: CATransform3DMakeScale(0.95,  0.95,  1.0)),  // 26/30
            NSValue(CATransform3D: CATransform3DMakeScale(0.96,  0.96,  1.0)),  // 27/30
            NSValue(CATransform3D: CATransform3DMakeScale(0.99,  0.99,  1.0)),  // 29/30
            NSValue(CATransform3D: CATransform3DIdentity)                       // 30/30
        ]
        imageTransform.keyTimes = [
            0.0,    //  0/30
            0.1,    //  3/30
            0.3,    //  9/30
            0.333,  // 10/30
            0.367,  // 11/30
            0.467,  // 14/30
            0.5,    // 15/30
            0.533,  // 16/30
            0.567,  // 17/30
            0.667,  // 20/30
            0.7,    // 21/30
            0.733,  // 22/30
            0.833,  // 25/30
            0.867,  // 26/30
            0.9,    // 27/30
            0.967,  // 29/30
            1.0     // 30/30
        ]
    }
    
    public override func mouseDown(theEvent: NSEvent) {
        self.layer?.opacity = 0.4
        super.mouseDown(theEvent)
        self.mouseUp(theEvent)
    }

    public override func mouseUp(theEvent: NSEvent) {
        super.mouseUp(theEvent)
        
        // we can't simply use NSEvent's locationInWindow here because it's stale by the time we mouse up
        let mouseLocation = NSEvent.mouseLocation()
        let rectFromScreen = self.window?.convertRectFromScreen(NSRect(x: mouseLocation.x, y: mouseLocation.y, width: 0, height: 0))
        let windowLocation = NSPoint(x: rectFromScreen!.origin.x, y: rectFromScreen!.origin.y)
        let locationInView = self.convertPoint(windowLocation, fromView: nil)
        
        self.layer?.opacity = 1.0
        if self.mouse(locationInView, inRect: self.bounds) {
            if self.selected {
                self.deselect()
            } else {
                self.select()
            }
        }
    }
    
    public func select() {
        selected = true
        imageShape.fillColor = imageColorOn.CGColor
        
        CATransaction.begin()
        
        circleShape.addAnimation(circleTransform, forKey: "transform")
        circleMask.addAnimation(circleMaskTransform, forKey: "transform")
        imageShape.addAnimation(imageTransform, forKey: "transform")
        
        for i in 0 ..< 5 {
            lines[i].addAnimation(lineStrokeStart, forKey: "strokeStart")
            lines[i].addAnimation(lineStrokeEnd, forKey: "strokeEnd")
            lines[i].addAnimation(lineOpacity, forKey: "opacity")
        }
        
        CATransaction.commit()
    }
    
    public func deselect() {
        selected = false
        imageShape.fillColor = imageColorOff.CGColor
        
        // remove all animations
        circleShape.removeAllAnimations()
        circleMask.removeAllAnimations()
        imageShape.removeAllAnimations()
        lines[0].removeAllAnimations()
        lines[1].removeAllAnimations()
        lines[2].removeAllAnimations()
        lines[3].removeAllAnimations()
        lines[4].removeAllAnimations()
    }
}

// Extensions to help bridge some missing features from AppKit
extension NSBezierPath
{
    var CGPath : CGPathRef! {
        if self.elementCount == 0 {
            return nil
        }
        
        let path = CGPathCreateMutable()
        var didClosePath = false
        
        for i in 0..<self.elementCount {
            var points = [NSPoint](count: 3, repeatedValue: NSZeroPoint)
            
            switch self.elementAtIndex(i, associatedPoints: &points) {
            case .MoveToBezierPathElement:CGPathMoveToPoint(path, nil, points[0].x, points[0].y)
            case .LineToBezierPathElement:CGPathAddLineToPoint(path, nil, points[0].x, points[0].y)
            case .CurveToBezierPathElement:CGPathAddCurveToPoint(path, nil, points[0].x, points[0].y, points[1].x, points[1].y, points[2].x, points[2].y)
            case .ClosePathBezierPathElement:CGPathCloseSubpath(path)
            didClosePath = true
            }
        }
        
        if !didClosePath {
            CGPathCloseSubpath(path)
        }
        
        return CGPathCreateCopy(path)!
    }
    
    func addArcWithCenter(center: NSPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) {
        let startAngleRadian = ((startAngle) * (180.0 / CGFloat(M_PI)))
        let endAngleRadian = ((endAngle) * (180.0 / CGFloat(M_PI)))
        self.appendBezierPathWithArcWithCenter(center, radius: radius, startAngle: startAngleRadian, endAngle: endAngleRadian, clockwise: !clockwise)
    }
}
