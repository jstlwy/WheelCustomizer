//
//  ClockView.swift
//  PA9
//
//  Created by student on 3/16/16.
//  Copyright © 2016 JLB. All rights reserved.
//

import UIKit

class ClockView: UIView {
    
    // Fundamental elements
    var clockRadius: CGFloat!
    var clockCenterPoint: CGPoint!
    var clockPath: UIBezierPath!
    
    // Clock timer
    var clockTimer: NSTimer!
    var clockTimerIsPaused: Bool!
    
    // Time intervals
    var seconds: Int = 0
    var minutes: Int = 0
    var hours: Int = 0
    
    // Clock part measurements
    var clockBezelWidth: CGFloat!
    var minuteHandLength: CGFloat!
    var hourHandLength: CGFloat!
    
    // Clock part colors
    let clockBezelColor = UIColor.blackColor()
    let clockFaceColor = UIColor.whiteColor()
    let secondHandColor: UIColor = UIColor.redColor()
    let minuteHandColor: UIColor = UIColor.greenColor()
    let hourHandColor: UIColor = UIColor.blueColor()

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

        clockCenterPoint = CGPoint(
            x: (self.bounds.width / 2),
            y: (self.bounds.height / 2)
        )
        
        clockBezelWidth = 3
        
        if self.bounds.height > self.bounds.width {
            clockRadius = CGFloat((self.bounds.width / 2) - clockBezelWidth)
        } else {
            clockRadius = CGFloat((self.bounds.height / 2) - clockBezelWidth)
        }
        
        minuteHandLength = clockRadius * (2/3)
        hourHandLength = clockRadius * (1/2)
        
        clockTimer = NSTimer.scheduledTimerWithTimeInterval(
            1.0,
            target: self,
            selector: Selector("incrementByOneSecond:"),
            userInfo: nil,
            repeats: true
        )
        
        clockTimerIsPaused = false
    }
    
    func incrementByOneSecond(timer: NSTimer) {
        seconds++
        minutes = (seconds / 60)
        hours = (minutes / 60)
        
        setNeedsDisplay()
    }

    override func drawRect(rect: CGRect) {
        // Draw the outside of the clock
        drawCircle(clockCenterPoint, radius: clockRadius, borderWidth: clockBezelWidth, borderColor: clockBezelColor, innerColor: clockFaceColor)
        
        // Draw second hand
        drawClockHand(seconds, handLength: clockRadius, handColor: secondHandColor, amountPerCircle: 60)
        // Draw minute hand
        drawClockHand(minutes, handLength: minuteHandLength, handColor: minuteHandColor, amountPerCircle: 60)
        // Draw hour hand
        drawClockHand(hours, handLength: hourHandLength, handColor: hourHandColor, amountPerCircle: 12)
        
        // Draw center hub of clock
        drawCircle(clockCenterPoint, radius: clockRadius / 10, borderWidth: 0, borderColor: clockBezelColor, innerColor: clockBezelColor)
    }
    
    func drawCircle(centerPoint: CGPoint, radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor, innerColor: UIColor) {
        let circlePath = UIBezierPath(
            arcCenter: centerPoint,
            radius: radius,
            startAngle: 0,
            endAngle: CGFloat(2 * M_PI),
            clockwise: true
        )
        
        circlePath.lineWidth = borderWidth
        
        let circleStrokeColor = borderColor
        circleStrokeColor.setStroke()
        circlePath.stroke()
        
        let circleFillColor = innerColor
        circleFillColor.setFill()
        circlePath.fill()

        circlePath.closePath()
    }
    
    func drawClockHand(timeInterval: Int, handLength: CGFloat, handColor: UIColor, amountPerCircle: Double) {
        let handPath = UIBezierPath()
        
        handPath.moveToPoint(clockCenterPoint)
        
        handPath.addLineToPoint(CGPoint(
            x: Double(clockCenterPoint.x) - Double(handLength) * cos(M_PI_2 + (Double(timeInterval) * 2 * M_PI / amountPerCircle)),
            y: Double(clockCenterPoint.y) - Double(handLength) * sin(M_PI_2 + (Double(timeInterval) * 2 * M_PI / amountPerCircle))
            ))

        handPath.lineWidth = clockBezelWidth
        handColor.setStroke()
        
        handPath.stroke()
        handPath.closePath()
    }
    
    func hitTimerPauseButton() {
        if clockTimerIsPaused == false {
            clockTimer.invalidate()
        } else {
            clockTimer = NSTimer.scheduledTimerWithTimeInterval(
                1.0,
                target: self,
                selector: Selector("incrementByOneSecond:"),
                userInfo: nil,
                repeats: true
            )
        }
        
        clockTimerIsPaused = !clockTimerIsPaused
    }
}
