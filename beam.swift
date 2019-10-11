//
//  beam.swift
//  Scroller
//
//  Created by Clayton Ward on 8/15/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit

class beam: NSObject {
    
    var state: String!
    var notePos: CGPoint!
    var noteStem: String!

    override init()
    {
        
    }
    
    init(state: String, notePos: CGPoint, noteStem: String) {
        self.state = state
        self.notePos = notePos
        self.noteStem = noteStem
    }
    
    override var description: String {
        return "state: \(state!), notePos: \(notePos!), noteStem: \(noteStem!)"
    }
}
