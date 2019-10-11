//
//  measure.swift
//  Scroller
//
//  Created by Clayton Ward on 8/6/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit

class measure: UIView {
    
    var measureWidth: CGFloat!
    var averageStaffDistance: CGFloat!
    
    var thisMeasuresNoteArray = [note]()
    var thisMeasuresRestArray = [rest]()
    var fifths: Int!
    
    var topStaffOffset: CGFloat!
    var bottomStaffOffset: CGFloat!
    
    
    var thisNote: note = note()
    var thisRest: rest = rest()
    
    var PosX: CGFloat!
    var PosY: CGFloat!
    var PosY2: CGFloat!
    
    var beamCount: Int = 0
    var beam1Array = [beam]()
    var beam2Array = [beam]()
    var beam3Array = [beam]()
    var beam4Array = [beam]()
    var beamStemDirectionArray = [beam]()
    var sameStemDirBeam: Bool = true
    var noteStemDirection: String = ""
    var highestNoteYPosBeam1: CGFloat = 0
    var highestNoteIndexBeam1: Int = 0
    var lowestNoteYPosBeam1: CGFloat = 0
    var lowestNoteIndexBeam1: Int = 0
    var octaveShiftArray = [octaveShift]()
    var arpeggioArray = [arpeggio]()
    
    var alreadySharpedArray = [Int]()
    var alreadyFlattedArray = [Int]()
    
    var isLastMeasure: Bool = false
    
