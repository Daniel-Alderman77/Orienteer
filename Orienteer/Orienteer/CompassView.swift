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
    
    // Define colour
    @IBInspectable var compassColor: UIColor = UIColor.darkGray
    
    // Overiding drawRect function to draw custom paths
    override func draw(_ rect: CGRect) {
        
        // Define center of Cirlce
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        // Define radius of circle
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
        let circleCentre = CGPoint(x: 110, y: 0.0)
        
        // Create line path
        let linePath: UIBezierPath = UIBezierPath()
        
        // Draw path from the center of the circle to the direction the user is heading in
        linePath.move(to: CGPoint(x: 110, y: 75))
        linePath.addLine(to: circleCentre)
        
        circlePath.lineWidth = circleWidth
        compassColor.setStroke()
        
        // Path Width
        linePath.lineWidth = 3
        
        // Draw path
        circlePath.stroke()
        linePath.stroke()
    }
}
