//
//  keyPressed.swift
//  Scroller
//
//  Created by Clayton Ward on 9/8/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit

class keyPressed: NSObject {
    
    var numberOfKeys: Int!
    var staff: Int!
    
    override init()
    {
        
    }
    
    init(numberOfKeys: Int, staff: Int) {
        self.numberOfKeys = numberOfKeys
        self.staff = staff
    }
}
