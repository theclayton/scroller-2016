
//
//  noteGuiderView.swift
//  Scroller
//
//  Created by Clayton Ward on 8/8/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit

class drawNoteGuiderView: UIView {
    
    var noteGuiderIsHighlighted: Bool = true
    
    override func draw(_ rect: CGRect) {
        
        if noteGuiderIsHighlighted {
            showNoteGuiderHighlight()
        }
        
        let noteGuider = UIBezierPath()
        noteGuider.lineWidth = 1.0
        
        /*
         ______
         |      |
         |__  __|
         \/
         
         */
        
        noteGuider.move(to: CGPoint(x: 0.0, y: 0.0))
        noteGuider.addLine(to: CGPoint(x: 0.0, y: 21.0))
        
        noteGuider.addQuadCurve(to: CGPoint(x: 18.0, y: 32.0), controlPoint: CGPoint(x: 18.0, y: 18.0))
        
        noteGuider.addLine(to: CGPoint(x: 20.0, y: 32.0))
        
        noteGuider.addQuadCurve(to: CGPoint(x: 38.0, y: 21.0), controlPoint: CGPoint(x: 20.0, y: 18.0))
        
        noteGuider.addLine(to: CGPoint(x: 38, y: 0.0))
        noteGuider.addLine(to: CGPoint(x: 0.0, y: 0.0))
        
        UIColor.black.setFill(alpha = 0.85)
        noteGuider.fill()
        
        UIColor.black.setStroke()
        noteGuider.stroke()
        
    }
    func showNoteGuiderHighlight() {
        
        let highlight = UIBezierPath()
        highlight.lineWidth = 1.0
        
        highlight.move(to: CGPoint(x: 17.0, y: 20.0))
        highlight.addLine(to: CGPoint(x: 13.0, y: 21.0))
        highlight.addLine(to: CGPoint(x: 13.0, y: self.bounds.height))
        
        highlight.addLine(to: CGPoint(x: 25.0, y: self.bounds.height))
        highlight.addLine(to: CGPoint(x: 25.0, y: 21.0))
        highlight.addLine(to: CGPoint(x: 21.0, y: 20.0))
        highlight.addLine(to: CGPoint(x: 17.0, y: 20.0))
        
        UIColor(red: 0/255.0, green: 225/255.0, blue: 255/255.0, alpha: 0.25).setFill()
        highlight.fill()
        
        UIColor(red: 0/255.0, green: 225/255.0, blue: 255/255.0, alpha: 0.75).setStroke()
        highlight.stroke()
        
    }
}
