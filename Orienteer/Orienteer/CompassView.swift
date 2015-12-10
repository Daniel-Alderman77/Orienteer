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
        
        // Create path
        let path = UIBezierPath(arcCenter: center,
            radius: radius/2 - circleWidth/2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)
        
        path.lineWidth = circleWidth
        compassColor.setStroke()
        
        // Draw path
        path.stroke()
    }
}
