//
//  repeatSection.swift
//  Scroller
//
//  Created by Clayton Ward on 11/1/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import Foundation

import UIKit

class repeatSection: NSObject {
    
    var measureNumber: Int!
    var todoSongWidth: CGFloat!
    var noteNumber: Int!
    var restNumber: Int!
    var octaveShiftArrayIndex: Int!
    var arpeggioArrayIndex: Int!
    var tieArrayIndex: Int!
    
    override init()
    {
        
    }
    
    init(measureNumber: Int, todoSongWidth: CGFloat, noteNumber: Int, restNumber: Int, octaveShiftArrayIndex: Int, arpeggioArrayIndex: Int, tieArrayIndex: Int) {
        self.measureNumber = measureNumber
        self.todoSongWidth = todoSongWidth
        self.noteNumber = noteNumber
        self.restNumber = restNumber
        self.octaveShiftArrayIndex = octaveShiftArrayIndex
        self.arpeggioArrayIndex = arpeggioArrayIndex
        self.tieArrayIndex = tieArrayIndex
    }
}
