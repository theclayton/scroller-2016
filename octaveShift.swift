//
//  octaveShift.swift
//  Scroller
//
//  Created by Clayton Ward on 10/15/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit

class octaveShift: NSObject {
    
    var type: String!
    var size: Int!
    var number: Int!
    var measureIndex: Int!
    var startEndPointX: CGFloat!
    
    override init()
    {
        
    }
    
    init(type: String, size: Int, number: Int, measureIndex: Int, startEndPointX: CGFloat) {
        self.type = type
        self.size = size
        self.number = number
        self.measureIndex = measureIndex
        self.startEndPointX = startEndPointX
    }
}
