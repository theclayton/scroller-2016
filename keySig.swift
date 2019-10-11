//
//  keySig.swift
//  Scroller
//
//  Created by Clayton Ward on 8/9/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit

class keySig: UIView {
    
    var keySigWidth: CGFloat!
    var averageStaffDistance: CGFloat!
    
    var clef1: String!
    var clef2: String!
    var fifths: Int!
    
    
    var topStaffOffset: CGFloat!
    var bottomStaffOffset: CGFloat!
    
    var PosX: CGFloat!
    var PosY: CGFloat!
    var PosY2: CGFloat!
    
    
    override func draw(_ rect: CGRect) {
        
        topStaffOffset = self.bounds.height/2 - averageStaffDistance/2 - 45.0
        bottomStaffOffset = self.bounds.height/2 + averageStaffDistance/2
        
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
         
         FLATS
         b
         
         SHARPS
         #
         
         */
        
        //TOP STAFF
        
        let lineWidth: CGFloat = 1.0
        let topStaff = UIBezierPath()
        topStaff.lineWidth = lineWidth
        
        topStaff.move(to: CGPoint(x: 0, y: self.bounds.height/2 - averageStaffDistance/2 - 40.5))
        topStaff.addLine(to: CGPoint(x: keySigWidth, y: self.bounds.height/2 - averageStaffDistance/2 - 40.5))
        
        topStaff.move(to: CGPoint(x: 0, y: self.bounds.height/2 - averageStaffDistance/2 - 30.5))
        topStaff.addLine(to: CGPoint(x: keySigWidth, y: self.bounds.height/2 - averageStaffDistance/2 - 30.5))
        
        topStaff.move(to: CGPoint(x: 0, y: self.bounds.height/2 - averageStaffDistance/2 - 20.5))
        topStaff.addLine(to: CGPoint(x: keySigWidth, y: self.bounds.height/2 - averageStaffDistance/2 - 20.5))
        
        topStaff.move(to: CGPoint(x: 0, y: self.bounds.height/2 - averageStaffDistance/2 - 10.5))
        topStaff.addLine(to: CGPoint(x: keySigWidth, y: self.bounds.height/2 - averageStaffDistance/2 - 10.5))
        
        topStaff.move(to: CGPoint(x: 0, y: self.bounds.height/2 - averageStaffDistance/2 - 0.5))
        topStaff.addLine(to: CGPoint(x: keySigWidth, y: self.bounds.height/2 - averageStaffDistance/2 - 0.5))
        
        UIColor.black.setStroke()
        topStaff.stroke()
        
        
        //Bottom STAFF
        
        //let lineWidth: CGFloat = 1.0
        let bottomStaff = UIBezierPath()
        bottomStaff.lineWidth = lineWidth
        
        bottomStaff.move(to: CGPoint(x: 0, y: self.bounds.height/2 + averageStaffDistance/2 + 0.5))
        bottomStaff.addLine(to: CGPoint(x: keySigWidth, y: self.bounds.height/2 + averageStaffDistance/2 + 0.5))
        
        bottomStaff.move(to: CGPoint(x: 0, y: self.bounds.height/2 + averageStaffDistance/2 + 10.5))
        bottomStaff.addLine(to: CGPoint(x: keySigWidth, y: self.bounds.height/2 + averageStaffDistance/2 + 10.5))
        
        bottomStaff.move(to: CGPoint(x: 0, y: self.bounds.height/2 + averageStaffDistance/2 + 20.5))
        bottomStaff.addLine(to: CGPoint(x: keySigWidth, y: self.bounds.height/2 + averageStaffDistance/2 + 20.5))
        
        bottomStaff.move(to: CGPoint(x: 0, y: self.bounds.height/2 + averageStaffDistance/2 + 30.5))
        bottomStaff.addLine(to: CGPoint(x: keySigWidth, y: self.bounds.height/2 + averageStaffDistance/2 + 30.5))
        
        bottomStaff.move(to: CGPoint(x: 0, y: self.bounds.height/2 + averageStaffDistance/2 + 40.5))
        bottomStaff.addLine(to: CGPoint(x: keySigWidth, y: self.bounds.height/2 + averageStaffDistance/2 + 40.5))
        
        UIColor.black.setStroke()
        bottomStaff.stroke()
        
        
        
        
        
        
        if fifths == 0 {
            
        } else if fifths == 1 {
            PosX = 34.0
            PosY = -9.0
            PosY2 = -3.0
            drawSharp()
        } else if fifths == 2 {
            for i in 1...2 {
                if i == 1 {
                    PosX = 34.0
                    PosY = -9.0
                    PosY2 = -3.0
                } else if i == 2 {
                    PosX = 44.0
                    PosY = 5.0
                    PosY2 = 11.0
                }
                drawSharp()
            }
        } else if fifths == 3 {
            for i in 1...3 {
                if i == 1 {
                    PosX = 34.0
                    PosY = -9.0
                    PosY2 = -3.0
                } else if i == 2 {
                    PosX = 44.0
                    PosY = 5.0
                    PosY2 = 11.0
                } else if i == 3 {
                    PosX = 54.0
                    PosY = -15.0
                    PosY2 = -9.0
                }
                drawSharp()
            }
        } else if fifths == 4 {
            for i in 1...4 {
                if i == 1 {
                    PosX = 34.0
                    PosY = -9.0
                    PosY2 = -3.0
                } else if i == 2 {
                    PosX = 44.0
                    PosY = 5.0
                    PosY2 = 11.0
                } else if i == 3 {
                    PosX = 54.0
                    PosY = -15.0
                    PosY2 = -9.0
                } else if i == 4 {
                    PosX = 64.0
                    PosY = 1.0
                    PosY2 = 7.0
                }
                drawSharp()
            }
        } else if fifths == 5 {
            for i in 1...5 {
                if i == 1 {
                    PosX = 34.0
                    PosY = -9.0
                    PosY2 = -3.0
                } else if i == 2 {
                    PosX = 44.0
                    PosY = 5.0
                    PosY2 = 11.0
                } else if i == 3 {
                    PosX = 54.0
                    PosY = -15.0
                    PosY2 = -9.0
                } else if i == 4 {
                    PosX = 64.0
                    PosY = 1.0
                    PosY2 = 7.0
                } else if i == 5 {
                    PosX = 74.0
                    PosY = 18.0
                    PosY2 = 24.0
                }
                drawSharp()
            }
        } else if fifths == 6 {
            for i in 1...6 {
                if i == 1 {
                    PosX = 34.0
                    PosY = -9.0
                    PosY2 = -3.0
                } else if i == 2 {
                    PosX = 44.0
                    PosY = 5.0
                    PosY2 = 11.0
                } else if i == 3 {
                    PosX = 54.0
                    PosY = -15.0
                    PosY2 = -9.0
                } else if i == 4 {
                    PosX = 64.0
                    PosY = 1.0
                    PosY2 = 7.0
                } else if i == 5 {
                    PosX = 74.0
                    PosY = 18.0
                    PosY2 = 24.0
                } else if i == 6 {
                    PosX = 84.0
                    PosY = -3.0
                    PosY2 = 6.0
                }
                drawSharp()
            }
        } else if fifths == 7 {
            for i in 1...7 {
                if i == 1 {
                    PosX = 34.0
                    PosY = -9.0
                    PosY2 = -3.0
                } else if i == 2 {
                    PosX = 44.0
                    PosY = 5.0
                    PosY2 = 11.0
                } else if i == 3 {
                    PosX = 54.0
                    PosY = -15.0
                    PosY2 = -9.0
                } else if i == 4 {
                    PosX = 64.0
                    PosY = 1.0
                    PosY2 = 7.0
                } else if i == 5 {
                    PosX = 74.0
                    PosY = 18.0
                    PosY2 = 24.0
                } else if i == 6 {
                    PosX = 84.0
                    PosY = -3.0
                    PosY2 = 6.0
                } else if i == 7 {
                    PosX = 94.0
                    PosY = 11.0
                    PosY2 = 17.0
                }
                drawSharp()
            }
        }
        
        
        if fifths == -1 {
            PosX = 34.0
            PosY = 8.0
            PosY2 = 14.0
            
            drawFlat()
        } else if fifths == -2 {
            for i in 1...2 {
                if i == 1 {
                    PosX = 34.0
                    PosY = 8.0
                    PosY2 = 14.0
                } else if i == 2 {
                    PosX = 42.0
                    PosY = -8.0
                    PosY2 = -2.0
                }
                drawFlat()
            }
        } else if fifths == -3 {
            for i in 1...3 {
                if i == 1 {
                    PosX = 34.0
                    PosY = 8.0
                    PosY2 = 14.0
                } else if i == 2 {
                    PosX = 42.0
                    PosY = -8.0
                    PosY2 = -2.0
                } else if i == 3 {
                    PosX = 50.0
                    PosY = 12.0
                    PosY2 = 18.0
                }
                drawFlat()
            }
        } else if fifths == -4 {
            for i in 1...4 {
                if i == 1 {
                    PosX = 34.0
                    PosY = 8.0
                    PosY2 = 14.0
                } else if i == 2 {
                    PosX = 42.0
                    PosY = -8.0
                    PosY2 = -2.0
                } else if i == 3 {
                    PosX = 50.0
                    PosY = 12.0
                    PosY2 = 18.0
                } else if i == 4 {
                    PosX = 58.0
                    PosY = -2.0
                    PosY2 = 4.0
                }
                drawFlat()
            }
        } else if fifths == -5 {
            for i in 1...5 {
                if i == 1 {
                    PosX = 34.0
                    PosY = 8.0
                    PosY2 = 14.0
                } else if i == 2 {
                    PosX = 42.0
                    PosY = -8.0
                    PosY2 = -2.0
                } else if i == 3 {
                    PosX = 50.0
                    PosY = 12.0
                    PosY2 = 18.0
                } else if i == 4 {
                    PosX = 58.0
                    PosY = -2.0
                    PosY2 = 4.0
                } else if i == 5 {
                    PosX = 66.0
                    PosY = 18.0
                    PosY2 = 24.0
                }
                drawFlat()
            }
        } else if fifths == -6 {
            for i in 1...6 {
                if i == 1 {
                    PosX = 34.0
                    PosY = 8.0
                    PosY2 = 14.0
                } else if i == 2 {
                    PosX = 42.0
                    PosY = -8.0
                    PosY2 = -2.0
                } else if i == 3 {
                    PosX = 50.0
                    PosY = 12.0
                    PosY2 = 18.0
                } else if i == 4 {
                    PosX = 58.0
                    PosY = -2.0
                    PosY2 = 4.0
                } else if i == 5 {
                    PosX = 66.0
                    PosY = 18.0
                    PosY2 = 24.0
                } else if i == 6 {
                    PosX = 74.0
                    PosY = 2.0
                    PosY2 = 8.0
                }
                drawFlat()
            }
        } else if fifths == -7 {
            for i in 1...7 {
                if i == 1 {
                    PosX = 34.0
                    PosY = 8.0
                    PosY2 = 14.0
                } else if i == 2 {
                    PosX = 42.0
                    PosY = -8.0
                    PosY2 = -2.0
                } else if i == 3 {
                    PosX = 50.0
                    PosY = 12.0
                    PosY2 = 18.0
                } else if i == 4 {
                    PosX = 58.0
                    PosY = -2.0
                    PosY2 = 4.0
                } else if i == 5 {
                    PosX = 66.0
                    PosY = 18.0
                    PosY2 = 24.0
                } else if i == 6 {
                    PosX = 74.0
                    PosY = 2.0
                    PosY2 = 8.0
                } else if i == 7 {
                    PosX = 82.0
                    PosY = 22.0
                    PosY2 = 28.0
                }
                drawFlat()
            }
        }
    }
    func drawFlat() {
        // b TOP STAFF
        let flatLine = UIBezierPath()
        flatLine.lineWidth = 1.25
        
        flatLine.move(to: CGPoint(x: PosX, y: topStaffOffset + PosY + 0))
        flatLine.addLine(to: CGPoint(x: PosX, y: topStaffOffset + PosY + 22))
        UIColor.black.setStroke()
        flatLine.stroke()
        
        let flat = UIBezierPath()
        flat.lineWidth = 1.75
        flat.move(to: CGPoint(x: PosX, y: topStaffOffset + PosY + 22))
        flat.addQuadCurve(to: CGPoint(x: PosX, y: topStaffOffset + PosY + 15), controlPoint: CGPoint(x: PosX + 13, y: topStaffOffset + PosY + 11))
        UIColor.black.setStroke()
        flat.stroke()
        
        // b BOTTOM STAFF
        let flatLine2 = UIBezierPath()
        flatLine2.lineWidth = 1.25
        
        flatLine2.move(to: CGPoint(x: PosX, y: bottomStaffOffset + PosY2 + 0))
        flatLine2.addLine(to: CGPoint(x: PosX, y: bottomStaffOffset + PosY2 + 22))
        UIColor.black.setStroke()
        flatLine2.stroke()
        
        let flat2 = UIBezierPath()
        flat2.lineWidth = 1.75
        flat2.move(to: CGPoint(x: PosX, y: bottomStaffOffset + PosY2 + 22))
        flat2.addQuadCurve(to: CGPoint(x: PosX, y: bottomStaffOffset + PosY2 + 15), controlPoint: CGPoint(x: PosX + 13, y: bottomStaffOffset + PosY2 + 11))
        UIColor.black.setStroke()
        flat2.stroke()
    }
    func drawSharp() {
        // # TOP STAFF
        let sharpLine1 = UIBezierPath()
        sharpLine1.lineWidth = 1.25
        sharpLine1.move(to: CGPoint(x: PosX + 3, y: topStaffOffset + PosY + 1.5))
        sharpLine1.addLine(to: CGPoint(x: PosX + 3, y: topStaffOffset + PosY + 27.5))
        UIColor.black.setStroke()
        sharpLine1.stroke()
        
        let sharpLine2 = UIBezierPath()
        sharpLine2.lineWidth = 3.5
        sharpLine2.move(to: CGPoint(x: PosX, y: topStaffOffset + PosY + 10.5))
        sharpLine2.addLine(to: CGPoint(x: PosX + 10, y: topStaffOffset + PosY + 7.5))
        UIColor.black.setStroke()
        sharpLine2.stroke()
        
        let sharpLine3 = UIBezierPath()
        sharpLine3.lineWidth = 1.25
        sharpLine3.move(to: CGPoint(x: PosX + 7, y: topStaffOffset + PosY + 0))
        sharpLine3.addLine(to: CGPoint(x: PosX + 7, y: topStaffOffset + PosY + 26))
        UIColor.black.setStroke()
        sharpLine3.stroke()
        
        let sharpLine4 = UIBezierPath()
        sharpLine4.lineWidth = 3.5
        sharpLine4.move(to: CGPoint(x: PosX, y: topStaffOffset + PosY + 20))
        sharpLine4.addLine(to: CGPoint(x: PosX + 10, y: topStaffOffset + PosY + 17))
        UIColor.black.setStroke()
        sharpLine4.stroke()
        
        // # BOTTOM STAFF
        let BsharpLine1 = UIBezierPath()
        BsharpLine1.lineWidth = 1.25
        BsharpLine1.move(to: CGPoint(x: PosX + 3, y: bottomStaffOffset + PosY2 + 1.5))
        BsharpLine1.addLine(to: CGPoint(x: PosX + 3, y: bottomStaffOffset + PosY2 + 27.5))
        UIColor.black.setStroke()
        BsharpLine1.stroke()
        
        let BsharpLine2 = UIBezierPath()
        BsharpLine2.lineWidth = 3.5
        BsharpLine2.move(to: CGPoint(x: PosX, y: bottomStaffOffset + PosY2 + 10.5))
        BsharpLine2.addLine(to: CGPoint(x: PosX + 10, y: bottomStaffOffset + PosY2 + 7.5))
        UIColor.black.setStroke()
        BsharpLine2.stroke()
        
        let BsharpLine3 = UIBezierPath()
        BsharpLine3.lineWidth = 1.25
        BsharpLine3.move(to: CGPoint(x: PosX + 7, y: bottomStaffOffset + PosY2 + 0))
        BsharpLine3.addLine(to: CGPoint(x: PosX + 7, y: bottomStaffOffset + PosY2 + 26))
        UIColor.black.setStroke()
        BsharpLine3.stroke()
        
        let BsharpLine4 = UIBezierPath()
        BsharpLine4.lineWidth = 3.5
        BsharpLine4.move(to: CGPoint(x: PosX, y: bottomStaffOffset + PosY2 + 20))
        BsharpLine4.addLine(to: CGPoint(x: PosX + 10, y: bottomStaffOffset + PosY2 + 17))
        UIColor.black.setStroke()
        BsharpLine4.stroke()
    }
}
