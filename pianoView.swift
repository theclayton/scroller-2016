//
//  pianoView.swift
//  Scroller
//
//  Created by Clayton Ward on 8/29/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit

class drawPianoView: UIView {
    
    var pianoHeight: CGFloat = 0.0
    
    var numberOfWhiteKeys: Int = 0
    var numberOfBlackKeys: Int = 0
    
    var whiteKeyWidth: CGFloat = 0.0
    var blackKeyWidth: CGFloat = 0.0
    var xPos: CGFloat = 0.0
    var blackKeyXPos = [Int]()
    
    var lowestNoteStaff: Int?
    var highestNoteStaff: Int?
    
    var currentNotesArray = [note]()
    var whiteKeyPressedArray = [keyPressed]()
    var blackKeyPressedArray = [keyPressed]()
    
    override func draw(_ rect: CGRect) {
        getNumberOfBlackWhiteKeys()
        
        whiteKeyWidth = self.bounds.width/CGFloat(numberOfWhiteKeys)
        blackKeyWidth = whiteKeyWidth/2
        
        for i in 0...numberOfWhiteKeys {
            xPos = CGFloat(i) * whiteKeyWidth
            var isPressed: String = ""
            
            if whiteKeyPressedArray.count > 0 {
                
                for x in 0...whiteKeyPressedArray.count - 1 {
                    let whiteKey = whiteKeyPressedArray[x]
                    
                    if i == whiteKey.numberOfKeys! - 1 {
                        if whiteKey.staff == 1  {
                            isPressed = "staff1"
                        } else if whiteKey.staff == 2 {
                            isPressed = "staff2"
                        }
                    }
                }
            }
            drawWhiteKey(xPos, isPressed: isPressed)
        }
        
        
        for i in 0...blackKeyXPos.count - 1 {
            let thisKeyIndex = blackKeyXPos[i]
            var isPressed: String = ""
            
            xPos = (CGFloat(thisKeyIndex-1) * whiteKeyWidth) + (whiteKeyWidth - whiteKeyWidth/4)
            
            if blackKeyPressedArray.count > 0 {
                
                for x in 0...blackKeyPressedArray.count - 1 {
                    let blackKey = blackKeyPressedArray[x]
                    
                    if i + 1 == blackKey.numberOfKeys {
                        if blackKey.staff == 1 {
                            isPressed = "staff1"
                        } else if blackKey.staff == 2{
                            isPressed = "staff2"
                        }
                    }
                }
            }
            drawBlackKey(xPos, isPressed: isPressed)
        }
    }
    func getNumberOfBlackWhiteKeys() {
        
        for i in 21...108 {
            
            // white keys
            if  i == 23 ||
                i == 28 ||
                i == 35 ||
                i == 40 ||
                i == 47 ||
                i == 52 ||
                i == 59 ||
                i == 64 ||
                i == 71 ||
                i == 76 ||
                i == 83 ||
                i == 88 ||
                i == 95 ||
                i == 100 ||
                i == 107 {
                
                numberOfWhiteKeys += 1
                
                if currentNotesArray.count > 0 {
                    
                    for b in 0...currentNotesArray.count - 1 {
                        let thisNotePitch: Int = currentNotesArray[b].notePitch!
                        let thisNoteStaff: Int = currentNotesArray[b].noteStaff!
                        
                        if i == thisNotePitch {
                            whiteKeyPressedArray.append(keyPressed(numberOfKeys: numberOfWhiteKeys, staff: thisNoteStaff))
                        }
                    }
                }
            } else if i == 21 ||
                i == 24 ||
                i == 26 ||
                i == 29 ||
                i == 31 ||
                i == 33 ||
                i == 36 ||
                i == 38 ||
                i == 41 ||
                i == 43 ||
                i == 45 ||
                i == 48 ||
                i == 50 ||
                i == 53 ||
                i == 55 ||
                i == 57 ||
                i == 60 ||
                i == 62 ||
                i == 65 ||
                i == 67 ||
                i == 69 ||
                i == 72 ||
                i == 74 ||
                i == 77 ||
                i == 79 ||
                i == 81 ||
                i == 84 ||
                i == 86 ||
                i == 89 ||
                i == 91 ||
                i == 93 ||
                i == 96 ||
                i == 98 ||
                i == 101 ||
                i == 103 ||
                i == 105 {
                
                numberOfWhiteKeys += 1
                blackKeyXPos.append(numberOfWhiteKeys)
                
                if currentNotesArray.count > 0 {
                    
                    for b in 0...currentNotesArray.count - 1 {
                        let thisNotePitch: Int = currentNotesArray[b].notePitch!
                        let thisNoteStaff: Int = currentNotesArray[b].noteStaff!
                        
                        if i == thisNotePitch {
                            whiteKeyPressedArray.append(keyPressed(numberOfKeys: numberOfWhiteKeys, staff: thisNoteStaff))
                        }
                    }
                }
            } else { // black keys
                
                numberOfBlackKeys += 1
                
                if currentNotesArray.count > 0 {
                    
                    for b in 0...currentNotesArray.count - 1 {
                        let thisNotePitch: Int = currentNotesArray[b].notePitch!
                        let thisNoteStaff: Int = currentNotesArray[b].noteStaff!
                        
                        if i == thisNotePitch {
                            blackKeyPressedArray.append(keyPressed(numberOfKeys: numberOfBlackKeys, staff: thisNoteStaff))
                        }
                    }
                }
            }
        }
    }
    func drawWhiteKey(_ keyXPos: CGFloat, isPressed: String) {
        
        let whiteKey = UIBezierPath()
        whiteKey.lineWidth = 1.0
        
        whiteKey.move(to: CGPoint(x: keyXPos, y: 0.0))
        whiteKey.addLine(to: CGPoint(x: keyXPos, y: pianoHeight - 2.0))
        
        whiteKey.addQuadCurve(to: CGPoint(x: keyXPos + 2.0, y: pianoHeight), controlPoint: CGPoint(x: keyXPos, y: pianoHeight))
        
        whiteKey.addLine(to: CGPoint(x: keyXPos + whiteKeyWidth - 2.0, y: pianoHeight))
        
        whiteKey.addQuadCurve(to: CGPoint(x: keyXPos + whiteKeyWidth, y: pianoHeight - 2.0), controlPoint: CGPoint(x: keyXPos + whiteKeyWidth, y: pianoHeight))
        
        whiteKey.addLine(to: CGPoint(x: keyXPos + whiteKeyWidth, y: 0.0))
        whiteKey.addLine(to: CGPoint(x: keyXPos, y: 0.0))
        
        UIColor.black.setStroke()
        whiteKey.stroke()
        
        if isPressed == "staff1" {
            //GREEN
            UIColor(red: 85.0/255.0, green: 235.0/255.0, blue: 115.0/255.0, alpha: 1.0).setFill()
        } else if isPressed == "staff2" {
            //BLUE
            UIColor(red: 90.0/255.0, green: 200.0/255.0, blue: 250.0/255.0, alpha: 1.0).setFill()
        } else {
            UIColor.white.setFill()
        }
        whiteKey.fill()
    }
    func drawBlackKey(_ keyXPos: CGFloat, isPressed: String) {
        let blackKey = UIBezierPath()
        blackKey.lineWidth = 1.0
        
        blackKey.move(to: CGPoint(x: keyXPos, y: 0.0))
        blackKey.addLine(to: CGPoint(x: keyXPos, y: pianoHeight - (pianoHeight/3) - 2))
        
        blackKey.addQuadCurve(to: CGPoint(x: keyXPos + 2.0, y: pianoHeight - (pianoHeight/3)), controlPoint: CGPoint(x: keyXPos, y: pianoHeight - (pianoHeight/3)))
        
        blackKey.addLine(to: CGPoint(x: keyXPos + (whiteKeyWidth - whiteKeyWidth/2) - 2.0, y: pianoHeight - (pianoHeight/3)))
        
        blackKey.addQuadCurve(to: CGPoint(x: keyXPos + (whiteKeyWidth - whiteKeyWidth/2), y: pianoHeight - (pianoHeight/3) - 2.0), controlPoint: CGPoint(x: keyXPos + (whiteKeyWidth - whiteKeyWidth/2), y: pianoHeight - (pianoHeight/3)))
        
        blackKey.addLine(to: CGPoint(x: keyXPos + (whiteKeyWidth - whiteKeyWidth/2), y: 0.0))
        blackKey.addLine(to: CGPoint(x: keyXPos, y: 0.0))
        
        UIColor.black.setStroke()
        blackKey.stroke()
        
        if isPressed == "staff1" {
            //GREEN
            UIColor(red: 76.0/255.0, green: 205.0/255.0, blue: 100.0/255.0, alpha: 1.0).setFill()
        } else if isPressed == "staff2" {
            //BLUE
            UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 250.0/255.0, alpha: 1.0).setFill()
        } else {
            UIColor(red: 50.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 1.0).setFill()
        }
        blackKey.fill()
    }
}
