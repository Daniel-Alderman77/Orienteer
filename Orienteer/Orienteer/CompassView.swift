//
//  CompassView.swift
//  Orienteer
//
//  Created by Daniel Alderman on 09/12/2015.
//  Copyright © 2015 COMP3222. All rights reserved.
//

import UIKit

let π:CGFloat = CGFloat(M_PI)
let angleInDegrees: CGFloat = 200

@IBDesignable class CompassView: UIView {
    
    // Define colour
    @IBInspectable var compassColor: UIColor = UIColor.darkGray
    
    // Overiding drawRect function to draw custom paths
    override func draw(_ rect: CGRect) {
        
        // Define center of circle
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        // Define diameter of circle
        let diameter: CGFloat = max(bounds.width, bounds.height)
        
        // Define diameter of innner circle
        let innerDiameter: CGFloat = max(bounds.width - 20, bounds.height - 20)
        
        // Thickness of cirlce
        let circleWidth: CGFloat = 4
        
        // Start angle and end angle of circle in radians
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = 2 * π
        
        // Create circle path
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: diameter / 2 - circleWidth / 2,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: true)
        
        // Create circle path
        let innerCirclePath = UIBezierPath(arcCenter: center,
                                      radius: innerDiameter / 2 - circleWidth / 2,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: true)
        
        // Create line path
        let linePath: UIBezierPath = UIBezierPath()
        
        let innerRadius = innerDiameter / 2
        
        let x = center.x + (innerRadius * cos(angleInDegrees * π / 180))
        let y = center.y + (innerRadius * sin(angleInDegrees * π / 180))
        
        // Draw path from the center of the circle to the direction the user is heading in
        linePath.move(to: CGPoint(x: x, y: y))
        linePath.addLine(to: center)
        
        // Circle Width
        circlePath.lineWidth = circleWidth
        compassColor.setStroke()
        
        // Path Width
        linePath.lineWidth = 2
        
        // Draw paths
        circlePath.stroke()
        innerCirclePath.stroke()
        linePath.stroke()
    }
}
