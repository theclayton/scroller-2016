//
//  tie.swift
//  Scroller
//
//  Created by Clayton Ward on 10/31/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit

class tie: UIView {
    
    override func draw(_ rect: CGRect) {
        
        let tie = UIBezierPath()
        tie.lineWidth = 1.0
        tie.move(to: CGPoint(x: 0, y: self.bounds.height))
        tie.addQuadCurve(to: CGPoint(x: self.bounds.width, y: self.bounds.height), controlPoint: CGPoint(x: self.bounds.width/2, y: 0))
        UIColor.black.setStroke()
        tie.stroke()
    }
}
