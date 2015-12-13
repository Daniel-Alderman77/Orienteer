//
//  CompassView.swift
//  Orienteer
//
//  Created by Daniel Alderman on 09/12/2015.
//  Copyright © 2015 COMP3222. All rights reserved.
//

import UIKit

let π:CGFloat = CGFloat(M_PI)

@IBDesignable class CompassView: UIView {
    
    @IBInspectable var compassColor: UIColor = UIColor.darkGrayColor()
    
    override func drawRect(rect: CGRect) {
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        // Thickness of cirlce
        let circleWidth: CGFloat = 5
        
        // Start angle and end angle of circle in radians
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = 2 * π
        
        // Create circle path
        let circlePath = UIBezierPath(arcCenter: center,
            radius: radius/2 - circleWidth/2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)
        
        // Centre of circle
        let circleCentre = CGPointMake(150, 0.0)
        
        // Create line path
        let linePath: UIBezierPath = UIBezierPath()
        linePath.moveToPoint(CGPointMake(150, 75))
        linePath.addLineToPoint(circleCentre)
        
        circlePath.lineWidth = circleWidth
        compassColor.setStroke()
        
        linePath.lineWidth = 3
        
        // Draw path
        circlePath.stroke()
        linePath.stroke()
        
    }
}
