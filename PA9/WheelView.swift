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
            return tireRadius - (tireWidth / 1.5)
        }
    }
    
    var hubRadius: CGFloat {
        get {
            return wheelRadius / 3
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
        // Standard silver color:
        UIColor(red: (200/255), green: (215/255), blue: (230/255), alpha: 1.0),
        // White color:
        UIColor(red: (235/255), green: (235/255), blue: (235/255), alpha: 1.0),
        // Black color:
UIColor.black,
        // Bronze color:
        UIColor(red: (175/255), green: (130/255), blue: (95/255), alpha: 1.0),
        // Gunmetal color:
        UIColor(red: (95/255), green: (100/255), blue: (95/255), alpha: 1.0),
    ]
    
    var wheelColor: UIColor! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    let tireColor: UIColor = UIColor(red: (35/255), green: (10/255), blue: 0, alpha: 1.0)
    
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
        
        wheelColor = wheelColorChoices[0]
    }
    
    override func draw(_ rect: CGRect) {
        // Draw the tire
        drawCircle(wheelCenterPoint, radius: tireRadius, borderWidth: tireWidth, borderColor: tireColor, innerColor: UIColor.clear, numberOfSpokes: 0)
        
        // Draw the outer rim of the wheel and its spokes
        drawCircle(wheelCenterPoint, radius: wheelRadius, borderWidth: 10, borderColor: wheelColor, innerColor: UIColor.clear, numberOfSpokes: self.numberOfSpokes)

        // Draw the wheel hub
        drawCircle(wheelCenterPoint, radius: hubRadius, borderWidth: 0, borderColor: wheelColor, innerColor: wheelColor, numberOfSpokes: 0)
    }
    
    func drawCircle(_ centerPoint: CGPoint, radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor, innerColor: UIColor, numberOfSpokes: Int) {
        let circlePath = UIBezierPath(
            arcCenter: centerPoint,
            radius: radius,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: true
        )
        
        circlePath.lineWidth = borderWidth
        
        let circleStrokeColor = borderColor
        circleStrokeColor.setStroke()
        circlePath.stroke()

        let circleFillColor = innerColor
        circleFillColor.setFill()
        circlePath.fill()
        
        if numberOfSpokes > 0 {
            drawCircleSpokes(circlePath, numberOfSpokes: numberOfSpokes, hasCrossSpokes: hasCrossSpokes, centerPoint: wheelCenterPoint, radius: radius)
        }
        
        circlePath.close()
    }
    
    func drawCircleSpokes(_ path: UIBezierPath, numberOfSpokes: Int, hasCrossSpokes: Bool, centerPoint: CGPoint, radius: CGFloat) {
        if hasCrossSpokes == false {
            for n in 0..<numberOfSpokes {
                path.move(to: centerPoint)
                
                // I used M_PI_2 because I wanted the first spoke to be drawn at 90 degrees,
                // but it looks like it's getting drawn at 270 degrees instead.
                path.addLine(to: CGPoint(
                    x: Double(centerPoint.x) + Double(radius) * cos((Double.pi/2) + (Double(n) * 2 * Double.pi / Double(numberOfSpokes))),
                    y: Double(centerPoint.y) + Double(radius) * sin((Double.pi/2) + (Double(n) * 2 * Double.pi / Double(numberOfSpokes)))
                    ))
                
                path.stroke()
            }
        } else {
            // Do the same as above until I can figure out how to draw cross spokes
            
            for n in 0..<numberOfSpokes {
                path.move(to: centerPoint)
                
                path.addLine(to: CGPoint(
                    x: Double(centerPoint.x) + Double(radius) * cos((Double.pi/2) + (Double(n) * 2 * Double.pi / Double(numberOfSpokes))),
                    y: Double(centerPoint.y) + Double(radius) * sin((Double.pi/2) + (Double(n) * 2 * Double.pi / Double(numberOfSpokes)))
                    ))
                
                path.stroke()
            }
        }
    }
}
