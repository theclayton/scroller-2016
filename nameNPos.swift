//
//  nameNPos.swift
//  Scroller
//
//  Created by Clayton Ward on 10/31/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit

class nameNPos: NSObject {
    
    var name: String!
    var x1Pos: CGFloat!
    var x2Pos: CGFloat!
    var yPos: CGFloat!
    
    override init()
    {
        
    }
    
    init(name: String, x1Pos: CGFloat, x2Pos: CGFloat, yPos: CGFloat) {
        self.name = name
        self.x1Pos = x1Pos
        self.x2Pos = x2Pos
        self.yPos = yPos
    }
}
