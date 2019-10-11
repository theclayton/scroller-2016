//
//  notePitch.swift
//  Scroller
//
//  Created by Clayton Ward on 8/10/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit

class notePitchClass {
    
    var noteStep: String!
    var noteOctave: String!
    var noteAlter: Int!
    
    // MARK: NOTE MIDI NUMBER
    func findNoteNumber() -> Int {
        if noteStep == "C" && noteOctave == "8" {
            return 108
        } else if noteStep == "B" && noteOctave == "7" {
            return 107
        } else if noteStep == "B" && noteOctave == "7" {
            return 106
        } else if noteStep == "A" && noteOctave == "7" {
            return 105
        } else if noteStep == "A" && noteOctave == "7" {
            return 104
        } else if noteStep == "G" && noteOctave == "7" {
            return 103
        } else if noteStep == "G" && noteOctave == "7" {
            return 102
        } else if noteStep == "F" && noteOctave == "7" {
            return 101
        } else if noteStep == "E" && noteOctave == "7" {
            return 100
        } else if noteStep == "E" && noteOctave == "7" {
            return 99
        } else if noteStep == "D" && noteOctave == "7" {
            return 98
        } else if noteStep == "D" && noteOctave == "7" {
            return 97
        } else if noteStep == "C" && noteOctave == "7" {
            return 96
        } else if noteStep == "B" && noteOctave == "6" {
            return 95
        } else if noteStep == "B" && noteOctave == "6" {
            return 94
        } else if noteStep == "A" && noteOctave == "6" {
            return 93
        } else if noteStep == "A" && noteOctave == "6" {
            return 92
        } else if noteStep == "G" && noteOctave == "6" {
            return 91
        } else if noteStep == "G" && noteOctave == "6" {
            return 90
        } else if noteStep == "F" && noteOctave == "6" {
            return 89
        } else if noteStep == "E" && noteOctave == "6" {
            return 88
        } else if noteStep == "E" && noteOctave == "6" {
            return 87
        } else if noteStep == "D" && noteOctave == "6" {
            return 86
        } else if noteStep == "D" && noteOctave == "6" {
            return 85
        } else if noteStep == "C" && noteOctave == "6" {
            return 84
        } else if noteStep == "B" && noteOctave == "5" {
            return 83
        } else if noteStep == "B" && noteOctave == "5" {
            return 82
        } else if noteStep == "A" && noteOctave == "5" {
            return 81
        } else if noteStep == "A" && noteOctave == "5" {
            return 80
        } else if noteStep == "G" && noteOctave == "5" {
            return 79
        } else if noteStep == "G" && noteOctave == "5" {
            return 78
        } else if noteStep == "F" && noteOctave == "5" {
            return 77
        } else if noteStep == "E" && noteOctave == "5" {
            return 76
        } else if noteStep == "E" && noteOctave == "5" {
            return 75
        } else if noteStep == "D" && noteOctave == "5" {
            return 74
        } else if noteStep == "D" && noteOctave == "5" {
            return 73
        } else if noteStep == "C" && noteOctave == "5" {
            return 72
        } else if noteStep == "B" && noteOctave == "4" {
            return 71
        } else if noteStep == "B" && noteOctave == "4" {
            return 70
        } else if noteStep == "A" && noteOctave == "4" {
            return 69
        } else if noteStep == "A" && noteOctave == "4" {
            return 68
        } else if noteStep == "G" && noteOctave == "4" {
            return 67
        } else if noteStep == "G" && noteOctave == "4" {
            return 66
        } else if noteStep == "F" && noteOctave == "4" {
            return 65
        } else if noteStep == "E" && noteOctave == "4" {
            return 64
        } else if noteStep == "E" && noteOctave == "4" {
            return 63
        } else if noteStep == "D" && noteOctave == "4" {
            return 62
        } else if noteStep == "D" && noteOctave == "4" {
            return 61
        } else if noteStep == "C" && noteOctave == "4" {
            return 60
        } else if noteStep == "B" && noteOctave == "3" {
            return 59
        } else if noteStep == "B" && noteOctave == "3" {
            return 58
        } else if noteStep == "A" && noteOctave == "3" {
            return 57
        } else if noteStep == "A" && noteOctave == "3" {
            return 56
        } else if noteStep == "G" && noteOctave == "3" {
            return 55
        } else if noteStep == "G" && noteOctave == "3" {
            return 54
        } else if noteStep == "F" && noteOctave == "3" {
            return 53
        } else if noteStep == "E" && noteOctave == "3" {
            return 52
        } else if noteStep == "E" && noteOctave == "3" {
            return 51
        } else if noteStep == "D" && noteOctave == "3" {
            return 50
        } else if noteStep == "D" && noteOctave == "3" {
            return 49
        } else if noteStep == "C" && noteOctave == "3" {
            return 48
        } else if noteStep == "B" && noteOctave == "2" {
            return 47
        } else if noteStep == "B" && noteOctave == "2" {
            return 46
        } else if noteStep == "A" && noteOctave == "2" {
            return 45
        } else if noteStep == "A" && noteOctave == "2" {
            return 44
        } else if noteStep == "G" && noteOctave == "2" {
            return 43
        } else if noteStep == "G" && noteOctave == "2" {
            return 42
        } else if noteStep == "F" && noteOctave == "2" {
            return 41
        } else if noteStep == "E" && noteOctave == "2" {
            return 40
        } else if noteStep == "E" && noteOctave == "2" {
            return 39
        } else if noteStep == "D" && noteOctave == "2" {
            return 38
        } else if noteStep == "D" && noteOctave == "2" {
            return 37
        } else if noteStep == "C" && noteOctave == "2" {
            return 36
        } else if noteStep == "B" && noteOctave == "1" {
            return 35
        } else if noteStep == "B" && noteOctave == "1" {
            return 34
        } else if noteStep == "A" && noteOctave == "1" {
            return 33
        } else if noteStep == "A" && noteOctave == "1" {
            return 32
        } else if noteStep == "G" && noteOctave == "1" {
            return 31
        } else if noteStep == "G" && noteOctave == "1" {
            return 30
        } else if noteStep == "F" && noteOctave == "1" {
            return 29
        } else if noteStep == "E" && noteOctave == "1" {
            return 28
        } else if noteStep == "E" && noteOctave == "1" {
            return 27
        } else if noteStep == "D" && noteOctave == "1" {
            return 26
        } else if noteStep == "D" && noteOctave == "1" {
            return 25
        } else if noteStep == "C" && noteOctave == "1" {
            return 24
        } else if noteStep == "B" && noteOctave == "0" {
            return 23
        } else if noteStep == "B" && noteOctave == "0" {
            return 22
        } else if noteStep == "A" && noteOctave == "0" {
            return 21
        }
            
        else {
            return 0
        }
    }
}
