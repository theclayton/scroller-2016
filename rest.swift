//
//  rest.swift
//  Scroller
//
//  Created by Clayton Ward on 8/18/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit

class rest: NSObject {
    
    var restType: String!
    var restStaff: Int!
    var restXPos: CGFloat!
    var restDuration: Int!
    var restDot: Bool!

    override init()
    {
        
    }
    
    init(restType: String, restStaff: Int, restXPos: CGFloat, restDuration: Int, restDot: Bool) {
        self.restType = restType
        self.restStaff = restStaff
        self.restXPos = restXPos
        self.restDuration = restDuration
        self.restDot = restDot
    }
    
    override var description: String {
        return "rest type: \(restType!), staff: \(restStaff!), Xpos: \(restXPos!), dot: \(restDot!)"
    }
}