    override func draw(_ rect: CGRect) {
        
        topStaffOffset = self.bounds.height/2 - averageStaffDistance/2 - 45.0
        bottomStaffOffset = self.bounds.height/2 + averageStaffDistance/2 - 5
        
        /* STAFF
         ____________
         |____________
         |____________
         |____________
         |____________
         |
         |
         |
         |____________
         |____________
         |____________
         |____________
         |____________
         
         */
        
        //DRAW TOP STAFF
        let lineWidth: CGFloat = 1.0
        let topStaff = UIBezierPath()
        topStaff.lineWidth = lineWidth
        
        topStaff.move(to: CGPoint(x: 0, y: self.bounds.height/2 - averageStaffDistance/2 - 40.5))
        topStaff.addLine(to: CGPoint(x: measureWidth, y: self.bounds.height/2 - averageStaffDistance!/2 - 40.5))
        
        topStaff.move(to: CGPoint(x: 0, y: self.bounds.height/2 - averageStaffDistance/2 - 30.5))
        topStaff.addLine(to: CGPoint(x: measureWidth, y: self.bounds.height/2 - averageStaffDistance!/2 - 30.5))
        
        topStaff.move(to: CGPoint(x: 0, y: self.bounds.height/2 - averageStaffDistance/2 - 20.5))
        topStaff.addLine(to: CGPoint(x: measureWidth, y: self.bounds.height/2 - averageStaffDistance!/2 - 20.5))
        
        topStaff.move(to: CGPoint(x: 0, y: self.bounds.height/2 - averageStaffDistance/2 - 10.5))
        topStaff.addLine(to: CGPoint(x: measureWidth, y: self.bounds.height/2 - averageStaffDistance!/2 - 10.5))
        
        topStaff.move(to: CGPoint(x: 0, y: self.bounds.height/2 - averageStaffDistance/2 - 0.5))
        topStaff.addLine(to: CGPoint(x: measureWidth, y: self.bounds.height/2 - averageStaffDistance!/2 - 0.5))
        
        UIColor.black.setStroke()
        topStaff.stroke()
        
        //DRAW BOTTOM STAFF
        let bottomStaff = UIBezierPath()
        bottomStaff.lineWidth = lineWidth
        
        bottomStaff.move(to: CGPoint(x: 0, y: self.bounds.height/2 + averageStaffDistance/2 + 0.5))
        bottomStaff.addLine(to: CGPoint(x: measureWidth, y: self.bounds.height/2 + averageStaffDistance/2 + 0.5))
        
        bottomStaff.move(to: CGPoint(x: 0, y: self.bounds.height/2 + averageStaffDistance/2 + 10.5))
        bottomStaff.addLine(to: CGPoint(x: measureWidth, y: self.bounds.height/2 + averageStaffDistance/2 + 10.5))
        
        bottomStaff.move(to: CGPoint(x: 0, y: self.bounds.height/2 + averageStaffDistance/2 + 20.5))
        bottomStaff.addLine(to: CGPoint(x: measureWidth, y: self.bounds.height/2 + averageStaffDistance/2 + 20.5))
        
        bottomStaff.move(to: CGPoint(x: 0, y: self.bounds.height/2 + averageStaffDistance/2 + 30.5))
        bottomStaff.addLine(to: CGPoint(x: measureWidth, y: self.bounds.height/2 + averageStaffDistance/2 + 30.5))
        
        bottomStaff.move(to: CGPoint(x: 0, y: self.bounds.height/2 + averageStaffDistance/2 + 40.5))
        bottomStaff.addLine(to: CGPoint(x: measureWidth, y: self.bounds.height/2 + averageStaffDistance/2 + 40.5))
        
        UIColor.black.setStroke()
        bottomStaff.stroke()
        
        
        
        //DRAW BAR LINE
        let barLineWidth: CGFloat = 1.5
        let barLine = UIBezierPath()
        barLine.lineWidth = barLineWidth
        
        barLine.move(to: CGPoint(x: 0, y: self.bounds.height/2 - averageStaffDistance/2 - 40.5))
        barLine.addLine(to: CGPoint(x: 0, y: self.bounds.height/2 + averageStaffDistance/2 + 40.5))
        
        UIColor.black.setStroke()
        barLine.stroke()
        
        if isLastMeasure {
            //DRAW DOUBLE BAR LINE
            let barLine = UIBezierPath()
            barLine.lineWidth = 1.0
            
            barLine.move(to: CGPoint(x: self.bounds.width - 9, y: self.bounds.height/2 - averageStaffDistance/2 - 40.5))
            barLine.addLine(to: CGPoint(x: self.bounds.width - 9, y: self.bounds.height/2 + averageStaffDistance/2 + 40.5))
            
            UIColor.black.setStroke()
            barLine.stroke()
            
            let barLine2 = UIBezierPath()
            barLine2.lineWidth = 5.0
            
            barLine2.move(to: CGPoint(x: self.bounds.width - 2.5, y: self.bounds.height/2 - averageStaffDistance/2 - 40.5))
            barLine2.addLine(to: CGPoint(x: self.bounds.width - 2.5, y: self.bounds.height/2 + averageStaffDistance/2 + 40.5))
            
            UIColor.black.setStroke()
            barLine2.stroke()
        }
        
        //OCTAVE SHIFT
        if octaveShiftArray.count == 2 {
            let startPoint: CGFloat = octaveShiftArray[0].startEndPointX
            let endPoint: CGFloat = octaveShiftArray[1].startEndPointX
            
            //draw 8va
            if octaveShiftArray[0].type == "down" {
                let OctaveLabel: UILabel = UILabel(frame: CGRect(x: startPoint, y: 20, width: 30, height: 15))
                OctaveLabel.text = "8va"
                self.addSubview(OctaveLabel)
                
                if octaveShiftArray[1].type == "stop" {
                    let line = UIBezierPath()
                    line.lineWidth = 1.0
                    line.move(to: CGPoint(x: startPoint + 30, y: 30))
                    line.addLine(to: CGPoint(x: endPoint + 10, y: 30))
                    line.addLine(to: CGPoint(x: endPoint + 10, y: 40))
                    line.stroke()
                }
            }
            if octaveShiftArray[0].type == "up" {
                let OctaveLabel: UILabel = UILabel(frame: CGRect(x: startPoint, y: self.bounds.height - 20, width: 30, height: 15))
                OctaveLabel.text = "8vb"
                self.addSubview(OctaveLabel)
                
                if octaveShiftArray[1].type == "stop" {
                    let line = UIBezierPath()
                    line.lineWidth = 1.0
                    line.move(to: CGPoint(x: startPoint + 30, y: self.bounds.height - 30))
                    line.addLine(to: CGPoint(x: endPoint + 10, y: self.bounds.height - 30))
                    line.addLine(to: CGPoint(x: endPoint + 10, y: self.bounds.height - 40))
                    line.stroke()
                }
            }
            
        }
        //ARPEGGIOS
        if arpeggioArray.count >= 1 {
            var xPosArpeggioArray = [CGFloat]()
            var staffArpeggioArray = [Int]()
            var oneArpeggioArray = [arpeggio]()
            var arpeggioExists: Bool = false
            
            for b in 0...arpeggioArray.count-1 {
                let thisArpeggioNote = arpeggioArray[b]
                if xPosArpeggioArray.count >= 1 {
                    for d in 0...xPosArpeggioArray.count-1 {
                        let thisxPos = xPosArpeggioArray[d]
                        let thisStaff = staffArpeggioArray[d]
                        if (thisxPos >= thisArpeggioNote.xPos - 12) || (thisxPos <= thisArpeggioNote.xPos + 12) {
                            if thisStaff == thisArpeggioNote.staff {
                                arpeggioExists = true
                            }
                        }
                    }
                }
                if arpeggioExists == false {
                    
                    for c in 0...arpeggioArray.count-1 {
                        let thisArpeggioNote2 = arpeggioArray[c]
                        if (thisArpeggioNote2.xPos >= thisArpeggioNote.xPos - 12) || (thisArpeggioNote2.xPos <= thisArpeggioNote.xPos + 12) {
                            if thisArpeggioNote2.staff == thisArpeggioNote.staff {
                                oneArpeggioArray.append(thisArpeggioNote2)
                            }
                        }
                        if c >= arpeggioArray.count-1 {
                            xPosArpeggioArray.append(oneArpeggioArray[0].xPos)
                            staffArpeggioArray.append(oneArpeggioArray[0].staff)
                            //DRAW APEGGIO
                            let y1Pos: CGFloat = oneArpeggioArray[0].yPos
                            let y2Pos: CGFloat = oneArpeggioArray[oneArpeggioArray.count-1].yPos
                            
                            drawArpeggio(xPos: oneArpeggioArray[0].xPos, y1Pos: y1Pos, y2Pos: y2Pos)
                            oneArpeggioArray = []
                        }
                    }
                } else {
                    arpeggioExists = false
                }
            }
        }
        
        
        //DRAW NOTES
        for i in 0..<thisMeasuresNoteArray.count {
            thisNote = thisMeasuresNoteArray[i]
            
            if (thisNote.noteType == "whole") {
                
                let wholeNote = UIBezierPath()
                wholeNote.lineWidth = 1.0
                wholeNote.move(to: CGPoint(x: thisNote.notePos.x + 1, y: thisNote.notePos.y + 1))
                wholeNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 3, y: thisNote.notePos.y + 9), controlPoint: CGPoint(x: thisNote.notePos.x - 3, y: thisNote.notePos.y + 5))
                wholeNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 14, y: thisNote.notePos.y + 9), controlPoint: CGPoint(x: thisNote.notePos.x + 7.5, y: thisNote.notePos.y + 11))
                wholeNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 12, y: thisNote.notePos.y + 1), controlPoint: CGPoint(x: thisNote.notePos.x + 18, y: thisNote.notePos.y + 5))
                wholeNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 1, y: thisNote.notePos.y + 1), controlPoint: CGPoint(x: thisNote.notePos.x + 7.5, y: thisNote.notePos.y - 1))
                
                let halfWhiteSpace = UIBezierPath()
                halfWhiteSpace.lineWidth = 1.0
                halfWhiteSpace.move(to: CGPoint(x: thisNote.notePos.x + 5, y: thisNote.notePos.y + 1))
                halfWhiteSpace.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 6, y: thisNote.notePos.y + 9), controlPoint: CGPoint(x: thisNote.notePos.x + 3, y: thisNote.notePos.y + 5))
                halfWhiteSpace.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 10, y: thisNote.notePos.y + 9), controlPoint: CGPoint(x: thisNote.notePos.x + 7.5, y: thisNote.notePos.y + 9))
                halfWhiteSpace.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 9, y: thisNote.notePos.y + 1), controlPoint: CGPoint(x: thisNote.notePos.x + 12, y: thisNote.notePos.y + 5))
                halfWhiteSpace.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 5, y: thisNote.notePos.y + 1), controlPoint: CGPoint(x: thisNote.notePos.x + 7.5, y: thisNote.notePos.y + 1))
                
                wholeNote.append(halfWhiteSpace)
                wholeNote.usesEvenOddFillRule = true
                wholeNote.fill()
                
            } else if (thisNote.noteType == "half") {
                
                let halfNote = UIBezierPath()
                halfNote.lineWidth = 1.0
                halfNote.move(to: CGPoint(x: thisNote.notePos.x + 4, y: thisNote.notePos.y + 10))
                halfNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 12, y: thisNote.notePos.y + 3), controlPoint: CGPoint(x: thisNote.notePos.x + 11.5, y: thisNote.notePos.y + 9.5))
                halfNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 7, y: thisNote.notePos.y + 0), controlPoint: CGPoint(x: thisNote.notePos.x + 12, y: thisNote.notePos.y + 0))
                halfNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 0, y: thisNote.notePos.y + 7), controlPoint: CGPoint(x: thisNote.notePos.x + 0.5, y: thisNote.notePos.y + 0.5))
                halfNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 5, y: thisNote.notePos.y + 10), controlPoint: CGPoint(x: thisNote.notePos.x + 0, y: thisNote.notePos.y + 10))
                
                let halfWhiteSpace = UIBezierPath()
                halfWhiteSpace.lineWidth = 1.0
                halfWhiteSpace.move(to: CGPoint(x: thisNote.notePos.x + 4, y: thisNote.notePos.y + 9))
                halfWhiteSpace.addLine(to: CGPoint(x: thisNote.notePos.x + 11, y: thisNote.notePos.y + 3))
                halfWhiteSpace.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 8, y: thisNote.notePos.y + 1), controlPoint: CGPoint(x: thisNote.notePos.x + 12, y: thisNote.notePos.y + 0))
                halfWhiteSpace.addLine(to: CGPoint(x: thisNote.notePos.x + 1, y: thisNote.notePos.y + 7))
                halfWhiteSpace.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 4, y: thisNote.notePos.y + 9), controlPoint: CGPoint(x: thisNote.notePos.x + 0, y: thisNote.notePos.y + 10))
                
                halfNote.append(halfWhiteSpace)
                halfNote.usesEvenOddFillRule = true
                halfNote.fill()
                
                
                if (thisNote.noteStem == "up") {
                    drawStaffUpFlag()
                } else if (thisNote.noteStem == "upPlain") {
                    drawStaffUpPlain()
                } else if (thisNote.noteStem == "upLeftPlain") {
                    drawStaffUpLeftPlain()
                } else if (thisNote.noteStem == "downPlain") {
                    drawStaffDownPlain()
                } else if (thisNote.noteStem == "down") {
                    drawStaffDownFlag()
                } else if (thisNote.noteStem == "downRightPlain") {
                    drawStaffDownRightPlain()
                }
                
            } else if (thisNote.noteType == "quarter") {
                
                let filledNote = UIBezierPath()
                filledNote.lineWidth = 1.0
                filledNote.move(to: CGPoint(x: thisNote.notePos.x + 4, y: thisNote.notePos.y + 10))
                filledNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 12, y: thisNote.notePos.y + 3), controlPoint: CGPoint(x: thisNote.notePos.x + 11.5, y: thisNote.notePos.y + 9.5))
                filledNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 7, y: thisNote.notePos.y + 0), controlPoint: CGPoint(x: thisNote.notePos.x + 12, y: thisNote.notePos.y + 0))
                filledNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 0, y: thisNote.notePos.y + 7), controlPoint: CGPoint(x: thisNote.notePos.x + 0.5, y: thisNote.notePos.y + 0.5))
                filledNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 5, y: thisNote.notePos.y + 10), controlPoint: CGPoint(x: thisNote.notePos.x + 0, y: thisNote.notePos.y + 10))
                filledNote.fill()
                
                
                if (thisNote.noteStem == "up") {
                    drawStaffUpFlag()
                } else if (thisNote.noteStem == "upPlain") {
                    drawStaffUpPlain()
                } else if (thisNote.noteStem == "upLeftPlain") {
                    drawStaffUpLeftPlain()
                } else if (thisNote.noteStem == "downPlain") {
                    drawStaffDownPlain()
                } else if (thisNote.noteStem == "down") {
                    drawStaffDownFlag()
                } else if (thisNote.noteStem == "downRightPlain") {
                    drawStaffDownRightPlain()
                }
                
            } else if (thisNote.noteType == "eighth") {
                
                let filledNote = UIBezierPath()
                filledNote.lineWidth = 1.0
                filledNote.move(to: CGPoint(x: thisNote.notePos.x + 4, y: thisNote.notePos.y + 10))
                filledNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 12, y: thisNote.notePos.y + 3), controlPoint: CGPoint(x: thisNote.notePos.x + 11.5, y: thisNote.notePos.y + 9.5))
                filledNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 7, y: thisNote.notePos.y + 0), controlPoint: CGPoint(x: thisNote.notePos.x + 12, y: thisNote.notePos.y + 0))
                filledNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 0, y: thisNote.notePos.y + 7), controlPoint: CGPoint(x: thisNote.notePos.x + 0.5, y: thisNote.notePos.y + 0.5))
                filledNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 5, y: thisNote.notePos.y + 10), controlPoint: CGPoint(x: thisNote.notePos.x + 0, y: thisNote.notePos.y + 10))
                filledNote.fill()
                
                //DRAW STEM FLAG
                if thisNote.beam1 != "begin" && thisNote.beam1 != "continue" && thisNote.beam1 != "end" {
                    if (thisNote.noteStem == "up") {
                        drawStaffUpFlag()
                    } else if (thisNote.noteStem == "upPlain") {
                        drawStaffUpPlain()
                    } else if (thisNote.noteStem == "upLeftPlain") {
                        drawStaffUpLeftPlain()
                    } else if (thisNote.noteStem == "downPlain") {
                        drawStaffDownPlain()
                    } else if (thisNote.noteStem == "down") {
                        drawStaffDownFlag()
                    } else if (thisNote.noteStem == "downRightPlain") {
                        drawStaffDownRightPlain()
                    }
                }
            } else if (thisNote.noteType == "16th") {
                
                let filledNote = UIBezierPath()
                filledNote.lineWidth = 1.0
                filledNote.move(to: CGPoint(x: thisNote.notePos.x + 4, y: thisNote.notePos.y + 10))
                filledNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 12, y: thisNote.notePos.y + 3), controlPoint: CGPoint(x: thisNote.notePos.x + 11.5, y: thisNote.notePos.y + 9.5))
                filledNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 7, y: thisNote.notePos.y + 0), controlPoint: CGPoint(x: thisNote.notePos.x + 12, y: thisNote.notePos.y + 0))
                filledNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 0, y: thisNote.notePos.y + 7), controlPoint: CGPoint(x: thisNote.notePos.x + 0.5, y: thisNote.notePos.y + 0.5))
                filledNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 5, y: thisNote.notePos.y + 10), controlPoint: CGPoint(x: thisNote.notePos.x + 0, y: thisNote.notePos.y + 10))
                filledNote.fill()
                
                if thisNote.beam1 != "begin" && thisNote.beam1 != "continue" && thisNote.beam1 != "end" {
                    if (thisNote.noteStem == "up") {
                        drawStaffUpFlag()
                    } else if (thisNote.noteStem == "upPlain") {
                        drawStaffUpPlain()
                    } else if (thisNote.noteStem == "upLeftPlain") {
                        drawStaffUpLeftPlain()
                    } else if (thisNote.noteStem == "downPlain") {
                        drawStaffDownPlain()
                    } else if (thisNote.noteStem == "down") {
                        drawStaffDownFlag()
                    } else if (thisNote.noteStem == "downRightPlain") {
                        drawStaffDownRightPlain()
                    }
                }
                
            } else if (thisNote.noteType == "32nd") {
                
                let filledNote = UIBezierPath()
                filledNote.lineWidth = 1.0
                filledNote.move(to: CGPoint(x: thisNote.notePos.x + 4, y: thisNote.notePos.y + 10))
                filledNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 12, y: thisNote.notePos.y + 3), controlPoint: CGPoint(x: thisNote.notePos.x + 11.5, y: thisNote.notePos.y + 9.5))
                filledNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 7, y: thisNote.notePos.y + 0), controlPoint: CGPoint(x: thisNote.notePos.x + 12, y: thisNote.notePos.y + 0))
                filledNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 0, y: thisNote.notePos.y + 7), controlPoint: CGPoint(x: thisNote.notePos.x + 0.5, y: thisNote.notePos.y + 0.5))
                filledNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 5, y: thisNote.notePos.y + 10), controlPoint: CGPoint(x: thisNote.notePos.x + 0, y: thisNote.notePos.y + 10))
                filledNote.fill()
                
                if thisNote.beam1 != "begin" && thisNote.beam1 != "continue" && thisNote.beam1 != "end" {
                    if (thisNote.noteStem == "up") {
                        drawStaffUpFlag()
                    } else if (thisNote.noteStem == "upPlain") {
                        drawStaffUpPlain()
                    } else if (thisNote.noteStem == "upLeftPlain") {
                        drawStaffUpLeftPlain()
                    } else if (thisNote.noteStem == "downPlain") {
                        drawStaffDownPlain()
                    } else if (thisNote.noteStem == "down") {
                        drawStaffDownFlag()
                    } else if (thisNote.noteStem == "downRightPlain") {
                        drawStaffDownRightPlain()
                    }
                }
            } else if (thisNote.noteType == "64th") {
                
                let filledNote = UIBezierPath()
                filledNote.lineWidth = 1.0
                filledNote.move(to: CGPoint(x: thisNote.notePos.x + 4, y: thisNote.notePos.y + 10))
                filledNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 12, y: thisNote.notePos.y + 3), controlPoint: CGPoint(x: thisNote.notePos.x + 11.5, y: thisNote.notePos.y + 9.5))
                filledNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 7, y: thisNote.notePos.y + 0), controlPoint: CGPoint(x: thisNote.notePos.x + 12, y: thisNote.notePos.y + 0))
                filledNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 0, y: thisNote.notePos.y + 7), controlPoint: CGPoint(x: thisNote.notePos.x + 0.5, y: thisNote.notePos.y + 0.5))
                filledNote.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 5, y: thisNote.notePos.y + 10), controlPoint: CGPoint(x: thisNote.notePos.x + 0, y: thisNote.notePos.y + 10))
                filledNote.fill()
                
                if thisNote.beam1 != "begin" && thisNote.beam1 != "continue" && thisNote.beam1 != "end" {
                    if (thisNote.noteStem == "up") {
                        drawStaffUpFlag()
                    } else if (thisNote.noteStem == "upPlain") {
                        drawStaffUpPlain()
                    } else if (thisNote.noteStem == "upLeftPlain") {
                        drawStaffUpLeftPlain()
                    } else if (thisNote.noteStem == "downPlain") {
                        drawStaffDownPlain()
                    } else if (thisNote.noteStem == "down") {
                        drawStaffDownFlag()
                    } else if (thisNote.noteStem == "downRightPlain") {
                        drawStaffDownRightPlain()
                    }
                }
            }
            
            
            
            //BEAMS AND STEMS 8, 16, 32, 64
            
            //BEAM 2 Array
            if thisNote.beam2 == "begin" {
                beam2Array.append(beam(state: "begin", notePos: thisNote.notePos, noteStem: thisNote.noteStem))
            } else if thisNote.beam2 == "continue" {
                beam2Array.append(beam(state: "continue", notePos: thisNote.notePos, noteStem: thisNote.noteStem))
            } else if thisNote.beam2 == "end" {
                beam2Array.append(beam(state: "end", notePos: thisNote.notePos, noteStem: thisNote.noteStem))
                beamCount = 2
            } else if thisNote.beam2 == "backward hook" {
                beam2Array.append(beam(state: "backward hook", notePos: thisNote.notePos, noteStem: thisNote.noteStem))
                beamCount = 2
            }
            // BEAM 3 Array
            if thisNote.beam3 == "begin" {
                beam3Array.append(beam(state: "begin", notePos: thisNote.notePos, noteStem: thisNote.noteStem))
            } else if thisNote.beam3 == "continue" {
                beam3Array.append(beam(state: "continue", notePos: thisNote.notePos, noteStem: thisNote.noteStem))
            } else if thisNote.beam3 == "end" {
                beam3Array.append(beam(state: "end", notePos: thisNote.notePos, noteStem: thisNote.noteStem))
                beamCount = 3
            }
            //BEAM 4 Array
            if thisNote.beam4 == "begin" {
                beam4Array.append(beam(state: "begin", notePos: thisNote.notePos, noteStem: thisNote.noteStem))
            } else if thisNote.beam4 == "continue" {
                beam4Array.append(beam(state: "continue", notePos: thisNote.notePos, noteStem: thisNote.noteStem))
            } else if thisNote.beam4 == "end" {
                beam4Array.append(beam(state: "end", notePos: thisNote.notePos, noteStem: thisNote.noteStem))
                beamCount = 4
            }
            //BEAM 1 Array
            if thisNote.beam1 == "begin" {
                beam1Array.append(beam(state: "begin", notePos: thisNote.notePos, noteStem: thisNote.noteStem))
                beamCount = 1
            } else if thisNote.beam1 == "continue" {
                beam1Array.append(beam(state: "continue", notePos: thisNote.notePos, noteStem: thisNote.noteStem))
            } else if thisNote.beam1 == "end" {
                beam1Array.append(beam(state: "end", notePos: thisNote.notePos, noteStem: thisNote.noteStem))
                
                drawBeams()
                beam1Array.removeAll()
                beam2Array.removeAll()
                beam3Array.removeAll()
                beam4Array.removeAll()
                beamCount = 0
            }
            
            
            
            //DRAW SHARPS FLATS NATURALS
            // #
            if thisNote.noteAlter == 1 {
                if alreadySharpedArray.count >= 1{
                    var isAlreadySharped: Bool = false
                    for i in 0...alreadySharpedArray.count-1 {
                        let thisAlreadySharped: Int = alreadySharpedArray[i]
                        
                        if thisAlreadySharped == thisNote.notePitch {
                            isAlreadySharped = true
                        }
                        if i == alreadySharpedArray.count-1 && isAlreadySharped == false {
                            PosX = thisNote.notePos.x - 13
                            PosY = thisNote.notePos.y - 9
                            drawSharp()
                            alreadySharpedArray.append(thisNote.notePitch)
                        }
                    }
                } else {
                    PosX = thisNote.notePos.x - 13
                    PosY = thisNote.notePos.y - 9
                    drawSharp()
                    alreadySharpedArray.append(thisNote.notePitch)
                }
            }
            // b
            if thisNote.noteAlter == -1 {
                if alreadyFlattedArray.count >= 1{
                    var isAlreadyFlatted: Bool = false
                    for i in 0...alreadyFlattedArray.count-1 {
                        let thisAlreadyFlatted: Int = alreadyFlattedArray[i]
                        
                        if thisAlreadyFlatted == thisNote.notePitch {
                            isAlreadyFlatted = true
                        }
                        if i == alreadyFlattedArray.count-1 && isAlreadyFlatted == false {
                            PosX = thisNote.notePos.x - 10
                            PosY = thisNote.notePos.y - 12
                            drawFlat()
                            alreadyFlattedArray.append(thisNote.notePitch)
                        }
                    }
                } else {
                    //draw flat
                    PosX = thisNote.notePos.x - 10
                    PosY = thisNote.notePos.y - 12
                    drawFlat()
                    alreadyFlattedArray.append(thisNote.notePitch)
                }
            }
            // natural
            if thisNote.noteAlter == 0 {
                
                //draw natural
                PosX = thisNote.notePos.x - 9
                PosY = thisNote.notePos.y - 7
                drawNatural()
            }
            // DOUBLE ##
            if thisNote.noteAlter == 2 {
                PosX = thisNote.notePos.x - 12
                PosY = thisNote.notePos.y
                drawDoubleSharp()
            }
            // DOUBLE bb
            if thisNote.noteAlter == -2 {
                PosX = thisNote.notePos.x - 10
                PosY = thisNote.notePos.y - 12
                drawDoubleFlat()
            }
            
            
            
            
            //DRAW EXTRA STAFF LINES
            var stemLinePosY: CGFloat!
            if thisNote.noteStaff == 1 {
                stemLinePosY = topStaffOffset - thisNote.notePos.y
            } else if thisNote.noteStaff == 2 {
                stemLinePosY = bottomStaffOffset - thisNote.notePos.y
            } else {
                stemLinePosY = topStaffOffset - thisNote.notePos.y
            }
            calculateLinesToDraw(noteStaffOffsetY: stemLinePosY, notePosX: thisNote.notePos.x, notePosY: thisNote.notePos.y, staffNumber: thisNote.noteStaff)
            
            
            
            
            //DRAW DOT FOR DOTTED NOTES
            if thisNote.noteDot == true {
                let dot = UIBezierPath()
                dot.addArc(withCenter: CGPoint(x: thisNote.notePos.x + 18, y: thisNote.notePos.y + 5), radius: 2.0, startAngle: CGFloat(0), endAngle: CGFloat(M_PI * 2), clockwise: true)
                UIColor.black.setFill()
                dot.fill()
            }
            
            //DRAW TUPLET
            if thisNote.noteTuplet == "continue" {
                var tupletYPos: CGFloat = 0
                var tupletXPos: CGFloat = 0
                if thisNote.noteStem == "up" {
                    tupletYPos = thisNote.notePos.y - 55
                    tupletXPos = thisNote.notePos.x + 10
                } else {
                    tupletYPos = thisNote.notePos.y + 50
                    tupletXPos = thisNote.notePos.x - 5
                }
                
                let tupletLabel: UILabel = UILabel(frame: CGRect(x: tupletXPos, y: tupletYPos, width: 15, height: 15))
                tupletLabel.text = "3"
                tupletLabel.font = UIFont(name: "TimesNewRomanPS-ItalicMT", size: 15)
                self.addSubview(tupletLabel)
            }
            
            
        }//end of note
        
        
        
        //DRAW RESTS
        for i in 0..<thisMeasuresRestArray.count {
            thisRest = thisMeasuresRestArray[i]
            
            if (thisRest.restType == "whole") {
                
                if thisRest.restStaff == 1 {
                    let wholeRest = UIBezierPath()
                    wholeRest.lineWidth = 6.0
                    wholeRest.move(to: CGPoint(x: measureWidth/2 - 7.0, y: topStaffOffset + 18))
                    wholeRest.addLine(to: CGPoint(x: measureWidth/2 + 7.0, y: topStaffOffset + 18))
                    wholeRest.stroke()
                } else {
                    let wholeRest = UIBezierPath()
                    wholeRest.lineWidth = 6.0
                    wholeRest.move(to: CGPoint(x: measureWidth/2 - 7.0, y: bottomStaffOffset + 18))
                    wholeRest.addLine(to: CGPoint(x: measureWidth/2 + 7.0, y: bottomStaffOffset + 18))
                    wholeRest.stroke()
                }
            } else if (thisRest.restType == "half") {
                
                if thisRest.restStaff == 1 {
                    let wholeRest = UIBezierPath()
                    wholeRest.lineWidth = 6.0
                    wholeRest.move(to: CGPoint(x: thisRest.restXPos - 7.0, y: topStaffOffset + 22))
                    wholeRest.addLine(to: CGPoint(x: thisRest.restXPos + 7.0, y: topStaffOffset + 22))
                    wholeRest.stroke()
                } else {
                    let wholeRest = UIBezierPath()
                    wholeRest.lineWidth = 6.0
                    wholeRest.move(to: CGPoint(x: thisRest.restXPos - 7.0, y: bottomStaffOffset + 22))
                    wholeRest.addLine(to: CGPoint(x: thisRest.restXPos + 7.0, y: bottomStaffOffset + 22))
                    wholeRest.stroke()
                }
            } else if (thisRest.restType == "quarter") {
                
                if thisRest.restStaff == 1 {
                    let quarterRest = UIBezierPath()
                    quarterRest.lineWidth = 1.0
                    
                    quarterRest.move(to: CGPoint(x: thisRest.restXPos + 3.0, y: topStaffOffset + 10 + 0.0))
                    quarterRest.addLine(to: CGPoint(x: thisRest.restXPos + 9.0, y: topStaffOffset + 10 + 8.0))
                    quarterRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos + 9.0, y: topStaffOffset + 10 + 10.0), controlPoint: CGPoint(x: thisRest.restXPos + 10.0, y: topStaffOffset + 10 + 9.0))
                    
                    quarterRest.addLine(to: CGPoint(x: thisRest.restXPos + 5.5, y: topStaffOffset + 10 + 15.0))
                    quarterRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos + 6.5, y: topStaffOffset + 10 + 17.5), controlPoint: CGPoint(x: thisRest.restXPos + 5.5, y: topStaffOffset + 10 + 13.0))
                    quarterRest.addLine(to: CGPoint(x: thisRest.restXPos + 10.5, y: topStaffOffset + 10 + 20.5))
                    
                    quarterRest.addLine(to: CGPoint(x: thisRest.restXPos + 10.0, y: topStaffOffset + 10 + 22.0))
                    quarterRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos + 7.0, y: topStaffOffset + 10 + 28.0), controlPoint: CGPoint(x: thisRest.restXPos + 0, y: topStaffOffset + 10 + 21))
                    quarterRest.addLine(to: CGPoint(x: thisRest.restXPos + 6.5, y: topStaffOffset + 10 + 28.5))
                    quarterRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos + 9.0, y: topStaffOffset + 10 + 21), controlPoint: CGPoint(x: thisRest.restXPos - 6, y: topStaffOffset + 10 + 17))
                    quarterRest.addLine(to: CGPoint(x: thisRest.restXPos + 1.0, y: topStaffOffset + 10 + 15.0))
                    
                    quarterRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos + 1.0, y: topStaffOffset + 10 + 13.0), controlPoint: CGPoint(x: thisRest.restXPos + 0, y: topStaffOffset + 10 + 14.0))
                    quarterRest.addLine(to: CGPoint(x: thisRest.restXPos + 3.0, y: topStaffOffset + 10 + 10.0))
                    quarterRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos + 2.5, y: topStaffOffset + 10 + 2.5), controlPoint: CGPoint(x: thisRest.restXPos + 7, y: topStaffOffset + 10 + 6.0))
                    quarterRest.addLine(to: CGPoint(x: thisRest.restXPos + 3.0, y: topStaffOffset + 10 + 0.0))
                    
                    quarterRest.fill()
                    
                    //DRAW DOT FOR DOTTED RESTS
                    if thisRest.restDot == true {
                        let dot = UIBezierPath()
                        dot.addArc(withCenter: CGPoint(x: thisRest.restXPos + 18, y: topStaffOffset! + 20), radius: 2.0, startAngle: CGFloat(0), endAngle: CGFloat(M_PI * 2), clockwise: true)
                        UIColor.black.setFill()
                        dot.fill()
                    }
                } else {
                    let quarterRest = UIBezierPath()
                    quarterRest.lineWidth = 1.0
                    
                    quarterRest.move(to: CGPoint(x: thisRest.restXPos + 3.0, y: bottomStaffOffset + 10 + 0.0))
                    quarterRest.addLine(to: CGPoint(x: thisRest.restXPos + 9.0, y: bottomStaffOffset + 10 + 8.0))
                    quarterRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos + 9.0, y: bottomStaffOffset + 10 + 10.0), controlPoint: CGPoint(x: thisRest.restXPos + 10.0, y: bottomStaffOffset + 10 + 9.0))
                    
                    quarterRest.addLine(to: CGPoint(x: thisRest.restXPos + 5.5, y: bottomStaffOffset + 10 + 15.0))
                    quarterRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos + 6.5, y: bottomStaffOffset + 10 + 17.5), controlPoint: CGPoint(x: thisRest.restXPos + 5.5, y: bottomStaffOffset + 10 + 13.0))
                    quarterRest.addLine(to: CGPoint(x: thisRest.restXPos + 10.5, y: bottomStaffOffset + 10 + 20.5))
                    
                    quarterRest.addLine(to: CGPoint(x: thisRest.restXPos + 10.0, y: bottomStaffOffset + 10 + 22.0))
                    quarterRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos + 7.0, y: bottomStaffOffset + 10 + 28.0), controlPoint: CGPoint(x: thisRest.restXPos + 0, y: bottomStaffOffset + 10 + 21))
                    quarterRest.addLine(to: CGPoint(x: thisRest.restXPos + 6.5, y: bottomStaffOffset + 10 + 28.5))
                    quarterRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos + 9.0, y: bottomStaffOffset + 10 + 21), controlPoint: CGPoint(x: thisRest.restXPos - 6, y: bottomStaffOffset + 10 + 17))
                    quarterRest.addLine(to: CGPoint(x: thisRest.restXPos + 1.0, y: bottomStaffOffset + 10 + 15.0))
                    
                    quarterRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos + 1.0, y: bottomStaffOffset + 10 + 13.0), controlPoint: CGPoint(x: thisRest.restXPos + 0, y: bottomStaffOffset + 10 + 14.0))
                    quarterRest.addLine(to: CGPoint(x: thisRest.restXPos + 3.0, y: bottomStaffOffset + 10 + 10.0))
                    quarterRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos + 2.5, y: bottomStaffOffset + 10 + 2.5), controlPoint: CGPoint(x: thisRest.restXPos + 7, y: bottomStaffOffset + 10 + 6.0))
                    quarterRest.addLine(to: CGPoint(x: thisRest.restXPos + 3.0, y: bottomStaffOffset + 10 + 0.0))
                    
                    quarterRest.fill()
                    
                    //DRAW DOT FOR DOTTED RESTS
                    if thisRest.restDot == true {
                        let dot = UIBezierPath()
                        dot.addArc(withCenter: CGPoint(x: thisRest.restXPos + 18, y: bottomStaffOffset + 20), radius: 2.0, startAngle: CGFloat(0), endAngle: CGFloat(M_PI * 2), clockwise: true)
                        UIColor.black.setFill()
                        dot.fill()
                    }
                }
            } else if (thisRest.restType == "eighth") {
                
                if thisRest.restStaff == 1 {
                    let eightRest = UIBezierPath()
                    eightRest.lineWidth = 1.0
                    
                    eightRest.move(to: CGPoint(x: thisRest.restXPos + 0.0, y: topStaffOffset + 18 + 0.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 4.0, y: topStaffOffset + 18 + 0.0), controlPoint: CGPoint(x: thisRest.restXPos - 3.0, y: topStaffOffset + 18 + 2.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 8.0, y: topStaffOffset + 18 + 2.0), controlPoint: CGPoint(x: thisRest.restXPos - 6.0, y: topStaffOffset + 18 - 2.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 0.0, y: topStaffOffset + 18 + 1.0), controlPoint: CGPoint(x: thisRest.restXPos - 6.0, y: topStaffOffset + 18 + 7.0))
                    
                    eightRest.addLine(to: CGPoint(x: thisRest.restXPos - 6.0, y: topStaffOffset + 18 + 18.0))
                    eightRest.addLine(to: CGPoint(x: thisRest.restXPos - 5.0, y: topStaffOffset + 18 + 18.0))
                    eightRest.addLine(to: CGPoint(x: thisRest.restXPos - 0.0, y: topStaffOffset + 18 + 0.0))
                    
                    eightRest.stroke()
                    eightRest.fill()
                } else {
                    let eightRest = UIBezierPath()
                    eightRest.lineWidth = 1.0
                    
                    eightRest.move(to: CGPoint(x: thisRest.restXPos + 0.0, y: bottomStaffOffset! + 18 + 0.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 4.0, y: bottomStaffOffset + 18 + 0.0), controlPoint: CGPoint(x: thisRest.restXPos - 3.0, y: bottomStaffOffset + 18 + 2.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 8.0, y: bottomStaffOffset + 18 + 2.0), controlPoint: CGPoint(x: thisRest.restXPos - 6.0, y: bottomStaffOffset + 18 - 2.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 0.0, y: bottomStaffOffset + 18 + 1.0), controlPoint: CGPoint(x: thisRest.restXPos - 6.0, y: bottomStaffOffset + 18 + 7.0))
                    
                    eightRest.addLine(to: CGPoint(x: thisRest.restXPos - 6.0, y: bottomStaffOffset + 18 + 18.0))
                    eightRest.addLine(to: CGPoint(x: thisRest.restXPos - 5.0, y: bottomStaffOffset + 18 + 18.0))
                    eightRest.addLine(to: CGPoint(x: thisRest.restXPos - 0.0, y: bottomStaffOffset + 18 + 0.0))
                    
                    eightRest.stroke()
                    eightRest.fill()
                }
                
            } else if (thisRest.restType == "16th") {
                if thisRest.restStaff == 1 {
                    let eightRest = UIBezierPath()
                    eightRest.lineWidth = 1.0
                    
                    eightRest.move(to: CGPoint(x: thisRest.restXPos + 0.0, y: topStaffOffset + 18 + 0.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 4.0, y: topStaffOffset + 18 + 0.0), controlPoint: CGPoint(x: thisRest.restXPos - 3.0, y: topStaffOffset + 18 + 2.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 8.0, y: topStaffOffset + 18 + 2.0), controlPoint: CGPoint(x: thisRest.restXPos - 6.0, y: topStaffOffset + 18 - 2.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 0.0, y: topStaffOffset + 18 + 1.0), controlPoint: CGPoint(x: thisRest.restXPos - 6.0, y: topStaffOffset + 18 + 7.0))
                    
                    eightRest.addLine(to: CGPoint(x: thisRest.restXPos - 3.0, y: topStaffOffset + 18 + 10.0))
                    
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 7.0, y: topStaffOffset + 18 + 10.0), controlPoint: CGPoint(x: thisRest.restXPos - 6.0, y: topStaffOffset + 18 + 12.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 11.0, y: topStaffOffset + 18 + 12.0), controlPoint: CGPoint(x: thisRest.restXPos - 9.0, y: topStaffOffset + 18 + 8.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 3.0, y: topStaffOffset + 18 + 11.0), controlPoint: CGPoint(x: thisRest.restXPos - 9.0, y: topStaffOffset + 18 + 17.0))
                    
                    eightRest.addLine(to: CGPoint(x: thisRest.restXPos - 9.0, y: topStaffOffset + 18 + 28.0))
                    eightRest.addLine(to: CGPoint(x: thisRest.restXPos - 8.0, y: topStaffOffset + 18 + 28.0))
                    eightRest.addLine(to: CGPoint(x: thisRest.restXPos - 0.0, y: topStaffOffset + 18 + 0.0))
                    
                    eightRest.stroke()
                    eightRest.fill()
                } else {
                    let eightRest = UIBezierPath()
                    eightRest.lineWidth = 1.0
                    
                    eightRest.move(to: CGPoint(x: thisRest.restXPos + 0.0, y: bottomStaffOffset + 18 + 0.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 4.0, y: bottomStaffOffset + 18 + 0.0), controlPoint: CGPoint(x: thisRest.restXPos - 3.0, y: bottomStaffOffset + 18 + 2.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 8.0, y: bottomStaffOffset + 18 + 2.0), controlPoint: CGPoint(x: thisRest.restXPos - 6.0, y: bottomStaffOffset + 18 - 2.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 0.0, y: bottomStaffOffset + 18 + 1.0), controlPoint: CGPoint(x: thisRest.restXPos - 6.0, y: bottomStaffOffset + 18 + 7.0))
                    
                    eightRest.addLine(to: CGPoint(x: thisRest.restXPos - 3.0, y: bottomStaffOffset + 18 + 10.0))
                    
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 7.0, y: bottomStaffOffset + 18 + 10.0), controlPoint: CGPoint(x: thisRest.restXPos - 6.0, y: bottomStaffOffset + 18 + 12.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 11.0, y: bottomStaffOffset + 18 + 12.0), controlPoint: CGPoint(x: thisRest.restXPos - 9.0, y: bottomStaffOffset + 18 + 8.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 3.0, y: bottomStaffOffset + 18 + 11.0), controlPoint: CGPoint(x: thisRest.restXPos - 9.0, y: bottomStaffOffset + 18 + 17.0))
                    
                    eightRest.addLine(to: CGPoint(x: thisRest.restXPos - 9.0, y: bottomStaffOffset + 18 + 28.0))
                    eightRest.addLine(to: CGPoint(x: thisRest.restXPos - 8.0, y: bottomStaffOffset + 18 + 28.0))
                    eightRest.addLine(to: CGPoint(x: thisRest.restXPos - 0.0, y: bottomStaffOffset + 18 + 0.0))
                    
                    eightRest.stroke()
                    eightRest.fill()
                }
            } else if (thisRest.restType == "32nd") {
                if thisRest.restStaff == 1 {
                    let eightRest = UIBezierPath()
                    eightRest.lineWidth = 1.0
                    
                    eightRest.move(to: CGPoint(x: thisRest.restXPos + 0.0, y: topStaffOffset + 8 + 0.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 4.0, y: topStaffOffset + 8 + 0.0), controlPoint: CGPoint(x: thisRest.restXPos - 3.0, y: topStaffOffset + 8 + 2.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 8.0, y: topStaffOffset + 8 + 2.0), controlPoint: CGPoint(x: thisRest.restXPos - 6.0, y: topStaffOffset + 8 - 2.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 0.0, y: topStaffOffset + 8 + 1.0), controlPoint: CGPoint(x: thisRest.restXPos - 6.0, y: topStaffOffset + 8 + 7.0))
                    
                    eightRest.addLine(to: CGPoint(x: thisRest.restXPos - 3.0, y: topStaffOffset + 8 + 10.0))
                    
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 7.0, y: topStaffOffset + 8 + 10.0), controlPoint: CGPoint(x: thisRest.restXPos - 6.0, y: topStaffOffset + 8 + 12.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 11.0, y: topStaffOffset + 8 + 12.0), controlPoint: CGPoint(x: thisRest.restXPos - 9.0, y: topStaffOffset + 8 + 8.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 3.0, y: topStaffOffset + 8 + 11.0), controlPoint: CGPoint(x: thisRest.restXPos - 9.0, y: topStaffOffset + 8 + 17.0))
                    
                    eightRest.addLine(to: CGPoint(x: thisRest.restXPos - 6.0, y: topStaffOffset + 8 + 20.0))
                    
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 10.0, y: topStaffOffset + 8 + 20.0), controlPoint: CGPoint(x: thisRest.restXPos - 9.0, y: topStaffOffset + 8 + 22.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 14.0, y: topStaffOffset + 8 + 22.0), controlPoint: CGPoint(x: thisRest.restXPos - 12.0, y: topStaffOffset + 8 + 18.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 6.0, y: topStaffOffset + 8 + 21.0), controlPoint: CGPoint(x: thisRest.restXPos - 12.0, y: topStaffOffset + 8 + 27.0))
                    
                    eightRest.addLine(to: CGPoint(x: thisRest.restXPos - 12.0, y: topStaffOffset + 8 + 38.0))
                    eightRest.addLine(to: CGPoint(x: thisRest.restXPos - 11.0, y: topStaffOffset + 8 + 38.0))
                    eightRest.addLine(to: CGPoint(x: thisRest.restXPos - 0.0, y: topStaffOffset + 8 + 0.0))
                    
                    eightRest.stroke()
                    eightRest.fill()
                } else {
                    let eightRest = UIBezierPath()
                    eightRest.lineWidth = 1.0
                    
                    eightRest.move(to: CGPoint(x: thisRest.restXPos + 0.0, y: bottomStaffOffset + 8 + 0.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 4.0, y: bottomStaffOffset + 8 + 0.0), controlPoint: CGPoint(x: thisRest.restXPos - 3.0, y: bottomStaffOffset + 8 + 2.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 8.0, y: bottomStaffOffset + 8 + 2.0), controlPoint: CGPoint(x: thisRest.restXPos - 6.0, y: bottomStaffOffset + 8 - 2.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 0.0, y: bottomStaffOffset + 8 + 1.0), controlPoint: CGPoint(x: thisRest.restXPos - 6.0, y: bottomStaffOffset + 8 + 7.0))
                    
                    eightRest.addLine(to: CGPoint(x: thisRest.restXPos - 3.0, y: bottomStaffOffset + 8 + 10.0))
                    
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 7.0, y: bottomStaffOffset + 8 + 10.0), controlPoint: CGPoint(x: thisRest.restXPos - 6.0, y: bottomStaffOffset + 8 + 12.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 11.0, y: bottomStaffOffset + 8 + 12.0), controlPoint: CGPoint(x: thisRest.restXPos - 9.0, y: bottomStaffOffset + 8 + 8.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 3.0, y: bottomStaffOffset + 8 + 11.0), controlPoint: CGPoint(x: thisRest.restXPos - 9.0, y: bottomStaffOffset + 8 + 17.0))
                    
                    eightRest.addLine(to: CGPoint(x: thisRest.restXPos - 6.0, y: bottomStaffOffset + 8 + 20.0))
                    
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 10.0, y: bottomStaffOffset + 8 + 20.0), controlPoint: CGPoint(x: thisRest.restXPos - 9.0, y: bottomStaffOffset + 8 + 22.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 14.0, y: bottomStaffOffset + 8 + 22.0), controlPoint: CGPoint(x: thisRest.restXPos - 12.0, y: bottomStaffOffset + 8 + 18.0))
                    eightRest.addQuadCurve(to: CGPoint(x: thisRest.restXPos - 6.0, y: bottomStaffOffset + 8 + 21.0), controlPoint: CGPoint(x: thisRest.restXPos - 12.0, y: bottomStaffOffset + 8 + 27.0))
                    
                    eightRest.addLine(to: CGPoint(x: thisRest.restXPos - 12.0, y: bottomStaffOffset + 8 + 38.0))
                    eightRest.addLine(to: CGPoint(x: thisRest.restXPos - 11.0, y: bottomStaffOffset + 8 + 38.0))
                    eightRest.addLine(to: CGPoint(x: thisRest.restXPos - 0.0, y: bottomStaffOffset + 8 + 0.0))
                    
                    eightRest.stroke()
                    eightRest.fill()
                }
            }
        }
        
        
    }
    func drawFlat() {
        // DRAW b
        let flatLine = UIBezierPath()
        flatLine.lineWidth = 1.25
        
        flatLine.move(to: CGPoint(x: PosX, y: PosY + 0))
        flatLine.addLine(to: CGPoint(x: PosX, y: PosY + 22))
        UIColor.black.setStroke()
        flatLine.stroke()
        
        let flat = UIBezierPath()
        flat.lineWidth = 1.75
        flat.move(to: CGPoint(x: PosX, y: PosY + 22))
        flat.addQuadCurve(to: CGPoint(x: PosX, y: PosY + 15), controlPoint: CGPoint(x: PosX + 13, y: PosY + 11))
        UIColor.black.setStroke()
        flat.stroke()
    }
    func drawSharp() {
        // DRAW #
        let sharpLine1 = UIBezierPath()
        sharpLine1.lineWidth = 1.25
        sharpLine1.move(to: CGPoint(x: PosX + 3, y: PosY + 1.5))
        sharpLine1.addLine(to: CGPoint(x: PosX + 3, y: PosY + 27.5))
        UIColor.black.setStroke()
        sharpLine1.stroke()
        
        let sharpLine2 = UIBezierPath()
        sharpLine2.lineWidth = 3.5
        sharpLine2.move(to: CGPoint(x: PosX, y: PosY + 10.5))
        sharpLine2.addLine(to: CGPoint(x: PosX + 10, y: PosY + 7.5))
        UIColor.black.setStroke()
        sharpLine2.stroke()
        
        let sharpLine3 = UIBezierPath()
        sharpLine3.lineWidth = 1.25
        sharpLine3.move(to: CGPoint(x: PosX + 7, y: PosY + 0))
        sharpLine3.addLine(to: CGPoint(x: PosX + 7, y: PosY + 26))
        UIColor.black.setStroke()
        sharpLine3.stroke()
        
        let sharpLine4 = UIBezierPath()
        sharpLine4.lineWidth = 3.5
        sharpLine4.move(to: CGPoint(x: PosX, y: PosY + 20))
        sharpLine4.addLine(to: CGPoint(x: PosX + 10, y: PosY + 17))
        UIColor.black.setStroke()
        sharpLine4.stroke()
    }
    func drawNatural() {
        // DRAW natural
        let sharpLine1 = UIBezierPath()
        sharpLine1.lineWidth = 1.25
        sharpLine1.move(to: CGPoint(x: PosX, y: PosY + 0))
        sharpLine1.addLine(to: CGPoint(x: PosX, y: PosY + 19.5))
        UIColor.black.setStroke()
        sharpLine1.stroke()
        
        let sharpLine2 = UIBezierPath()
        sharpLine2.lineWidth = 3.5
        sharpLine2.move(to: CGPoint(x: PosX, y: PosY + 8.5))
        sharpLine2.addLine(to: CGPoint(x: PosX + 4, y: PosY + 7.5))
        UIColor.black.setStroke()
        sharpLine2.stroke()
        
        let sharpLine3 = UIBezierPath()
        sharpLine3.lineWidth = 1.25
        sharpLine3.move(to: CGPoint(x: PosX + 4, y: PosY + 6))
        sharpLine3.addLine(to: CGPoint(x: PosX + 4, y: PosY + 25))
        UIColor.black.setStroke()
        sharpLine3.stroke()
        
        let sharpLine4 = UIBezierPath()
        sharpLine4.lineWidth = 3.5
        sharpLine4.move(to: CGPoint(x: PosX, y: PosY + 18))
        sharpLine4.addLine(to: CGPoint(x: PosX + 4, y: PosY + 17))
        UIColor.black.setStroke()
        sharpLine4.stroke()
    }
    func drawDoubleSharp() {
        // DRAW DOULBE ##
        let sharpLine = UIBezierPath()
        sharpLine.lineWidth = 1.0
        sharpLine.move(to: CGPoint(x: PosX, y: PosY))
        sharpLine.addLine(to: CGPoint(x: PosX + 3, y: PosY))
        sharpLine.addLine(to: CGPoint(x: PosX + 3, y: PosY + 3))
        sharpLine.addLine(to: CGPoint(x: PosX + 5, y: PosY + 4))
        sharpLine.addLine(to: CGPoint(x: PosX + 7, y: PosY + 3))
        sharpLine.addLine(to: CGPoint(x: PosX + 7, y: PosY))
        sharpLine.addLine(to: CGPoint(x: PosX + 10, y: PosY))
        
        sharpLine.addLine(to: CGPoint(x: PosX + 10, y: PosY + 3))
        sharpLine.addLine(to: CGPoint(x: PosX + 7, y: PosY + 3))
        sharpLine.addLine(to: CGPoint(x: PosX + 6, y: PosY + 5))
        sharpLine.addLine(to: CGPoint(x: PosX + 7, y: PosY + 7))
        sharpLine.addLine(to: CGPoint(x: PosX + 10, y: PosY + 7))
        sharpLine.addLine(to: CGPoint(x: PosX + 10, y: PosY + 10))
        
        sharpLine.addLine(to: CGPoint(x: PosX + 7, y: PosY + 10))
        sharpLine.addLine(to: CGPoint(x: PosX + 7, y: PosY + 7))
        sharpLine.addLine(to: CGPoint(x: PosX + 5, y: PosY + 6))
        sharpLine.addLine(to: CGPoint(x: PosX + 3, y: PosY + 7))
        sharpLine.addLine(to: CGPoint(x: PosX + 3, y: PosY + 10))
        sharpLine.addLine(to: CGPoint(x: PosX, y: PosY + 10))
        
        sharpLine.addLine(to: CGPoint(x: PosX, y: PosY + 7))
        sharpLine.addLine(to: CGPoint(x: PosX + 3, y: PosY + 7))
        sharpLine.addLine(to: CGPoint(x: PosX + 4, y: PosY + 5))
        sharpLine.addLine(to: CGPoint(x: PosX + 3, y: PosY + 3))
        sharpLine.addLine(to: CGPoint(x: PosX, y: PosY + 3))
        sharpLine.addLine(to: CGPoint(x: PosX, y: PosY))
        
        UIColor.black.setStroke()
        sharpLine.stroke()
        UIColor.black.setFill()
        sharpLine.fill()
    }
    func drawDoubleFlat() {
        // DRAW b
        let flatLine = UIBezierPath()
        flatLine.lineWidth = 1.25
        
        flatLine.move(to: CGPoint(x: PosX, y: PosY + 0))
        flatLine.addLine(to: CGPoint(x: PosX, y: PosY + 22))
        flatLine.move(to: CGPoint(x: PosX - 8, y: PosY + 0))
        flatLine.addLine(to: CGPoint(x: PosX - 8, y: PosY + 22))
        
        UIColor.black.setStroke()
        flatLine.stroke()
        
        let flat = UIBezierPath()
        flat.lineWidth = 1.75
        
        flat.move(to: CGPoint(x: PosX, y: PosY + 22))
        flat.addQuadCurve(to: CGPoint(x: PosX, y: PosY + 15), controlPoint: CGPoint(x: PosX + 13, y: PosY + 11))
        flat.move(to: CGPoint(x: PosX - 8, y: PosY + 22))
        flat.addQuadCurve(to: CGPoint(x: PosX - 8, y: PosY + 15), controlPoint: CGPoint(x: PosX + 5, y: PosY + 11))
        
        UIColor.black.setStroke()
        flat.stroke()
    }
    func calculateLinesToDraw(noteStaffOffsetY: CGFloat, notePosX: CGFloat, notePosY: CGFloat, staffNumber: Int) {
        if noteStaffOffsetY >= 8 && noteStaffOffsetY <= 12 {
            drawExtraStaffLine(numberOfLines: 1, notePosX: notePosX, notePosY: notePosY, linePosY: [5.0])
        } else if noteStaffOffsetY >= 13 && noteStaffOffsetY <= 17 {
            drawExtraStaffLine(numberOfLines: 1, notePosX: notePosX, notePosY: notePosY, linePosY: [10.0])
        } else if noteStaffOffsetY >= 18 && noteStaffOffsetY <= 22 {
            drawExtraStaffLine(numberOfLines: 2, notePosX: notePosX, notePosY: notePosY, linePosY: [5.0, 15.0])
        } else if noteStaffOffsetY >= 23 && noteStaffOffsetY <= 27 {
            drawExtraStaffLine(numberOfLines: 2, notePosX: notePosX, notePosY: notePosY, linePosY: [10.0, 20.0])
        } else if noteStaffOffsetY >= 28 && noteStaffOffsetY <= 32 {
            drawExtraStaffLine(numberOfLines: 3, notePosX: notePosX, notePosY: notePosY, linePosY: [5.0, 15.0, 25.0])
        } else if noteStaffOffsetY >= 33 && noteStaffOffsetY <= 37 {
            drawExtraStaffLine(numberOfLines: 3, notePosX: notePosX, notePosY: notePosY, linePosY: [10.0, 20.0, 30.0])
        } else if noteStaffOffsetY >= 38 && noteStaffOffsetY <= 42 {
            drawExtraStaffLine(numberOfLines: 4, notePosX: notePosX, notePosY: notePosY, linePosY: [5.0, 15.0, 25.0, 35.0])
        } else if noteStaffOffsetY >= 43 && noteStaffOffsetY <= 47 {
            drawExtraStaffLine(numberOfLines: 4, notePosX: notePosX, notePosY: notePosY, linePosY: [10.0, 20.0, 30.0, 40.0])
        } else if noteStaffOffsetY >= 48 && noteStaffOffsetY <= 52 {
            drawExtraStaffLine(numberOfLines: 5, notePosX: notePosX, notePosY: notePosY, linePosY: [5.0, 15.0, 25.0, 35.0, 45.0])
        } else if noteStaffOffsetY >= 53 && noteStaffOffsetY <= 57 {
            drawExtraStaffLine(numberOfLines: 5, notePosX: notePosX, notePosY: notePosY, linePosY: [10.0, 20.0, 30.0, 40.0, 50.0])
        } else if noteStaffOffsetY >= 58 && noteStaffOffsetY <= 62 {
            drawExtraStaffLine(numberOfLines: 6, notePosX: notePosX, notePosY: notePosY, linePosY: [5.0, 15.0, 25.0, 35.0, 45.0, 55.0])
        } else if noteStaffOffsetY >= 63 && noteStaffOffsetY <= 67 {
            drawExtraStaffLine(numberOfLines: 6, notePosX: notePosX, notePosY: notePosY, linePosY: [10.0, 20.0, 30.0, 40.0, 50.0, 60.0])
        } else if noteStaffOffsetY >= 68 && noteStaffOffsetY <= 72 {
            drawExtraStaffLine(numberOfLines: 7, notePosX: notePosX, notePosY: notePosY, linePosY: [5.0, 15.0, 25.0, 35.0, 45.0, 55.0, 65.0])
        } else if noteStaffOffsetY >= 73 && noteStaffOffsetY <= 77 {
            drawExtraStaffLine(numberOfLines: 7, notePosX: notePosX, notePosY: notePosY, linePosY: [10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0])
        } else if noteStaffOffsetY >= 78 && noteStaffOffsetY <= 82 {
            drawExtraStaffLine(numberOfLines: 8, notePosX: notePosX, notePosY: notePosY, linePosY: [5.0, 15.0, 25.0, 35.0, 45.0, 55.0, 65.0, 75.0])
        } else if noteStaffOffsetY >= 83 && noteStaffOffsetY <= 87 {
            drawExtraStaffLine(numberOfLines: 8, notePosX: notePosX, notePosY: notePosY, linePosY: [10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0])
        }
        
        if noteStaffOffsetY <= -48 && noteStaffOffsetY >= -52 {
            drawExtraStaffLine(numberOfLines: 1, notePosX: notePosX, notePosY: notePosY, linePosY: [5.0])
        } else if noteStaffOffsetY <= -53 && noteStaffOffsetY >= -57 {
            drawExtraStaffLine(numberOfLines: 1, notePosX: notePosX, notePosY: notePosY, linePosY: [0.0])
        } else if noteStaffOffsetY <= -58 && noteStaffOffsetY >= -62 {
            drawExtraStaffLine(numberOfLines: 2, notePosX: notePosX, notePosY: notePosY, linePosY: [5.0, -5.0])
        } else if noteStaffOffsetY <= -63 && noteStaffOffsetY >= -67 {
            drawExtraStaffLine(numberOfLines: 2, notePosX: notePosX, notePosY: notePosY, linePosY: [0.0, -10.0])
        } else if noteStaffOffsetY <= -68 && noteStaffOffsetY >= -72 {
            drawExtraStaffLine(numberOfLines: 3, notePosX: notePosX, notePosY: notePosY, linePosY: [5.0, -5.0, -15.0])
        } else if noteStaffOffsetY <= -73 && noteStaffOffsetY >= -77 {
            drawExtraStaffLine(numberOfLines: 3, notePosX: notePosX, notePosY: notePosY, linePosY: [0.0, -10.0, -20.0])
        } else if noteStaffOffsetY <= -78 && noteStaffOffsetY >= -82 {
            drawExtraStaffLine(numberOfLines: 4, notePosX: notePosX, notePosY: notePosY, linePosY: [5.0, -5.0, -15.0, -25.0])
        } else if noteStaffOffsetY <= -83 && noteStaffOffsetY >= -87 {
            drawExtraStaffLine(numberOfLines: 4, notePosX: notePosX, notePosY: notePosY, linePosY: [0.0, -10.0, -20.0, -30.0])
        } else if noteStaffOffsetY <= -88 && noteStaffOffsetY >= -92 {
            drawExtraStaffLine(numberOfLines: 5, notePosX: notePosX, notePosY: notePosY, linePosY: [5.0, -5.0, -15.0, -25.0, -35.0])
        } else if noteStaffOffsetY <= -93 && noteStaffOffsetY >= -97 {
            drawExtraStaffLine(numberOfLines: 5, notePosX: notePosX, notePosY: notePosY, linePosY: [0.0, -10.0, -20.0, -30.0, -40.0])
        } else if noteStaffOffsetY <= -98 && noteStaffOffsetY >= -102 {
            drawExtraStaffLine(numberOfLines: 6, notePosX: notePosX, notePosY: notePosY, linePosY: [5.0, -5.0, -15.0, -25.0, -35.0, -45.0])
        } else if noteStaffOffsetY <= -103 && noteStaffOffsetY >= -107 {
            drawExtraStaffLine(numberOfLines: 6, notePosX: notePosX, notePosY: notePosY, linePosY: [0.0, -10.0, -20.0, -30.0, -40.0, -50.0])
        } else if noteStaffOffsetY <= -108 && noteStaffOffsetY >= -112 {
            drawExtraStaffLine(numberOfLines: 7, notePosX: notePosX, notePosY: notePosY, linePosY: [5.0, -5.0, -15.0, -25.0, -35.0, -45.0, -55.0])
        } else if noteStaffOffsetY <= -113 && noteStaffOffsetY >= -117 {
            drawExtraStaffLine(numberOfLines: 7, notePosX: notePosX, notePosY: notePosY, linePosY: [0.0, -10.0, -20.0, -30.0, -40.0, -50.0, -60.0])
        } else if noteStaffOffsetY <= -118 && noteStaffOffsetY >= -122 {
            drawExtraStaffLine(numberOfLines: 8, notePosX: notePosX, notePosY: notePosY, linePosY: [5.0, -5.0, -15.0, -25.0, -35.0, -45.0, -55.0, -65.0])
        } else if noteStaffOffsetY <= -123 && noteStaffOffsetY >= -127 {
            drawExtraStaffLine(numberOfLines: 8, notePosX: notePosX, notePosY: notePosY, linePosY: [0.0, -10.0, -20.0, -30.0, -40.0, -50.0, -60.0, -70.0])
        }
        
    }
    func drawExtraStaffLine(numberOfLines: Int, notePosX: CGFloat, notePosY: CGFloat, linePosY: [CGFloat]) {
        for i in 0...numberOfLines - 1 {
            let line1 = UIBezierPath()
            line1.lineWidth = 1.25
            line1.move(to: CGPoint(x: notePosX - 2.5, y: notePosY + linePosY[i]))
            line1.addLine(to: CGPoint(x: notePosX + 14.5, y: notePosY + linePosY[i]))
            UIColor.black.setStroke()
            line1.stroke()
        }
    }
    func drawArpeggio(xPos: CGFloat, y1Pos: CGFloat, y2Pos: CGFloat) {
        let numberOfZigZags: Int = Int((y1Pos-y2Pos)/8)
        for y in 1...numberOfZigZags+1 {
            let distancet = CGFloat(8*y)
            
            let arpeggio = UIBezierPath()
            arpeggio.move(to: CGPoint(x: xPos - 14, y: y1Pos + 20 - distancet-8))
            arpeggio.lineWidth = 3.0
            arpeggio.addLine(to: CGPoint(x: xPos - 20, y: y1Pos + 20 - distancet-4))
            UIColor.black.setStroke()
            arpeggio.stroke()
            
            let arpeggio2 = UIBezierPath()
            arpeggio2.move(to: CGPoint(x: xPos - 20, y: y1Pos + 20 - distancet-4))
            arpeggio2.lineWidth = 1.0
            arpeggio2.addLine(to: CGPoint(x: xPos - 14, y: y1Pos + 20 - distancet))
            UIColor.black.setStroke()
            arpeggio2.stroke()
            
            if y >= numberOfZigZags+1 {
                let arpeggio2 = UIBezierPath()
                arpeggio2.move(to: CGPoint(x: xPos - 14, y: y1Pos + 20 - distancet-8))
                arpeggio2.lineWidth = 1.0
                arpeggio2.addLine(to: CGPoint(x: xPos - 20, y: y1Pos + 20 - distancet-12))
                UIColor.black.setStroke()
                arpeggio2.stroke()
            }
        }
    }
    
    func drawBeams() {
        //find smallest value & stem direction
        getBeam1SameStaff()
        
        if sameStemDirBeam {
            
            if thisNote.noteStem == "up" {
                getBeam1ShortestIndexUp()
                
                if highestNoteIndexBeam1 == 0 {
                    //draw angled beam from first note
                    
                    var stemLengthForBeams: CGFloat = 30.0
                    if beamCount == 3 {
                        stemLengthForBeams = 39
                    } else if beamCount == 4 {
                        stemLengthForBeams = 48
                    }
                    
                    let stem = UIBezierPath()
                    stem.lineWidth = 1.0
                    stem.move(to: CGPoint(x: beam1Array[0].notePos.x + 11.5, y: beam1Array[0].notePos.y + 4))
                    stem.addLine(to: CGPoint(x: beam1Array[0].notePos.x + 11.5, y: beam1Array[0].notePos.y - stemLengthForBeams))
                    UIColor.black.setStroke()
                    stem.stroke()
                    
                    let shortestDifference: CGFloat = beam1Array[beam1Array.count - 1].notePos.y - beam1Array[0].notePos.y
                    let totalWidthDifference: CGFloat = beam1Array[0].notePos.x - beam1Array[beam1Array.count - 1].notePos.x
                    
                    let lastStem = UIBezierPath()
                    lastStem.lineWidth = 1.0
                    lastStem.move(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 11.5, y: beam1Array[beam1Array.count - 1].notePos.y + 4))
                    lastStem.addLine(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 11.5, y: beam1Array[beam1Array.count - 1].notePos.y - shortestDifference - stemLengthForBeams + 10))
                    UIColor.black.setStroke()
                    lastStem.stroke()
                    
                    let beam1 = UIBezierPath()
                    beam1.lineWidth = 1.0
                    beam1.move(to: CGPoint(x: beam1Array[0].notePos.x + 11.5, y: beam1Array[0].notePos.y - stemLengthForBeams - 2))
                    beam1.addLine(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 11.5, y: beam1Array[beam1Array.count - 1].notePos.y - shortestDifference - stemLengthForBeams + 8))
                    beam1.addLine(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 11.5, y: beam1Array[beam1Array.count - 1].notePos.y - shortestDifference - stemLengthForBeams + 12))
                    beam1.addLine(to: CGPoint(x: beam1Array[0].notePos.x + 11.5, y: beam1Array[0].notePos.y - stemLengthForBeams + 2))
                    beam1.addLine(to: CGPoint(x: beam1Array[0].notePos.x + 11.5, y: beam1Array[0].notePos.y - stemLengthForBeams - 2))
                    
                    UIColor.black.setStroke()
                    beam1.stroke()
                    UIColor.black.setFill()
                    beam1.fill()
                    
                    if beam1Array.count >= 3 {
                        for i in 1...beam1Array.count - 2 {
                            let XDifference: CGFloat = beam1Array[0].notePos.x - beam1Array[i].notePos.x
                            let YDifference: CGFloat = beam1Array[i].notePos.y - beam1Array[0].notePos.y
                            
                            let angleOfBeam: CGFloat = asin(10/totalWidthDifference)
                            let lengthToCut: CGFloat = XDifference*(tan(angleOfBeam))
                            
                            let stem = UIBezierPath()
                            stem.lineWidth = 1.0
                            stem.move(to: CGPoint(x: beam1Array[i].notePos.x + 11.5, y: beam1Array[i].notePos.y + 4))
                            stem.addLine(to: CGPoint(x: beam1Array[i].notePos.x + 11.5, y: beam1Array[i].notePos.y - YDifference - stemLengthForBeams + lengthToCut))
                            UIColor.black.setStroke()
                            stem.stroke()
                        }
                    }
                    if beamCount >= 2 {
                        let beam2 = UIBezierPath()
                        beam2.lineWidth = 1.0
                        if beam2Array[beam2Array.count - 1].state == "backward hook" {
                            beam2.move(to: CGPoint(x: beam2Array[beam2Array.count - 1].notePos.x - 0, y: beam2Array[beam2Array.count - 1].notePos.y - stemLengthForBeams + 11))
                            beam2.addLine(to: CGPoint(x: beam2Array[beam2Array.count - 1].notePos.x + 11.5, y: beam2Array[beam2Array.count - 1].notePos.y - shortestDifference - stemLengthForBeams + 15))
                            beam2.addLine(to: CGPoint(x: beam2Array[beam2Array.count - 1].notePos.x + 11.5, y: beam2Array[beam2Array.count - 1].notePos.y - shortestDifference - stemLengthForBeams + 19))
                            beam2.addLine(to: CGPoint(x: beam2Array[beam2Array.count - 1].notePos.x - 0, y: beam2Array[beam2Array.count - 1].notePos.y - stemLengthForBeams + 15))
                            beam2.addLine(to: CGPoint(x: beam2Array[beam2Array.count - 1].notePos.x - 0, y: beam2Array[beam2Array.count - 1].notePos.y - stemLengthForBeams + 11))
                        } else {
                            beam2.move(to: CGPoint(x: beam2Array[0].notePos.x + 11.5, y: beam2Array[0].notePos.y - stemLengthForBeams + 5))
                            beam2.addLine(to: CGPoint(x: beam2Array[beam2Array.count - 1].notePos.x + 11.5, y: beam2Array[beam2Array.count - 1].notePos.y - shortestDifference - stemLengthForBeams + 15))
                            beam2.addLine(to: CGPoint(x: beam2Array[beam2Array.count - 1].notePos.x + 11.5, y: beam2Array[beam2Array.count - 1].notePos.y - shortestDifference - stemLengthForBeams + 19))
                            beam2.addLine(to: CGPoint(x: beam2Array[0].notePos.x + 11.5, y: beam2Array[0].notePos.y - stemLengthForBeams + 9))
                            beam2.addLine(to: CGPoint(x: beam2Array[0].notePos.x + 11.5, y: beam2Array[0].notePos.y - stemLengthForBeams + 5))
                        }
                        UIColor.black.setStroke()
                        beam2.stroke()
                        UIColor.black.setFill()
                        beam2.fill()
                    }
                    if beamCount >= 3 {
                        let beam3 = UIBezierPath()
                        beam3.lineWidth = 1.0
                        beam3.move(to: CGPoint(x: beam3Array[0].notePos.x + 11.5, y: beam3Array[0].notePos.y - stemLengthForBeams + 12))
                        beam3.addLine(to: CGPoint(x: beam3Array[beam3Array.count - 1].notePos.x + 11.5, y: beam3Array[beam3Array.count - 1].notePos.y - shortestDifference - stemLengthForBeams + 22))
                        beam3.addLine(to: CGPoint(x: beam3Array[beam3Array.count - 1].notePos.x + 11.5, y: beam3Array[beam3Array.count - 1].notePos.y - shortestDifference - stemLengthForBeams + 26))
                        beam3.addLine(to: CGPoint(x: beam3Array[0].notePos.x + 11.5, y: beam3Array[0].notePos.y - stemLengthForBeams + 16))
                        beam3.addLine(to: CGPoint(x: beam3Array[0].notePos.x + 11.5, y: beam3Array[0].notePos.y - stemLengthForBeams + 12))
                        
                        UIColor.black.setStroke()
                        beam3.stroke()
                        UIColor.black.setFill()
                        beam3.fill()
                    }
                    if beamCount >= 4 {
                        let beam4 = UIBezierPath()
                        beam4.lineWidth = 1.0
                        beam4.move(to: CGPoint(x: beam4Array[0].notePos.x + 11.5, y: beam4Array[0].notePos.y - stemLengthForBeams - 19))
                        beam4.addLine(to: CGPoint(x: beam4Array[beam4Array.count - 1].notePos.x + 11.5, y: beam4Array[beam4Array.count - 1].notePos.y - shortestDifference - stemLengthForBeams + 29))
                        beam4.addLine(to: CGPoint(x: beam4Array[beam4Array.count - 1].notePos.x + 11.5, y: beam4Array[beam4Array.count - 1].notePos.y - shortestDifference - stemLengthForBeams + 33))
                        beam4.addLine(to: CGPoint(x: beam4Array[0].notePos.x + 11.5, y: beam4Array[0].notePos.y - stemLengthForBeams + 23))
                        beam4.addLine(to: CGPoint(x: beam4Array[0].notePos.x + 11.5, y: beam4Array[0].notePos.y - stemLengthForBeams + 19))
                        
                        UIColor.black.setStroke()
                        beam4.stroke()
                        UIColor.black.setFill()
                        beam4.fill()
                    }
                    
                    
                } else if highestNoteIndexBeam1 == beam1Array.count - 1 {
                    //draw angled beam from last note
                    
                    var stemLengthForBeams: CGFloat = 30.0
                    if beamCount == 3 {
                        stemLengthForBeams = 39
                    } else if beamCount == 4 {
                        stemLengthForBeams = 48
                    }
                    
                    let stem = UIBezierPath()
                    stem.lineWidth = 1.0
                    stem.move(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 11.5, y: beam1Array[beam1Array.count - 1].notePos.y + 4))
                    stem.addLine(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 11.5, y: beam1Array[beam1Array.count - 1].notePos.y - stemLengthForBeams))
                    UIColor.black.setStroke()
                    stem.stroke()
                    
                    let shortestDifference: CGFloat = beam1Array[0].notePos.y - beam1Array[beam1Array.count - 1].notePos.y
                    let totalWidthDifference: CGFloat = beam1Array[beam1Array.count - 1].notePos.x - beam1Array[0].notePos.x
                    
                    let lastStem = UIBezierPath()
                    lastStem.lineWidth = 1.0
                    lastStem.move(to: CGPoint(x: beam1Array[0].notePos.x + 11.5, y: beam1Array[0].notePos.y + 4))
                    lastStem.addLine(to: CGPoint(x: beam1Array[0].notePos.x + 11.5, y: beam1Array[0].notePos.y - shortestDifference - stemLengthForBeams + 10))
                    UIColor.black.setStroke()
                    lastStem.stroke()
                    
                    let beam1 = UIBezierPath()
                    beam1.lineWidth = 1.0
                    beam1.move(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 11.5, y: beam1Array[beam1Array.count - 1].notePos.y - stemLengthForBeams - 2))
                    beam1.addLine(to: CGPoint(x: beam1Array[0].notePos.x + 11.5, y: beam1Array[0].notePos.y - shortestDifference - stemLengthForBeams + 8))
                    beam1.addLine(to: CGPoint(x: beam1Array[0].notePos.x + 11.5, y: beam1Array[0].notePos.y - shortestDifference - stemLengthForBeams + 12))
                    beam1.addLine(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 11.5, y: beam1Array[beam1Array.count - 1].notePos.y - stemLengthForBeams + 2))
                    beam1.addLine(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 11.5, y: beam1Array[beam1Array.count - 1].notePos.y - stemLengthForBeams - 2))
                    
                    UIColor.black.setStroke()
                    beam1.stroke()
                    UIColor.black.setFill()
                    beam1.fill()
                    
                    if beam1Array.count >= 3 {
                        for i in 1...beam1Array.count - 2 {
                            let XDifference: CGFloat = beam1Array[beam1Array.count - 1].notePos.x - beam1Array[i].notePos.x
                            let YDifference: CGFloat = beam1Array[i].notePos.y - beam1Array[beam1Array.count - 1].notePos.y
                            
                            let angleOfBeam: CGFloat = asin(10/totalWidthDifference)
                            let lengthToCut: CGFloat = XDifference*(tan(angleOfBeam))
                            
                            let stem = UIBezierPath()
                            stem.lineWidth = 1.0
                            stem.move(to: CGPoint(x: beam1Array[i].notePos.x + 11.5, y: beam1Array[i].notePos.y + 4))
                            stem.addLine(to: CGPoint(x: beam1Array[i].notePos.x + 11.5, y: beam1Array[i].notePos.y - YDifference - stemLengthForBeams + lengthToCut))
                            UIColor.black.setStroke()
                            stem.stroke()
                        }
                    }
                    if beamCount >= 2 {
                        let beam2 = UIBezierPath()
                        beam2.lineWidth = 1.0
                        if beam2Array[beam2Array.count - 1].state == "backward hook" {
                            beam2.move(to: CGPoint(x: beam2Array[beam2Array.count - 1].notePos.x + 0, y: beam2Array[beam2Array.count - 1].notePos.y - stemLengthForBeams + 11))
                            beam2.addLine(to: CGPoint(x: beam2Array[beam2Array.count - 1].notePos.x + 11.5, y: beam2Array[beam2Array.count - 1].notePos.y - shortestDifference - stemLengthForBeams + 15))
                            beam2.addLine(to: CGPoint(x: beam2Array[beam2Array.count - 1].notePos.x + 11.5, y: beam2Array[beam2Array.count - 1].notePos.y - shortestDifference - stemLengthForBeams + 19))
                            beam2.addLine(to: CGPoint(x: beam2Array[beam2Array.count - 1].notePos.x + 0, y: beam2Array[beam2Array.count - 1].notePos.y - stemLengthForBeams + 15))
                            beam2.addLine(to: CGPoint(x: beam2Array[beam2Array.count - 1].notePos.x + 0, y: beam2Array[beam2Array.count - 1].notePos.y - stemLengthForBeams + 11))
                        } else {
                            beam2.move(to: CGPoint(x: beam2Array[beam2Array.count - 1].notePos.x + 11.5, y: beam2Array[beam2Array.count - 1].notePos.y - stemLengthForBeams + 5))
                            beam2.addLine(to: CGPoint(x: beam2Array[0].notePos.x + 11.5, y: beam2Array[0].notePos.y - shortestDifference - stemLengthForBeams + 15))
                            beam2.addLine(to: CGPoint(x: beam2Array[0].notePos.x + 11.5, y: beam2Array[0].notePos.y - shortestDifference - stemLengthForBeams + 19))
                            beam2.addLine(to: CGPoint(x: beam2Array[beam2Array.count - 1].notePos.x + 11.5, y: beam2Array[beam2Array.count - 1].notePos.y - stemLengthForBeams + 9))
                            beam2.addLine(to: CGPoint(x: beam2Array[beam2Array.count - 1].notePos.x + 11.5, y: beam2Array[beam2Array.count - 1].notePos.y - stemLengthForBeams + 5))
                        }
                        UIColor.black.setStroke()
                        beam2.stroke()
                        UIColor.black.setFill()
                        beam2.fill()
                    }
                    if beamCount >= 3 {
                        let beam3 = UIBezierPath()
                        beam3.lineWidth = 1.0
                        beam3.move(to: CGPoint(x: beam3Array[beam3Array.count - 1].notePos.x + 11.5, y: beam3Array[beam3Array.count - 1].notePos.y - stemLengthForBeams + 12))
                        beam3.addLine(to: CGPoint(x: beam3Array[0].notePos.x + 11.5, y: beam3Array[0].notePos.y - shortestDifference - stemLengthForBeams + 22))
                        beam3.addLine(to: CGPoint(x: beam3Array[0].notePos.x + 11.5, y: beam3Array[0].notePos.y - shortestDifference - stemLengthForBeams + 26))
                        beam3.addLine(to: CGPoint(x: beam3Array[beam3Array.count - 1].notePos.x + 11.5, y: beam3Array[beam3Array.count - 1].notePos.y - stemLengthForBeams + 16))
                        beam3.addLine(to: CGPoint(x: beam3Array[beam3Array.count - 1].notePos.x + 11.5, y: beam3Array[beam3Array.count - 1].notePos.y - stemLengthForBeams + 12))
                        
                        UIColor.black.setStroke()
                        beam3.stroke()
                        UIColor.black.setFill()
                        beam3.fill()
                    }
                    if beamCount >= 4 {
                        let beam4 = UIBezierPath()
                        
                        beam4.lineWidth = 1.0
                        beam4.move(to: CGPoint(x: beam4Array[beam4Array.count - 1].notePos.x + 11.5, y: beam4Array[beam4Array.count - 1].notePos.y - stemLengthForBeams + 19))
                        beam4.addLine(to: CGPoint(x: beam4Array[0].notePos.x + 11.5, y: beam4Array[0].notePos.y - shortestDifference - stemLengthForBeams + 29))
                        beam4.addLine(to: CGPoint(x: beam4Array[0].notePos.x + 11.5, y: beam4Array[0].notePos.y - shortestDifference - stemLengthForBeams + 33))
                        beam4.addLine(to: CGPoint(x: beam4Array[beam4Array.count - 1].notePos.x + 11.5, y: beam4Array[beam4Array.count - 1].notePos.y - stemLengthForBeams + 23))
                        beam4.addLine(to: CGPoint(x: beam4Array[beam4Array.count - 1].notePos.x + 11.5, y: beam4Array[beam4Array.count - 1].notePos.y - stemLengthForBeams + 19))
                        
                        UIColor.black.setStroke()
                        beam4.stroke()
                        UIColor.black.setFill()
                        beam4.fill()
                    }
                    
                    
                    
                    
                    
                } else {
                    //draw straight beam
                    for i in 0...beam1Array.count - 1 {
                        let shortestDifference: CGFloat = beam1Array[highestNoteIndexBeam1].notePos.y - beam1Array[i].notePos.y
                        
                        let stem = UIBezierPath()
                        stem.lineWidth = 1.0
                        stem.move(to: CGPoint(x: beam1Array[i].notePos.x + 11.5, y: beam1Array[i].notePos.y + 4))
                        stem.addLine(to: CGPoint(x: beam1Array[i].notePos.x + 11.5, y: beam1Array[i].notePos.y - 29 + shortestDifference))
                        UIColor.black.setStroke()
                        stem.stroke()
                    }
                    let shortestDifference: CGFloat = beam1Array[highestNoteIndexBeam1].notePos.y - beam1Array[beam1Array.count - 1].notePos.y
                    
                    let beam1 = UIBezierPath()
                    beam1.lineWidth = 5.0
                    beam1.move(to: CGPoint(x: beam1Array[0].notePos.x + 11, y: beam1Array[beam1Array.count - 1].notePos.y - 29 + shortestDifference))
                    beam1.addLine(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 12, y: beam1Array[beam1Array.count - 1].notePos.y - 29 + shortestDifference))
                    UIColor.black.setStroke()
                    beam1.stroke()
                    
                    if beamCount >= 2 {
                        let beam2 = UIBezierPath()
                        beam2.lineWidth = 5.0
                        beam2.move(to: CGPoint(x: beam2Array[0].notePos.x + 11, y: beam1Array[beam1Array.count - 1].notePos.y - 22.25 + shortestDifference))
                        beam2.addLine(to: CGPoint(x: beam2Array[beam2Array.count - 1].notePos.x + 12, y: beam1Array[beam1Array.count - 1].notePos.y - 22.25 + shortestDifference))
                        UIColor.black.setStroke()
                        beam2.stroke()
                    }
                    if beamCount >= 3 {
                        let beam3 = UIBezierPath()
                        beam3.lineWidth = 5.0
                        beam3.move(to: CGPoint(x: beam3Array[0].notePos.x + 11, y: beam1Array[beam1Array.count - 1].notePos.y - 15.25 + shortestDifference))
                        beam3.addLine(to: CGPoint(x: beam3Array[beam3Array.count - 1].notePos.x + 12, y: beam1Array[beam1Array.count - 1].notePos.y - 15.25 + shortestDifference))
                        UIColor.black.setStroke()
                        beam3.stroke()
                    }
                    if beamCount >= 4 {
                        let beam4 = UIBezierPath()
                        beam4.lineWidth = 5.0
                        beam4.move(to: CGPoint(x: beam4Array[0].notePos.x + 11, y: beam1Array[beam1Array.count - 1].notePos.y - 35.25 + shortestDifference))
                        beam4.addLine(to: CGPoint(x: beam4Array[beam4Array.count - 1].notePos.x + 12, y: beam1Array[beam1Array.count - 1].notePos.y - 35.25 + shortestDifference))
                        UIColor.black.setStroke()
                        beam4.stroke()
                    }
                }
            } else if thisNote.noteStem == "down" {
                getBeam1ShortestIndexDown()
                
                if lowestNoteIndexBeam1 == 0 {
                    //draw angled beam from first note
                    
                    var stemLengthForBeams: CGFloat = 36.0
                    if beamCount == 3 {
                        stemLengthForBeams = 45
                    } else if beamCount == 4 {
                        stemLengthForBeams = 54
                    }
                    
                    let stem = UIBezierPath()
                    stem.lineWidth = 1.0
                    stem.move(to: CGPoint(x: beam1Array[0].notePos.x + 0.5, y: beam1Array[0].notePos.y + 6))
                    stem.addLine(to: CGPoint(x: beam1Array[0].notePos.x + 0.5, y: beam1Array[0].notePos.y + stemLengthForBeams))
                    UIColor.black.setStroke()
                    stem.stroke()
                    
                    let shortestDifference: CGFloat = beam1Array[0].notePos.y - beam1Array[beam1Array.count - 1].notePos.y
                    let totalWidthDifference: CGFloat = beam1Array[beam1Array.count - 1].notePos.x - beam1Array[0].notePos.x
                    
                    let lastStem = UIBezierPath()
                    lastStem.lineWidth = 1.0
                    lastStem.move(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 0.5, y: beam1Array[beam1Array.count - 1].notePos.y + 6))
                    lastStem.addLine(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 0.5, y: beam1Array[beam1Array.count - 1].notePos.y + shortestDifference + stemLengthForBeams - 10))
                    UIColor.black.setStroke()
                    lastStem.stroke()
                    
                    let beam1 = UIBezierPath()
                    beam1.lineWidth = 1.0
                    beam1.move(to: CGPoint(x: beam1Array[0].notePos.x + 0.5, y: beam1Array[0].notePos.y + stemLengthForBeams + 2))
                    beam1.addLine(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 0.5, y: beam1Array[beam1Array.count - 1].notePos.y + shortestDifference + stemLengthForBeams - 8))
                    beam1.addLine(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 0.5, y: beam1Array[beam1Array.count - 1].notePos.y + shortestDifference + stemLengthForBeams - 12))
                    beam1.addLine(to: CGPoint(x: beam1Array[0].notePos.x + 0.5, y: beam1Array[0].notePos.y + stemLengthForBeams - 2))
                    beam1.addLine(to: CGPoint(x: beam1Array[0].notePos.x + 0.5, y: beam1Array[0].notePos.y + stemLengthForBeams + 2))
                    
                    UIColor.black.setStroke()
                    beam1.stroke()
                    UIColor.black.setFill()
                    beam1.fill()
                    
                    if beam1Array.count >= 3 {
                        for i in 1...beam1Array.count - 2 {
                            let XDifference: CGFloat = beam1Array[i].notePos.x - beam1Array[0].notePos.x
                            let YDifference: CGFloat = beam1Array[0].notePos.y - beam1Array[i].notePos.y
                            
                            let angleOfBeam: CGFloat = asin(10/totalWidthDifference)
                            let lengthToCut: CGFloat = XDifference*(tan(angleOfBeam))
                            
                            let stem = UIBezierPath()
                            stem.lineWidth = 1.0
                            stem.move(to: CGPoint(x: beam1Array[i].notePos.x + 0.5, y: beam1Array[i].notePos.y + 6))
                            stem.addLine(to: CGPoint(x: beam1Array[i].notePos.x + 0.5, y: beam1Array[i].notePos.y + YDifference + stemLengthForBeams - lengthToCut))
                            UIColor.black.setStroke()
                            stem.stroke()
                        }
                    }
                    if beamCount >= 2 {
                        let beam2 = UIBezierPath()
                        beam2.lineWidth = 1.0
                        if beam2Array[beam2Array.count - 1].state == "backward hook" {
                            beam2.move(to: CGPoint(x: beam2Array[0].notePos.x + 0, y: beam2Array[0].notePos.y + stemLengthForBeams - 16))
                            beam2.addLine(to: CGPoint(x: beam2Array[0].notePos.x - 11.5, y: beam2Array[0].notePos.y + shortestDifference + stemLengthForBeams - 15))
                            beam2.addLine(to: CGPoint(x: beam2Array[0].notePos.x - 11.5, y: beam2Array[0].notePos.y + shortestDifference + stemLengthForBeams - 19))
                            beam2.addLine(to: CGPoint(x: beam2Array[0].notePos.x + 0, y: beam2Array[0].notePos.y + stemLengthForBeams - 20))
                            beam2.addLine(to: CGPoint(x: beam2Array[0].notePos.x + 0, y: beam2Array[0].notePos.y + stemLengthForBeams - 16))
                        } else {
                            beam2.move(to: CGPoint(x: beam2Array[0].notePos.x + 0.5, y: beam2Array[0].notePos.y + stemLengthForBeams - 5))
                            beam2.addLine(to: CGPoint(x: beam2Array[beam2Array.count - 1].notePos.x + 0.5, y: beam2Array[beam2Array.count - 1].notePos.y + shortestDifference + stemLengthForBeams - 15))
                            beam2.addLine(to: CGPoint(x: beam2Array[beam2Array.count - 1].notePos.x + 0.5, y: beam2Array[beam2Array.count - 1].notePos.y + shortestDifference + stemLengthForBeams - 19))
                            beam2.addLine(to: CGPoint(x: beam2Array[0].notePos.x + 0.5, y: beam2Array[0].notePos.y + stemLengthForBeams - 9))
                            beam2.addLine(to: CGPoint(x: beam2Array[0].notePos.x + 0.5, y: beam2Array[0].notePos.y + stemLengthForBeams - 5))
                        }
                        UIColor.black.setStroke()
                        beam2.stroke()
                        UIColor.black.setFill()
                        beam2.fill()
                    }
                    if beamCount >= 3 {
                        let beam3 = UIBezierPath()
                        beam3.lineWidth = 1.0
                        beam3.move(to: CGPoint(x: beam3Array[0].notePos.x + 0.5, y: beam3Array[0].notePos.y + stemLengthForBeams - 12))
                        beam3.addLine(to: CGPoint(x: beam3Array[beam3Array.count - 1].notePos.x + 0.5, y: beam3Array[beam3Array.count - 1].notePos.y + shortestDifference + stemLengthForBeams - 22))
                        beam3.addLine(to: CGPoint(x: beam3Array[beam3Array.count - 1].notePos.x + 0.5, y: beam3Array[beam3Array.count - 1].notePos.y + shortestDifference + stemLengthForBeams - 26))
                        beam3.addLine(to: CGPoint(x: beam3Array[0].notePos.x + 0.5, y: beam3Array[0].notePos.y + stemLengthForBeams - 16))
                        beam3.addLine(to: CGPoint(x: beam3Array[0].notePos.x + 0.5, y: beam3Array[0].notePos.y + stemLengthForBeams - 12))
                        
                        UIColor.black.setStroke()
                        beam3.stroke()
                        UIColor.black.setFill()
                        beam3.fill()
                    }
                    if beamCount >= 4 {
                        let beam4 = UIBezierPath()
                        beam4.lineWidth = 1.0
                        beam4.move(to: CGPoint(x: beam4Array[0].notePos.x + 0.5, y: beam4Array[0].notePos.y + stemLengthForBeams - 19))
                        beam4.addLine(to: CGPoint(x: beam4Array[beam4Array.count - 1].notePos.x + 0.5, y: beam4Array[beam4Array.count - 1].notePos.y + shortestDifference + stemLengthForBeams - 29))
                        beam4.addLine(to: CGPoint(x: beam4Array[beam4Array.count - 1].notePos.x + 0.5, y: beam4Array[beam4Array.count - 1].notePos.y + shortestDifference + stemLengthForBeams - 33))
                        beam4.addLine(to: CGPoint(x: beam4Array[0].notePos.x + 0.5, y: beam4Array[0].notePos.y + stemLengthForBeams - 23))
                        beam4.addLine(to: CGPoint(x: beam4Array[0].notePos.x + 0.5, y: beam4Array[0].notePos.y + stemLengthForBeams - 19))
                        
                        UIColor.black.setStroke()
                        beam4.stroke()
                        UIColor.black.setFill()
                        beam4.fill()
                    }
                    
                    
                } else if lowestNoteIndexBeam1 == beam1Array.count - 1 {
                    //draw angled beam from last note
                    
                    var stemLengthForBeams: CGFloat = 36.0
                    if beamCount == 3 {
                        stemLengthForBeams = 45
                    } else if beamCount == 4 {
                        stemLengthForBeams = 54
                    }
                    
                    let stem = UIBezierPath()
                    stem.lineWidth = 1.0
                    stem.move(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 0.5, y: beam1Array[beam1Array.count - 1].notePos.y + 6))
                    stem.addLine(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 0.5, y: beam1Array[beam1Array.count - 1].notePos.y + stemLengthForBeams))
                    UIColor.black.setStroke()
                    stem.stroke()
                    
                    let shortestDifference: CGFloat = beam1Array[beam1Array.count - 1].notePos.y - beam1Array[0].notePos.y
                    let totalWidthDifference: CGFloat = beam1Array[0].notePos.x - beam1Array[beam1Array.count - 1].notePos.x
                    
                    let lastStem = UIBezierPath()
                    lastStem.lineWidth = 1.0
                    lastStem.move(to: CGPoint(x: beam1Array[0].notePos.x + 0.5, y: beam1Array[0].notePos.y + 6))
                    lastStem.addLine(to: CGPoint(x: beam1Array[0].notePos.x + 0.5, y: beam1Array[0].notePos.y + shortestDifference + stemLengthForBeams - 10))
                    UIColor.black.setStroke()
                    lastStem.stroke()
                    
                    let beam1 = UIBezierPath()
                    beam1.lineWidth = 1.0
                    beam1.move(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 0.5, y: beam1Array[beam1Array.count - 1].notePos.y + stemLengthForBeams + 2))
                    beam1.addLine(to: CGPoint(x: beam1Array[0].notePos.x + 0.5, y: beam1Array[0].notePos.y + shortestDifference + stemLengthForBeams - 8))
                    beam1.addLine(to: CGPoint(x: beam1Array[0].notePos.x + 0.5, y: beam1Array[0].notePos.y + shortestDifference + stemLengthForBeams - 12))
                    beam1.addLine(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 0.5, y: beam1Array[beam1Array.count - 1].notePos.y + stemLengthForBeams - 2))
                    beam1.addLine(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 0.5, y: beam1Array[beam1Array.count - 1].notePos.y + stemLengthForBeams + 2))
                    
                    UIColor.black.setStroke()
                    beam1.stroke()
                    UIColor.black.setFill()
                    beam1.fill()
                    
                    if beam1Array.count >= 3 {
                        for i in 1...beam1Array.count - 2 {
                            let XDifference: CGFloat = beam1Array[i].notePos.x - beam1Array[beam1Array.count - 1].notePos.x
                            let YDifference: CGFloat = beam1Array[beam1Array.count - 1].notePos.y - beam1Array[i].notePos.y
                            
                            let angleOfBeam: CGFloat = asin(10/totalWidthDifference)
                            let lengthToCut: CGFloat = XDifference*(tan(angleOfBeam))
                            
                            let stem = UIBezierPath()
                            stem.lineWidth = 1.0
                            stem.move(to: CGPoint(x: beam1Array[i].notePos.x + 0.5, y: beam1Array[i].notePos.y + 6))
                            stem.addLine(to: CGPoint(x: beam1Array[i].notePos.x + 0.5, y: beam1Array[i].notePos.y + YDifference + stemLengthForBeams - lengthToCut))
                            UIColor.black.setStroke()
                            stem.stroke()
                        }
                    }
                    if beamCount >= 2 {
                        let beam2 = UIBezierPath()
                        beam2.lineWidth = 1.0
                        if beam2Array[beam2Array.count - 1].state == "backward hook" {
                            beam2.move(to: CGPoint(x: beam2Array[0].notePos.x + 0, y: beam2Array[0].notePos.y + stemLengthForBeams - 16))
                            beam2.addLine(to: CGPoint(x: beam2Array[0].notePos.x - 11.5, y: beam2Array[0].notePos.y + shortestDifference + stemLengthForBeams - 15))
                            beam2.addLine(to: CGPoint(x: beam2Array[0].notePos.x - 11.5, y: beam2Array[0].notePos.y + shortestDifference + stemLengthForBeams - 19))
                            beam2.addLine(to: CGPoint(x: beam2Array[0].notePos.x + 0, y: beam2Array[0].notePos.y + stemLengthForBeams - 20))
                            beam2.addLine(to: CGPoint(x: beam2Array[0].notePos.x + 0, y: beam2Array[0].notePos.y + stemLengthForBeams - 16))
                        } else {
                            beam2.move(to: CGPoint(x: beam2Array[beam2Array.count - 1].notePos.x + 0.5, y: beam2Array[beam2Array.count - 1].notePos.y + stemLengthForBeams - 5))
                            beam2.addLine(to: CGPoint(x: beam2Array[0].notePos.x + 0.5, y: beam2Array[0].notePos.y + shortestDifference + stemLengthForBeams - 15))
                            beam2.addLine(to: CGPoint(x: beam2Array[0].notePos.x + 0.5, y: beam2Array[0].notePos.y + shortestDifference + stemLengthForBeams - 19))
                            beam2.addLine(to: CGPoint(x: beam2Array[beam2Array.count - 1].notePos.x + 0.5, y: beam2Array[beam2Array.count - 1].notePos.y + stemLengthForBeams - 9))
                            beam2.addLine(to: CGPoint(x: beam2Array[beam2Array.count - 1].notePos.x + 0.5, y: beam2Array[beam2Array.count - 1].notePos.y + stemLengthForBeams - 5))
                        }
                        UIColor.black.setStroke()
                        beam2.stroke()
                        UIColor.black.setFill()
                        beam2.fill()
                    }
                    if beamCount >= 3 {
                        let beam3 = UIBezierPath()
                        beam3.lineWidth = 1.0
                        beam3.move(to: CGPoint(x: beam3Array[beam3Array.count - 1].notePos.x + 0.5, y: beam3Array[beam3Array.count - 1].notePos.y + stemLengthForBeams - 12))
                        beam3.addLine(to: CGPoint(x: beam3Array[0].notePos.x + 0.5, y: beam3Array[0].notePos.y + shortestDifference + stemLengthForBeams - 22))
                        beam3.addLine(to: CGPoint(x: beam3Array[0].notePos.x + 0.5, y: beam3Array[0].notePos.y + shortestDifference + stemLengthForBeams - 26))
                        beam3.addLine(to: CGPoint(x: beam3Array[beam3Array.count - 1].notePos.x + 0.5, y: beam3Array[beam3Array.count - 1].notePos.y + stemLengthForBeams - 16))
                        beam3.addLine(to: CGPoint(x: beam3Array[beam3Array.count - 1].notePos.x + 0.5, y: beam3Array[beam3Array.count - 1].notePos.y + stemLengthForBeams - 12))
                        
                        UIColor.black.setStroke()
                        beam3.stroke()
                        UIColor.black.setFill()
                        beam3.fill()
                    }
                    if beamCount >= 4 {
                        let beam4 = UIBezierPath()
                        
                        beam4.lineWidth = 1.0
                        beam4.move(to: CGPoint(x: beam4Array[beam4Array.count - 1].notePos.x + 0.5, y: beam4Array[beam4Array.count - 1].notePos.y + stemLengthForBeams - 19))
                        beam4.addLine(to: CGPoint(x: beam4Array[0].notePos.x + 0.5, y: beam4Array[0].notePos.y + shortestDifference + stemLengthForBeams - 29))
                        beam4.addLine(to: CGPoint(x: beam4Array[0].notePos.x + 0.5, y: beam4Array[0].notePos.y + shortestDifference + stemLengthForBeams - 33))
                        beam4.addLine(to: CGPoint(x: beam4Array[beam4Array.count - 1].notePos.x + 0.5, y: beam4Array[beam4Array.count - 1].notePos.y + stemLengthForBeams - 23))
                        beam4.addLine(to: CGPoint(x: beam4Array[beam4Array.count - 1].notePos.x + 0.5, y: beam4Array[beam4Array.count - 1].notePos.y + stemLengthForBeams - 19))
                        
                        UIColor.black.setStroke()
                        beam4.stroke()
                        UIColor.black.setFill()
                        beam4.fill()
                    }
                    
                    
                    
                } else {
                    //draw straight beam
                    for i in 0...beam1Array.count - 1 {
                        let shortestDifference: CGFloat = beam1Array[lowestNoteIndexBeam1].notePos.y - beam1Array[i].notePos.y
                        
                        let stem = UIBezierPath()
                        stem.lineWidth = 1.0
                        stem.move(to: CGPoint(x: beam1Array[i].notePos.x + 0.5, y: beam1Array[i].notePos.y + 6))
                        stem.addLine(to: CGPoint(x: beam1Array[i].notePos.x + 0.5, y: beam1Array[i].notePos.y + 36 + shortestDifference))
                        UIColor.black.setStroke()
                        stem.stroke()
                    }
                    let shortestDifference: CGFloat = beam1Array[lowestNoteIndexBeam1].notePos.y - beam1Array[beam1Array.count - 1].notePos.y
                    
                    let beam1 = UIBezierPath()
                    beam1.lineWidth = 5.0
                    beam1.move(to: CGPoint(x: beam1Array[0].notePos.x, y: beam1Array[beam1Array.count - 1].notePos.y + 36 + shortestDifference))
                    beam1.addLine(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 1, y: beam1Array[beam1Array.count - 1].notePos.y + 36 + shortestDifference))
                    UIColor.black.setStroke()
                    beam1.stroke()
                    
                    if beamCount >= 2 {
                        let beam2 = UIBezierPath()
                        beam2.lineWidth = 5.0
                        beam2.move(to: CGPoint(x: beam2Array[0].notePos.x, y: beam1Array[beam1Array.count - 1].notePos.y + 29.25 + shortestDifference))
                        beam2.addLine(to: CGPoint(x: beam2Array[beam2Array.count - 1].notePos.x + 1, y: beam1Array[beam1Array.count - 1].notePos.y + 29.25 + shortestDifference))
                        UIColor.black.setStroke()
                        beam2.stroke()
                    }
                    if beamCount >= 3 {
                        let beam3 = UIBezierPath()
                        beam3.lineWidth = 5.0
                        beam3.move(to: CGPoint(x: beam3Array[0].notePos.x, y: beam1Array[beam1Array.count - 1].notePos.y + 22.25 + shortestDifference))
                        beam3.addLine(to: CGPoint(x: beam3Array[beam3Array.count - 1].notePos.x + 1, y: beam1Array[beam1Array.count - 1].notePos.y + 22.25 + shortestDifference))
                        UIColor.black.setStroke()
                        beam3.stroke()
                    }
                    if beamCount >= 4 {
                        let beam4 = UIBezierPath()
                        beam4.lineWidth = 5.0
                        beam4.move(to: CGPoint(x: beam4Array[0].notePos.x, y: beam1Array[beam1Array.count - 1].notePos.y + 42.25 + shortestDifference))
                        beam4.addLine(to: CGPoint(x: beam4Array[beam4Array.count - 1].notePos.x + 1, y: beam1Array[beam1Array.count - 1].notePos.y + 42.25 + shortestDifference))
                        UIColor.black.setStroke()
                        beam4.stroke()
                    }
                }
            }
        } else {
            //different stem direction
            
            if beam1Array[0].noteStem == "down" {
                let stemChangeIndex: Int = Int(beamStemDirectionArray[0].state!)!
                let beamPosDiference: CGFloat = beamStemDirectionArray[0].notePos.y - (beam1Array[stemChangeIndex].notePos.y + 10)
                let beamPosY = beamStemDirectionArray[0].notePos.y - (beamPosDiference/2)
                
                
                let beam1 = UIBezierPath()
                beam1.lineWidth = 5.0
                beam1.move(to: CGPoint(x: beam1Array[0].notePos.x + 0.5, y: beamPosY))
                beam1.addLine(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 11.5, y: beamPosY))
                UIColor.black.setStroke()
                beam1.stroke()
                
                if beamCount == 2 {
                    let beam1 = UIBezierPath()
                    beam1.lineWidth = 5.0
                    beam1.move(to: CGPoint(x: beam1Array[0].notePos.x + 0.5, y: beamPosY + 7))
                    beam1.addLine(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 11.5, y: beamPosY + 7))
                    UIColor.black.setStroke()
                    beam1.stroke()
                } else if beamCount == 3 {
                    let beam1 = UIBezierPath()
                    beam1.lineWidth = 5.0
                    beam1.move(to: CGPoint(x: beam1Array[0].notePos.x + 0.5, y: beamPosY + 7))
                    beam1.addLine(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 11.5, y: beamPosY - 7))
                    UIColor.black.setStroke()
                    beam1.stroke()
                } else if beamCount == 4 {
                    let beam1 = UIBezierPath()
                    beam1.lineWidth = 5.0
                    beam1.move(to: CGPoint(x: beam1Array[0].notePos.x + 0.5, y: beamPosY + 7))
                    beam1.addLine(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 11.5, y: beamPosY + 14))
                    UIColor.black.setStroke()
                    beam1.stroke()
                }
                
                for i in 0...beam1Array.count - 1 {
                    
                    if i < beam1Array.count - beamStemDirectionArray.count {
                        let beamDifference: CGFloat = beamPosY - beam1Array[i].notePos.y
                        var extraStemLength: CGFloat = 0
                        if beamCount == 2 {
                            extraStemLength = 7
                        } else if beamCount == 3 {
                            extraStemLength = 14
                        } else if beamCount == 4 {
                            extraStemLength = 21
                        }
                        
                        let stem = UIBezierPath()
                        stem.lineWidth = 1.0
                        stem.move(to: CGPoint(x: beam1Array[i].notePos.x + 0.5, y: beam1Array[i].notePos.y + 6))
                        stem.addLine(to: CGPoint(x: beam1Array[i].notePos.x + 0.5, y: beam1Array[i].notePos.y + 2.5 + extraStemLength + beamDifference))
                        UIColor.black.setStroke()
                        stem.stroke()
                        
                    } else {
                        let beamDifference: CGFloat = beam1Array[i].notePos.y - beamPosY
                        var extraStemLength: CGFloat = 0
                        if beamCount == 2 {
                            extraStemLength = 0
                        } else if beamCount == 3 {
                            extraStemLength = 7
                        } else if beamCount == 4 {
                            extraStemLength = 0
                        }
                        
                        
                        let stem = UIBezierPath()
                        stem.lineWidth = 1.0
                        stem.move(to: CGPoint(x: beam1Array[i].notePos.x + 11.5, y: beam1Array[i].notePos.y + 4))
                        stem.addLine(to: CGPoint(x: beam1Array[i].notePos.x + 11.5, y: beam1Array[i].notePos.y - 2.5 - extraStemLength - beamDifference))
                        UIColor.black.setStroke()
                        stem.stroke()
                    }
                }
            }
            if beam1Array[0].noteStem == "up" {
                
                let stemChangeIndex: Int = Int(beamStemDirectionArray[0].state!)!
                let beamPosDiference: CGFloat = (beam1Array[stemChangeIndex].notePos.y + 10) - beamStemDirectionArray[0].notePos.y
                let beamPosY = beamStemDirectionArray[0].notePos.y + (beamPosDiference/2)
                
                
                let beam1 = UIBezierPath()
                beam1.lineWidth = 5.0
                beam1.move(to: CGPoint(x: beam1Array[0].notePos.x + 11.5, y: beamPosY))
                beam1.addLine(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 0.5, y: beamPosY))
                UIColor.black.setStroke()
                beam1.stroke()
                
                if beamCount == 2 {
                    let beam1 = UIBezierPath()
                    beam1.lineWidth = 5.0
                    beam1.move(to: CGPoint(x: beam1Array[0].notePos.x + 11.5, y: beamPosY + 7))
                    beam1.addLine(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 0.5, y: beamPosY + 7))
                    UIColor.black.setStroke()
                    beam1.stroke()
                } else if beamCount == 3 {
                    let beam1 = UIBezierPath()
                    beam1.lineWidth = 5.0
                    beam1.move(to: CGPoint(x: beam1Array[0].notePos.x + 11.5, y: beamPosY + 7))
                    beam1.addLine(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 0.5, y: beamPosY - 7))
                    UIColor.black.setStroke()
                    beam1.stroke()
                } else if beamCount == 4 {
                    let beam1 = UIBezierPath()
                    beam1.lineWidth = 5.0
                    beam1.move(to: CGPoint(x: beam1Array[0].notePos.x + 11.5, y: beamPosY + 7))
                    beam1.addLine(to: CGPoint(x: beam1Array[beam1Array.count - 1].notePos.x + 0.5, y: beamPosY + 14))
                    UIColor.black.setStroke()
                    beam1.stroke()
                }
                
                for i in 0...beam1Array.count - 1 {
                    
                    if i < beam1Array.count - beamStemDirectionArray.count {
                        let beamDifference: CGFloat = beam1Array[i].notePos.y - beamPosY
                        var extraStemLength: CGFloat = 0
                        if beamCount == 2 {
                            extraStemLength = 0
                        } else if beamCount == 3 {
                            extraStemLength = 7
                        } else if beamCount == 4 {
                            extraStemLength = 0
                        }
                        
                        let stem = UIBezierPath()
                        stem.lineWidth = 1.0
                        stem.move(to: CGPoint(x: beam1Array[i].notePos.x + 11.5, y: beam1Array[i].notePos.y + 4))
                        stem.addLine(to: CGPoint(x: beam1Array[i].notePos.x + 11.5, y: beam1Array[i].notePos.y - 2.5 - extraStemLength - beamDifference))
                        UIColor.black.setStroke()
                        stem.stroke()
                        
                    } else {
                        let beamDifference: CGFloat = beamPosY -  beam1Array[i].notePos.y
                        var extraStemLength: CGFloat = 0
                        if beamCount == 2 {
                            extraStemLength = 7
                        } else if beamCount == 3 {
                            extraStemLength = 14
                        } else if beamCount == 4 {
                            extraStemLength = 21
                        }
                        
                        
                        let stem = UIBezierPath()
                        stem.lineWidth = 1.0
                        stem.move(to: CGPoint(x: beam1Array[i].notePos.x + 0.5, y: beam1Array[i].notePos.y + 6))
                        stem.addLine(to: CGPoint(x: beam1Array[i].notePos.x + 0.5, y: beam1Array[i].notePos.y + 2.5 + extraStemLength + beamDifference))
                        UIColor.black.setStroke()
                        stem.stroke()
                    }
                }
            }
        }
    }
    
    
    func getBeam1SameStaff() {
        
        for i in 0...beam1Array.count - 1 {
            let thisNoteForBeam: beam = beam1Array[i]
            
            if i == 0 {
                noteStemDirection = ""
                noteStemDirection = thisNoteForBeam.noteStem!
                sameStemDirBeam = true
                beamStemDirectionArray.removeAll()
            } else {
                if thisNoteForBeam.noteStem! != noteStemDirection {
                    sameStemDirBeam = false
                    beamStemDirectionArray.append(beam(state: "\(Int(i - 1))", notePos: thisNote.notePos!, noteStem: thisNote.noteStem!))
                }
            }
        }
    }
    func getBeam1ShortestIndexUp() {
        
        for i in 0...beam1Array.count - 1 {
            let thisNoteForBeam: beam = beam1Array[i]
            
            if i == 0 {
                highestNoteYPosBeam1 = (thisNoteForBeam.notePos?.y)!
                highestNoteIndexBeam1 = Int(i)
            } else if i == beam1Array.count - 1 {
                if (thisNoteForBeam.notePos?.y)! < highestNoteYPosBeam1 {
                    highestNoteYPosBeam1 = (thisNoteForBeam.notePos?.y)!
                    highestNoteIndexBeam1 = Int(i)
                }
            } else {
                if (thisNoteForBeam.notePos?.y)! <= highestNoteYPosBeam1 {
                    highestNoteYPosBeam1 = (thisNoteForBeam.notePos?.y)!
                    highestNoteIndexBeam1 = Int(i)
                }
            }
        }
    }
    func getBeam1ShortestIndexDown() {
        
        for i in 0...beam1Array.count - 1 {
            let thisNoteForBeam: beam = beam1Array[i]
            
            if i == 0 {
                lowestNoteYPosBeam1 = (thisNoteForBeam.notePos?.y)!
                lowestNoteIndexBeam1 = Int(i)
            } else if i == beam1Array.count - 1 {
                if (thisNoteForBeam.notePos?.y)! > lowestNoteYPosBeam1 {
                    lowestNoteYPosBeam1 = (thisNoteForBeam.notePos?.y)!
                    lowestNoteIndexBeam1 = Int(i)
                }
            } else {
                if (thisNoteForBeam.notePos?.y)! >= lowestNoteYPosBeam1 {
                    lowestNoteYPosBeam1 = (thisNoteForBeam.notePos?.y)!
                    lowestNoteIndexBeam1 = Int(i)
                }
            }
        }
    }
    
    func drawStaffUpFlag() {
        let stem = UIBezierPath()
        stem.lineWidth = 1.0
        stem.move(to: CGPoint(x: thisNote.notePos.x + 11.5, y: thisNote.notePos.y + 4))
        stem.addLine(to: CGPoint(x: thisNote.notePos.x + 11.5, y: thisNote.notePos.y - 29))
        UIColor.black.setStroke()
        stem.stroke()
        
        if (thisNote.noteType == "eighth") || (thisNote.noteType == "16th") || (thisNote.noteType == "32nd") || (thisNote.noteType == "64th") {
            let eighthFlag = UIBezierPath()
            eighthFlag.lineWidth = 1.5
            eighthFlag.move(to: CGPoint(x: thisNote.notePos.x + 12 + 0, y: thisNote.notePos.y - 29))
            eighthFlag.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 12 + 6, y: thisNote.notePos.y - 9), controlPoint: CGPoint(x: thisNote.notePos.x + 12 + 0.5, y: thisNote.notePos.y - 19))
            eighthFlag.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 12 + 4, y: thisNote.notePos.y + 2), controlPoint: CGPoint(x: thisNote.notePos.x + 12 + 8, y: thisNote.notePos.y - 6))
            eighthFlag.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 12 + 6, y: thisNote.notePos.y - 9), controlPoint: CGPoint(x: thisNote.notePos.x + 12 + 8, y: thisNote.notePos.y - 6))
            eighthFlag.addLine(to: CGPoint(x: thisNote.notePos.x + 12 + 0, y: thisNote.notePos.y - 17))
            eighthFlag.addLine(to: CGPoint(x: thisNote.notePos.x + 12 + 0, y: thisNote.notePos.y - 29))
            UIColor.black.setStroke()
            eighthFlag.stroke()
            eighthFlag.fill()
            
            if (thisNote.noteType == "16th") || (thisNote.noteType == "32nd") || (thisNote.noteType == "64th") {
                //ADD ONE MORE FLAG
                let eighthFlag2 = UIBezierPath()
                eighthFlag2.lineWidth = 2.0
                eighthFlag2.move(to: CGPoint(x: thisNote.notePos.x + 12 + 0, y: thisNote.notePos.y - 30))
                eighthFlag2.addLine(to: CGPoint(x: thisNote.notePos.x + 12 + 0, y: thisNote.notePos.y - 27))
                eighthFlag2.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 12 + 6, y: thisNote.notePos.y - 17), controlPoint: CGPoint(x: thisNote.notePos.x + 12 + 2, y: thisNote.notePos.y - 23))
                eighthFlag2.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 12 + 6, y: thisNote.notePos.y - 10), controlPoint: CGPoint(x: thisNote.notePos.x + 12 + 8, y: thisNote.notePos.y - 13))
                UIColor.black.setStroke()
                eighthFlag2.stroke()
                
                if (thisNote.noteType == "32nd") || (thisNote.noteType == "64th") {
                    //ADD ONE MORE FLAG
                    let eighthFlag2 = UIBezierPath()
                    eighthFlag2.lineWidth = 2.0
                    eighthFlag2.move(to: CGPoint(x: thisNote.notePos.x + 12 + 0, y: thisNote.notePos.y - 29.5))
                    eighthFlag2.addLine(to: CGPoint(x: thisNote.notePos.x + 12 + 0, y: thisNote.notePos.y - 35.5))
                    eighthFlag2.addLine(to: CGPoint(x: thisNote.notePos.x + 12 + 0, y: thisNote.notePos.y - 33.5))
                    eighthFlag2.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 12 + 6, y: thisNote.notePos.y - 23.5), controlPoint: CGPoint(x: thisNote.notePos.x + 12 + 2, y: thisNote.notePos.y - 29.5))
                    eighthFlag2.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 12 + 6, y: thisNote.notePos.y - 16.5), controlPoint: CGPoint(x: thisNote.notePos.x + 12 + 8, y: thisNote.notePos.y - 19.5))
                    UIColor.black.setStroke()
                    eighthFlag2.stroke()
                    
                    if (thisNote.noteType == "64th") {
                        //ADD ONE MORE FLAG
                        let eighthFlag2 = UIBezierPath()
                        eighthFlag2.lineWidth = 2.0
                        eighthFlag2.move(to: CGPoint(x: thisNote.notePos.x + 12 + 0, y: thisNote.notePos.y - 34))
                        eighthFlag2.addLine(to: CGPoint(x: thisNote.notePos.x + 12 + 0, y: thisNote.notePos.y - 40))
                        eighthFlag2.addLine(to: CGPoint(x: thisNote.notePos.x + 12 + 0, y: thisNote.notePos.y - 37))
                        eighthFlag2.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 12 + 6, y: thisNote.notePos.y - 30), controlPoint: CGPoint(x: thisNote.notePos.x + 12 + 2, y: thisNote.notePos.y - 36))
                        eighthFlag2.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 12 + 6, y: thisNote.notePos.y - 23), controlPoint: CGPoint(x: thisNote.notePos.x + 12 + 8, y: thisNote.notePos.y - 26))
                        UIColor.black.setStroke()
                        eighthFlag2.stroke()
                    }
                }
            }
        }
    }
    func drawStaffUpPlain() {
        let stem = UIBezierPath()
        stem.lineWidth = 1.0
        stem.move(to: CGPoint(x: thisNote.notePos.x + 11.5, y: thisNote.notePos.y + 4))
        stem.addLine(to: CGPoint(x: thisNote.notePos.x + 11.5, y: thisNote.notePos.y - thisNote.noteStemLength + 7))
        UIColor.black.setStroke()
        stem.stroke()
    }
    func drawStaffUpLeftPlain() {
        let stem = UIBezierPath()
        stem.lineWidth = 1.0
        stem.move(to: CGPoint(x: thisNote.notePos.x - 0.5, y: thisNote.notePos.y + 8))
        stem.addLine(to: CGPoint(x: thisNote.notePos.x - 0.5, y: thisNote.notePos.y - thisNote.noteStemLength + 7))
        UIColor.black.setStroke()
        stem.stroke()
    }
    func drawStaffDownFlag() {
        let stem = UIBezierPath()
        stem.lineWidth = 1.0
        stem.move(to: CGPoint(x: thisNote.notePos.x + 0.5, y: thisNote.notePos.y + 6))
        stem.addLine(to: CGPoint(x: thisNote.notePos.x + 0.5, y: thisNote.notePos.y + 36))
        UIColor.black.setStroke()
        stem.stroke()
        
        if (thisNote.noteType == "eighth") {
            let eighthFlag = UIBezierPath()
            eighthFlag.lineWidth = 1.5
            eighthFlag.move(to: CGPoint(x: thisNote.notePos.x + 1 + 0, y: thisNote.notePos.y + 36))
            eighthFlag.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 1 + 8, y: thisNote.notePos.y + 16), controlPoint: CGPoint(x: thisNote.notePos.x + 1 + 2.5, y: thisNote.notePos.y + 26))
            eighthFlag.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 1 + 6, y: thisNote.notePos.y + 5), controlPoint: CGPoint(x: thisNote.notePos.x + 1 + 10, y: thisNote.notePos.y + 13))
            eighthFlag.addQuadCurve(to: CGPoint(x: thisNote.notePos.x + 1 + 8, y: thisNote.notePos.y + 16), controlPoint: CGPoint(x: thisNote.notePos.x + 1 + 10, y: thisNote.notePos.y + 13))
            eighthFlag.addLine(to: CGPoint(x: thisNote.notePos.x + 1 + 0, y: thisNote.notePos.y + 27))
            eighthFlag.addLine(to: CGPoint(x: thisNote.notePos.x + 1 + 0, y: thisNote.notePos.y + 36))
            UIColor.black.setStroke()
            eighthFlag.stroke()
            eighthFlag.fill()
        } else if (thisNote.noteType == "16th") {
            
        } else if (thisNote.noteType == "32nd") {
            
        } else if (thisNote.noteType == "64th") {
            
        }
    }
    func drawStaffDownPlain() {
        let stem = UIBezierPath()
        stem.lineWidth = 1.0
        stem.move(to: CGPoint(x: thisNote.notePos.x + 0.5, y: thisNote.notePos.y + 6))
        stem.addLine(to: CGPoint(x: thisNote.notePos.x + 0.5, y: thisNote.notePos.y + thisNote.noteStemLength))
        UIColor.black.setStroke()
        stem.stroke()
    }
    func drawStaffDownRightPlain() {
        let stem = UIBezierPath()
        stem.lineWidth = 1.0
        stem.move(to: CGPoint(x: thisNote.notePos.x + 12.0, y: thisNote.notePos.y + 4))
        stem.addLine(to: CGPoint(x: thisNote.notePos.x + 12.0, y: thisNote.notePos.y + thisNote.noteStemLength))
        UIColor.black.setStroke()
        stem.stroke()
    }
    
}
