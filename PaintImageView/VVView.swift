
//
//  VVView.swift
//  PaintImageView
//
//  Created by Make on 2019/8/7.
//  Copyright © 2019 ios. All rights reserved.
//

import UIKit

class VVView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        bez()
    }
    func bez() {
        //// Color Declarations
        let color = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 511, y: 126, width: 579, height: 563))
        color.setFill()
        ovalPath.fill()
        UIColor.black.setStroke()
        ovalPath.lineWidth = 10
        ovalPath.lineJoinStyle = .round
        ovalPath.stroke()
        
        
        //// Star Drawing
        let starPath = UIBezierPath()
        starPath.move(to: CGPoint(x: 739, y: 184))
        starPath.addLine(to: CGPoint(x: 791.72, y: 255.53))
        starPath.addLine(to: CGPoint(x: 881.18, y: 280.05))
        starPath.addLine(to: CGPoint(x: 824.31, y: 348.77))
        starPath.addLine(to: CGPoint(x: 826.87, y: 435.45))
        starPath.addLine(to: CGPoint(x: 739, y: 406.4))
        starPath.addLine(to: CGPoint(x: 651.13, y: 435.45))
        starPath.addLine(to: CGPoint(x: 653.69, y: 348.77))
        starPath.addLine(to: CGPoint(x: 596.82, y: 280.05))
        starPath.addLine(to: CGPoint(x: 686.28, y: 255.53))
        starPath.close()
        color.setFill()
        starPath.fill()
        UIColor.black.setStroke()
        starPath.lineWidth = 10
        starPath.stroke()
        
        
        //// Star 2 Drawing
        let star2Path = UIBezierPath()
        star2Path.move(to: CGPoint(x: 739, y: 503))
        star2Path.addLine(to: CGPoint(x: 754.34, y: 524.61))
        star2Path.addLine(to: CGPoint(x: 780.37, y: 532.02))
        star2Path.addLine(to: CGPoint(x: 763.82, y: 552.79))
        star2Path.addLine(to: CGPoint(x: 764.57, y: 578.98))
        star2Path.addLine(to: CGPoint(x: 739, y: 570.2))
        star2Path.addLine(to: CGPoint(x: 713.43, y: 578.98))
        star2Path.addLine(to: CGPoint(x: 714.18, y: 552.79))
        star2Path.addLine(to: CGPoint(x: 697.63, y: 532.02))
        star2Path.addLine(to: CGPoint(x: 723.66, y: 524.61))
        star2Path.close()
        color.setFill()
        star2Path.fill()
        UIColor.black.setStroke()
        star2Path.lineWidth = 10
        star2Path.stroke()
        
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 920, y: 663))
        bezierPath.addCurve(to: CGPoint(x: 1078.5, y: 340), controlPoint1: CGPoint(x: 923, y: 655), controlPoint2: CGPoint(x: 894.5, y: 457))
        color.setFill()
        bezierPath.fill()
        UIColor.black.setStroke()
        bezierPath.lineWidth = 10
        bezierPath.stroke()
        
        
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 620, y: 623))
        bezier2Path.addCurve(to: CGPoint(x: 735, y: 410), controlPoint1: CGPoint(x: 623, y: 620), controlPoint2: CGPoint(x: 643, y: 512))
        color.setFill()
        bezier2Path.fill()
        UIColor.black.setStroke()
        bezier2Path.lineWidth = 10
        bezier2Path.stroke()
        
        
        //// Bezier 3 Drawing
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: 822, y: 257))
        bezier3Path.addCurve(to: CGPoint(x: 959, y: 171), controlPoint1: CGPoint(x: 822, y: 257), controlPoint2: CGPoint(x: 902, y: 171))
        color.setFill()
        bezier3Path.fill()
        UIColor.black.setStroke()
        bezier3Path.lineWidth = 10
        bezier3Path.stroke()
        
        
        //// Star 3 Drawing
        let star3Path = UIBezierPath()
        star3Path.move(to: CGPoint(x: 263.5, y: 171))
        star3Path.addLine(to: CGPoint(x: 298.24, y: 220.66))
        star3Path.addLine(to: CGPoint(x: 357.18, y: 237.68))
        star3Path.addLine(to: CGPoint(x: 319.71, y: 285.39))
        star3Path.addLine(to: CGPoint(x: 321.4, y: 345.57))
        star3Path.addLine(to: CGPoint(x: 263.5, y: 325.4))
        star3Path.addLine(to: CGPoint(x: 205.6, y: 345.57))
        star3Path.addLine(to: CGPoint(x: 207.29, y: 285.39))
        star3Path.addLine(to: CGPoint(x: 169.82, y: 237.68))
        star3Path.addLine(to: CGPoint(x: 228.76, y: 220.66))
        star3Path.close()
        color.setFill()
        star3Path.fill()
        UIColor.black.setStroke()
        star3Path.lineWidth = 10
        star3Path.stroke()
    }

}
