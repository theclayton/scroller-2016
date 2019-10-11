//
//  arpeggio.swift
//  Scroller
//
//  Created by Clayton Ward on 10/31/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit

class arpeggio: NSObject {
    
    var measureIndex: Int!
    var xPos: CGFloat!
    var yPos: CGFloat!
    var staff: Int!

    override init()
    {
        
    }
    
    init(measureIndex: Int, xPos: CGFloat, yPos: CGFloat, staff: Int) {
        self.measureIndex = measureIndex
        self.xPos = xPos
        self.yPos = yPos
        self.staff = staff
    }
}
