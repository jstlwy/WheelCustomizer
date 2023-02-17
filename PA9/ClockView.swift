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
    var clockTimer: Timer!
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
    let clockBezelColor = UIColor.black
    let clockFaceColor = UIColor.white
    let secondHandColor: UIColor = UIColor.red
    let minuteHandColor: UIColor = UIColor.green
    let hourHandColor: UIColor = UIColor.blue
    
    // Frequently reused math constants
    let topPosRad: Double = Double.pi / 2
    let fullRotRad: Double = 2 * Double.pi

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
        
        clockTimer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(ClockView.incrementByOneSecond(_:)),
            userInfo: nil,
            repeats: true
        )
        
        clockTimerIsPaused = false
    }
    
    @objc func incrementByOneSecond(_ timer: Timer) {
        seconds += 1
        minutes = (seconds / 60)
        hours = (minutes / 60)
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        // Draw the outside of the clock
        drawCircle(
            clockCenterPoint,
            radius: clockRadius,
            borderWidth: clockBezelWidth,
            borderColor: clockBezelColor,
            innerColor: clockFaceColor
        )
        
        // Draw second hand
        drawClockHand(
            seconds,
            handLength: clockRadius,
            handColor: secondHandColor,
            amountPerCircle: 60
        )
        
        // Draw minute hand
        drawClockHand(
            minutes,
            handLength: minuteHandLength,
            handColor: minuteHandColor,
            amountPerCircle: 60
        )
        
        // Draw hour hand
        drawClockHand(
            hours,
            handLength: hourHandLength,
            handColor: hourHandColor,
            amountPerCircle: 12
        )
        
        // Draw center hub of clock
        drawCircle(
            clockCenterPoint,
            radius: clockRadius / 10,
            borderWidth: 0,
            borderColor: clockBezelColor,
            innerColor: clockBezelColor
        )
    }
    
    func drawCircle(_ centerPoint: CGPoint, radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor, innerColor: UIColor) {
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

        circlePath.close()
    }
    
    func drawClockHand(_ timeInterval: Int, handLength: CGFloat, handColor: UIColor, amountPerCircle: Double) {
        let handPath = UIBezierPath()
        handPath.move(to: clockCenterPoint)
        
        let handPosRad = topPosRad + (fullRotRad * (Double(timeInterval) / amountPerCircle))
        handPath.addLine(to: CGPoint(
                x: Double(clockCenterPoint.x) - (handLength * cos(handPosRad)),
                y: Double(clockCenterPoint.y) - (handLength * sin(handPosRad))
            )
        )

        handPath.lineWidth = clockBezelWidth
        handColor.setStroke()
        handPath.stroke()
        handPath.close()
    }
    
    func hitTimerPauseButton() {
        if clockTimerIsPaused == false {
            clockTimer.invalidate()
        } else {
            clockTimer = Timer.scheduledTimer(
                timeInterval: 1.0,
                target: self,
                selector: #selector(ClockView.incrementByOneSecond(_:)),
                userInfo: nil,
                repeats: true
            )
        }
        clockTimerIsPaused = !clockTimerIsPaused
    }
}
