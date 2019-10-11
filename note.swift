//
//  note.swift
//  Scroller
//
//  Created by Clayton Ward on 8/6/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit

class note: NSObject {
    
    var notePos: CGPoint!
    var noteType: String!
    var noteStem: String!
    var noteStemLength: CGFloat!
    var notePitch: Int!
    var noteDuration: Int!
    var noteAlter: Int!
    var noteStep: String!
    var noteStaff: Int!
    var noteDot: Bool!
    var noteTuplet: String!
    var noteGrace: Bool!
    var notePlay: Bool!

    var beam1: String!
    var beam2: String!
    var beam3: String!
    var beam4: String!
    
    override init()
    {
        
    }
    
    init(notePos: CGPoint, noteType: String, noteStem: String, noteStemLength: CGFloat, notePitch: Int, noteDuration: Int, noteAlter: Int, noteStep: String, noteStaff: Int, noteDot: Bool, noteTuplet: String, noteGrace: Bool, notePlay: Bool, beam1: String, beam2: String, beam3: String, beam4: String) {
        self.notePos = notePos
        self.noteType = noteType
        self.noteStem = noteStem
        self.noteStemLength = noteStemLength
        self.notePitch = notePitch
        self.noteDuration = noteDuration
        self.noteAlter = noteAlter
        self.noteStep = noteStep
        self.noteStaff = noteStaff
        self.noteDot = noteDot
        self.noteTuplet = noteTuplet
        self.noteGrace = noteGrace
        self.notePlay = notePlay

        self.beam1 = beam1
        self.beam2 = beam2
        self.beam3 = beam3
        self.beam4 = beam4
    }
    
    override var description: String {
        return "note pos: \(notePos!), type: \(noteType!), stem: \(noteStem!), pitch: \(notePitch!), step: \(noteStep!), alter: \(noteAlter!)"
    }
}
