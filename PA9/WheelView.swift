//
//  WheelView.swift
//  PA9
//
//  Created by student on 3/15/16.
//  Copyright © 2016 JLB. All rights reserved.
//

import UIKit

class WheelView: UIView {

    var wheelCenterPoint: CGPoint!
    var tireRadius: CGFloat!
    
    var wheelRadius: CGFloat {
        get {
            return tireRadius - tireWidth
        }
    }
    
    var wheelSize: Int = 16 {
        didSet {
            if wheelSize < 16 || wheelSize > 20 {
                wheelSize = oldValue
            }
            setNeedsDisplay()
        }
    }
    
    var tireWidth: CGFloat {
        get {
            return CGFloat(55 - wheelSize * 2)
        }
    }
    
    var numberOfSpokes:Int = 5 {
        didSet {
            if numberOfSpokes < 5 || numberOfSpokes > 10 {
                numberOfSpokes = oldValue
            }
            setNeedsDisplay()
        }
    }

    var hasCrossSpokes: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    let wheelColorChoices: [UIColor] = [
        UIColor.lightGrayColor(),
        UIColor.whiteColor(),
        UIColor.blackColor(),
        UIColor.brownColor(),
        UIColor.grayColor()
    ]
    
    var wheelColor: UIColor = UIColor.lightGrayColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        wheelCenterPoint = CGPoint(
            x: (self.bounds.width / 2),
            y: (self.bounds.height / 2)
        )
        
        if self.bounds.height > self.bounds.width {
            tireRadius = CGFloat(self.bounds.width / 2) - tireWidth
        } else {
            tireRadius = CGFloat(self.bounds.height / 2) - tireWidth
        }
    }
    
    override func drawRect(rect: CGRect) {
        // First, we'll draw the tire
        drawCircle(tireRadius, circleWidth: tireWidth, circleColor: UIColor.blackColor(), isFilled: false, hasSpokes: false)
        
        // Second, we'll draw the rim of the wheel
        drawCircle(wheelRadius, circleWidth: 10, circleColor: wheelColor, isFilled: false, hasSpokes: true)

        // Finally, we'll draw the hub of the wheel
        drawCircle(wheelRadius / 3, circleWidth: 0, circleColor: wheelColor, isFilled: true, hasSpokes: false)
    }
    
    func drawCircle(radius: CGFloat, circleWidth: CGFloat, circleColor: UIColor, isFilled: Bool, hasSpokes: Bool) {
        let circlePath = UIBezierPath(
            arcCenter: wheelCenterPoint,
            radius: radius,
            startAngle: 0,
            endAngle: CGFloat(2 * M_PI),
            clockwise: true
        )
        
        if isFilled == true {
            let circleFillColor = circleColor
            circleFillColor.setFill()
            
            circlePath.fill()
            circlePath.closePath()
        } else {
            let circleStrokeColor = circleColor
            circleStrokeColor.setStroke()
            
            circlePath.lineWidth = circleWidth
            circlePath.stroke()
            
            if hasSpokes == true {
                drawCircleSpokes(circlePath, numberOfSpokes: numberOfSpokes, hasCrossSpokes: hasCrossSpokes, centerPoint: wheelCenterPoint, radius: radius)
            }
            
            circlePath.closePath()
        }
    }
    
    func drawCircleSpokes(path: UIBezierPath, numberOfSpokes: Int, hasCrossSpokes: Bool, centerPoint: CGPoint, radius: CGFloat) {
        if hasCrossSpokes == false {
            for n in 0..<numberOfSpokes {
                path.moveToPoint(centerPoint)
                
                // I used M_PI_2 because I wanted the first spoke to be drawn at 90 degrees,
                // but it looks like it's getting drawn at 270 degrees instead.
                path.addLineToPoint(CGPoint(
                    x: Double(centerPoint.x) + Double(radius) * cos(M_PI_2 + (Double(n) * 2 * M_PI / Double(numberOfSpokes))),
                    y: Double(centerPoint.y) + Double(radius) * sin(M_PI_2 + (Double(n) * 2 * M_PI / Double(numberOfSpokes)))
                    ))
                
                path.stroke()
            }
        } else {
            // Do the same exact thing until I can figure out how to draw cross spokes...
            
            for n in 0..<numberOfSpokes {
                path.moveToPoint(wheelCenterPoint)
                
                path.addLineToPoint(CGPoint(
                    x: Double(wheelCenterPoint.x) + Double(wheelRadius) * cos(M_PI_2 + (Double(n) * 2 * M_PI / Double(numberOfSpokes))),
                    y: Double(wheelCenterPoint.y) + Double(wheelRadius) * sin(M_PI_2 + (Double(n) * 2 * M_PI / Double(numberOfSpokes)))
                    ))
                
                path.stroke()
            }
        }
    }
}
