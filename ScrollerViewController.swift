//
//  ScrollerViewController.swift
//  Scroller
//
//  Created by Clayton Ward on 7/23/16.
//  Copyright © 2016 Flare Software. All rights reserved.
//

import UIKit
import AVFoundation

class ScrollerViewController: UIViewController, UIScrollViewDelegate, XMLParserDelegate {
    
    var scrollerTitle: String = ""
    var scrollerFile: String = ""
    var isPresented = true
    
    let savedCountdown = UserDefaults.standard.integer(forKey: "savedCountdown")
    let showNoteHighlighter = UserDefaults.standard.bool(forKey: "showNoteHighlighter")
    
    //MARK: UI Outlets
    @IBOutlet weak var ScrollerScrollView: UIScrollView!
    @IBOutlet weak var scrollerScrollViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollerScrollViewRIghtConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollerScrollViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollerScrollViewBottomConstraint: NSLayoutConstraint!
    
    let ScrollerScrollTap = UITapGestureRecognizer()
    var scrollerTimer = Timer()
    var firstMeasureOffset: CGFloat = 0.0
    
    @IBOutlet weak var noteGuiderView: drawNoteGuiderView! = drawNoteGuiderView()
    @IBOutlet weak var noteGuiderMeasureNumberLabel: UILabel!
    @IBOutlet weak var noteGuiderTopConstraint: NSLayoutConstraint!
    var noteGuiderIsVisible: Bool = false
    
    //KeySig
    @IBOutlet weak var keySigView: UIView!
    var keySigViewWidth: CGFloat!
    let keySigTap = UITapGestureRecognizer()
    let keySigSwipeRight = UISwipeGestureRecognizer()
    let keySigSwipeLeft = UISwipeGestureRecognizer()
    @IBOutlet weak var keySigWidthContraint: NSLayoutConstraint!
    @IBOutlet weak var keySigTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var keysigBottomConstraint: NSLayoutConstraint!
    
    //Control Panel
    @IBOutlet weak var controlPanalView: UIView!
    @IBOutlet weak var controlPanelLeftConstraint: NSLayoutConstraint!
    var ControlPanelIsOpen: Bool = false
    
    //Nav Header View
    @IBOutlet weak var navHeaderView: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var songTitleLabel: UILabel!
    
    //Toolbar
    @IBOutlet weak var toolbarView: UIView!
    @IBOutlet weak var toolbarSegmentController: UISegmentedControl!
    
    //Metronome View
    @IBOutlet weak var metronomeView: UIView!
    @IBOutlet weak var metronomeSlider: UISlider!
    @IBOutlet weak var metronomeStepper: UIStepper!
    @IBOutlet weak var tempoMetronomeLabel: UILabel!
    @IBOutlet weak var BPMLabel: UILabel!
    @IBOutlet weak var fullTempoLabel: UILabel!
    var fullBeatsPerMinute: Float = 120.0
    var beatsPerMinute: Float = 120.0 // 120 is default

    @IBOutlet weak var playbackButton: UIButton!
    
    //Settings View
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var showNoteGuiderHighlightSwitch: UISwitch!
    
    //El Maestro
    @IBOutlet weak var elMaestroView: UIView!
    @IBOutlet weak var showMaestroButton: UIButton!
    @IBOutlet weak var elMeastroHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var elMeastroBottomConstraint: NSLayoutConstraint!
    let elMaestroTap = UITapGestureRecognizer()
    let elMaestroSwipeDown = UISwipeGestureRecognizer()
    var elMaestroIsVisible: Bool = false
    
    @IBOutlet weak var nextNoteButton: UIButton!
    @IBOutlet weak var nextNoteButtonRightConstraint: NSLayoutConstraint!
    
    //Countdown
    @IBOutlet weak var countdDownView: UIView!
    @IBOutlet weak var countdownViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var countdownStepper: UIStepper!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var countdownLabelBIG: UILabel!
    var countdownNumber: Int!
    var countdownTimer = Timer()
    
    //Other
    @IBOutlet weak var loadingView: UIView!
    
    var currentMeasureInt: Int = 45
    var scrollingPoint: CGPoint?
    
    var noteGuiderIsHighlighted: Bool = true
    var isCountingDown: Bool = false
    var countdownNumberTiming: Int = 0
    var isPlayingBack: Bool = false
    
    @IBAction func menuButtonPressed(_ sender: AnyObject) {
        goHome()
    }
    
    func goHome() {
        self.dismiss(animated: true, completion: {});
        isPresented = false
    }
    
    struct constants {
        static let controlPanalWidth: CGFloat = 200
        
        static let newSystemCut: CGFloat = 30
        static let maxTempoFloat: Float = 230
        static let minTempoFloat: Float = 20
        static let maxTempoDouble: Double = 230
        static let minTempoDouble: Double = 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.orientation.isPortrait {
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        
        settingsView.isHidden = true
        noteGuiderView.alpha = 0.0
        noteGuiderView.isHidden = true
        countdownLabelBIG.isHidden = true
        playbackButton.isEnabled = false
        playbackButton.alpha = 0.0
        showMaestroButton.isEnabled = false
        showMaestroButton.alpha = 0.0
        nextNoteButton.isHidden = true
        countdDownView.isHidden = true
        
        //loadingView
        loadingView.isHidden = false
        loadingView.layer.cornerRadius = 5
        loadingView.layer.shadowColor = UIColor.black.cgColor
        loadingView.layer.shadowOpacity = 0.5
        loadingView.layer.shadowOffset = CGSize.zero
        loadingView.layer.shadowRadius = 5
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        songTitleLabel.text = scrollerTitle
        setupView()
        setupMetronome()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        invalidateTimers()
    }
    func invalidateTimers() {
        scrollerTimer.invalidate()
        countdownTimer.invalidate()
    }
    func setupView() {
        toolbarSegmentController.selectedSegmentIndex = UISegmentedControlNoSegment
        
        //GESTURE RECOGNITION
        //keysig
        keySigTap.addTarget(self, action: #selector(ScrollerViewController.keySigPressed(_:)))
        keySigView.addGestureRecognizer(keySigTap)
        
        keySigSwipeLeft.addTarget(self, action: #selector(ScrollerViewController.keySigPressed(_:)))
        keySigSwipeLeft.direction = UISwipeGestureRecognizerDirection.left
        keySigView.addGestureRecognizer(keySigSwipeLeft)
        
        keySigSwipeRight.addTarget(self, action: #selector(ScrollerViewController.keySigPressed(_:)))
        keySigSwipeRight.direction = UISwipeGestureRecognizerDirection.right
        keySigView.addGestureRecognizer(keySigSwipeRight)
        keySigView.isUserInteractionEnabled = true
        
        //ScrollView
        ScrollerScrollTap.addTarget(self, action: #selector(ScrollerViewController.scrollerScrollTapped(_:)))
        ScrollerScrollView.addGestureRecognizer(ScrollerScrollTap)
        ScrollerScrollView.isUserInteractionEnabled = true
        
        //pianoView
        elMaestroTap.addTarget(self, action: #selector(ScrollerViewController.elMaestroViewTapped(_:)))
        elMaestroView.addGestureRecognizer(elMaestroTap)
        
        elMaestroSwipeDown.addTarget(self, action: #selector(ScrollerViewController.elMaestroViewDwipedDown(_:)))
        elMaestroSwipeDown.direction = UISwipeGestureRecognizerDirection.down
        elMaestroView.addGestureRecognizer(elMaestroSwipeDown)
        elMaestroView.isUserInteractionEnabled = true
        
        //OTHER SETUP
        elMaestroView.isHidden = true
        controlPanalView.isHidden = true
        toolbarSegmentController.selectedSegmentIndex = 0
        
        countdDownView.layer.cornerRadius = 8
        nextNoteButton.layer.cornerRadius = 8
        
        //LOADED STUFF
        countdownNumber = savedCountdown
        countdownLabel.text = "\(countdownNumber!)"
        countdownStepper.value = Double(countdownNumber)
        
        //PARSER
        beginParsing()
    }
    
    func showLoading() {
        loadingView.alpha = 0.0
        loadingView.isHidden = false
        
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
            
            self.loadingView.alpha = 1.0
            
        }, completion: { finished in
        })
    }
    func hideLoading() {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
            
            self.loadingView.alpha = 0.0
            
        }, completion: { finished in
            self.loadingView.isHidden = true
        })
    }
    
    func keySigPressed(_ sender: UISwipeGestureRecognizer) {
        if ControlPanelIsOpen {
            CloseControlPanal(0.25, isSetup: false)
        } else {
            openControlPanal(0.25, isSetup: false)
        }
    }
    func openControlPanal(_ duration: Double, isSetup: Bool) {
        ControlPanelIsOpen = true
        
        controlPanalView.isHidden = false
        keySigView.isUserInteractionEnabled = false
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {
            
            self.controlPanalView.center = CGPoint(x: constants.controlPanalWidth/2, y: self.controlPanalView.frame.height/2)
            self.controlPanelLeftConstraint.constant = 0
            
            if self.elMaestroIsVisible == true {
                let distanceFromStaffToTop: CGFloat = self.view.bounds.height/2 - self.averageStaffDistance/2 - 55
                let distanceToMove: CGFloat = distanceFromStaffToTop/4
                self.keySigView.center = CGPoint(x: constants.controlPanalWidth + self.keySigViewWidth!/2, y: self.controlPanalView.frame.height/2 - distanceToMove)
            } else {
                self.keySigView.center = CGPoint(x: constants.controlPanalWidth + self.keySigViewWidth!/2, y: self.controlPanalView.frame.height/2)
            }
        }, completion: { finished in
            self.keySigView.isUserInteractionEnabled = true
            if isSetup {
                self.maestroFindCurrentNote()
            }
        })
    }
    func CloseControlPanal(_ duration: Double, isSetup: Bool) {
        ControlPanelIsOpen = false
        keySigView.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {
            
            self.controlPanalView.center = CGPoint(x: -constants.controlPanalWidth/2, y: self.controlPanalView.frame.height/2)
            self.controlPanelLeftConstraint.constant = -constants.controlPanalWidth
            
            if self.elMaestroIsVisible == true {
                let distanceFromStaffToTop: CGFloat = self.view.bounds.height/2 - self.averageStaffDistance/2 - 55
                let distanceToMove: CGFloat = distanceFromStaffToTop/4
                self.keySigView.center = CGPoint(x: self.keySigViewWidth!/2, y: self.controlPanalView.frame.height/2 - distanceToMove)
            } else {
                self.keySigView.center = CGPoint(x: self.keySigViewWidth!/2, y: self.controlPanalView.frame.height/2)
            }
            if isSetup {
                self.ScrollerScrollView.frame = CGRect(x: self.keySigViewWidth!, y: 0, width: self.view.frame.width - self.keySigViewWidth!, height: self.view.bounds.height)
                self.scrollerScrollViewLeftConstraint.constant = self.keySigViewWidth!
            }
        }, completion: { finished in
            self.keySigView.isUserInteractionEnabled = true
            self.controlPanalView.isHidden = true
            
            if isSetup {
                self.countdownShowIsh()
                self.maestroFindCurrentNote()
            }
        })
    }
    
    func showPlaybackButton(_ duration: Double) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {
            
            self.playbackButton.alpha = 1.0
            
        }, completion: { finished in
            self.playbackButton.isEnabled = true
        })
    }
    func showMaestroButton(_ duration: Double) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {
            
            self.showMaestroButton.alpha = 1.0
            
        }, completion: { finished in
            self.showMaestroButton.isEnabled = true
        })
    }
    @IBAction func toolbarSegmentChanged(_ sender: UISegmentedControl) {
        switch toolbarSegmentController.selectedSegmentIndex {
        case 0:
            hideToolBarViews()
            metronomeView.isHidden = false
        case 1:
            hideToolBarViews()
            settingsView.isHidden = false
        default:
            break
        }
    }
    func hideToolBarViews() {
        metronomeView.isHidden = true
        settingsView.isHidden = true
    }
    
    func showNoteGuider(_ duration: Double) {
        noteGuiderView.isHidden = false
        noteGuiderView.alpha = 0.0
        UIView.animate(withDuration: duration, delay: 1.0, options: .curveEaseIn, animations: {
            self.noteGuiderView.alpha = 1.0
        }, completion: { finished in
            if self.showNoteHighlighter == true {
                self.showNoteGuiderHighlightSwitch.isOn = true
                self.noteGuiderIsHighlighted = true
                self.showNoteGuiderHighlight()
            } else {
                self.showNoteGuiderHighlightSwitch.isOn = false
                self.noteGuiderIsHighlighted = false
                self.hideNoteGuiderHighlight()
            }
        })
    }
    @IBAction func noteGuiderHighlightSwitched(_ sender: AnyObject) {
        noteGuiderHighlightChange()
    }
    func noteGuiderHighlightChange() {
        if noteGuiderIsHighlighted {
            noteGuiderIsHighlighted = false
            UserDefaults.standard.set(false, forKey: "showNoteHighlighter")
            hideNoteGuiderHighlight()
            showNoteGuiderHighlightSwitch.isOn = false
        } else {
            noteGuiderIsHighlighted = true
            UserDefaults.standard.set(true, forKey: "showNoteHighlighter")
            showNoteGuiderHighlight()
            showNoteGuiderHighlightSwitch.isOn = true
        }
    }
    func showNoteGuiderHighlight() {
        noteGuiderView.noteGuiderIsHighlighted = true
        noteGuiderView.setNeedsDisplay()
    }
    func hideNoteGuiderHighlight() {
        noteGuiderView.noteGuiderIsHighlighted = false
        noteGuiderView.setNeedsDisplay()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isCountingDown {
            stopCountdown()
        }
        scrollingPoint = ScrollerScrollView.contentOffset
        findCurrentMeasure()
        isEndOfSong = false
    }
    func findCurrentMeasure() {
        var currentPos: Float = 0
        var totalWidth: Float = Float(firstMeasureOffset)
        
        currentPos = Float(scrollingPoint!.x) + (Float(noteGuiderView.center.x) - Float(keySigView.bounds.width))
        
        for i in 0..<measureWidthArray.count  {
            let measureWidthAtIndex = measureWidthArray[i]
            totalWidth += measureWidthAtIndex
            if currentPos < totalWidth && currentPos > (totalWidth - measureWidthAtIndex) {
                currentMeasureInt = Int(i+1)
                noteGuiderMeasureNumberLabel.text = "\(currentMeasureInt)"
            }
        }
    }
    func scrollerScrollTapped(_ sender: UITapGestureRecognizer) {
        if isScrolling {
            stopScroller()
            if ControlPanelIsOpen == false {
                countdownShowIsh()
            }
        } else {
            if isCountingDown {
                stopCountdown()
            } else {
                startCountdown()
            }
        }
    }
    func startCountdown() {
        if isEndOfSong == false {
            
            isCountingDown = true
            countdownNumberTiming = countdownNumber
            if countdownNumber <= 0 {
                startScroller()
                stopCountdown()
            } else {
                countdownLabelBIG.text = "\(countdownNumberTiming)"
                countdownLabelBIG.isHidden = false
                countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ScrollerViewController.countdownTick), userInfo: nil, repeats: true)
            }
            countdownHideIsh()
        } else {
            countdownShowIsh()
        }
    }
    func countdownTick() {
        countdownNumberTiming -= 1
        countdownLabelBIG.text = "\(countdownNumberTiming)"
        if countdownNumberTiming <= 0 {
            startScroller()
            stopCountdown()
        }
    }
    func stopCountdown() {
        isCountingDown = false
        countdownLabelBIG.isHidden = true
        countdownTimer.invalidate()
        if isScrolling == false && ControlPanelIsOpen == false {
            countdownShowIsh()
        }
    }
    func countdownHideIsh() {
        ScrollerScrollView.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
            
            self.nextNoteButton.center = CGPoint(x: self.view.bounds.width + self.nextNoteButton.bounds.width/2, y: self.nextNoteButton.center.y)
            self.nextNoteButtonRightConstraint.constant = -self.nextNoteButton.bounds.width
            
            self.countdDownView.center = CGPoint(x: self.view.bounds.width + self.countdDownView.bounds.width/2, y: self.countdDownView.center.y)
            self.countdownViewRightConstraint.constant = -self.countdDownView.bounds.width
            
        }, completion: { finished in
            self.ScrollerScrollView.isUserInteractionEnabled = true
        })
    }
    func countdownShowIsh() {
        countdDownView.isHidden = false
        nextNoteButton.isHidden = false
        ScrollerScrollView.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
            
            self.nextNoteButton.center = CGPoint(x: self.view.bounds.width - self.nextNoteButton.bounds.width/2 - 5, y: self.nextNoteButton.center.y)
            self.nextNoteButtonRightConstraint.constant = 5
            
            self.countdDownView.center = CGPoint(x: self.view.bounds.width - self.countdDownView.bounds.width/2 - 5, y: self.countdDownView.center.y)
            self.countdownViewRightConstraint.constant = 5
            
        }, completion: { finished in
            self.ScrollerScrollView.isUserInteractionEnabled = true
        })
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isScrolling {
            stopScroller()
            startScroller()
        } else {
            maestroFindCurrentNote()
        }
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if isScrolling {
            stopScroller()
            startScroller()
        } else {
            maestroFindCurrentNote()
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isScrolling {
            stopScroller()
            startScroller()
        } else {
            maestroFindCurrentNote()
        }
    }
    func stopScroller() {
        isScrolling = false
    }
    func startScroller() {
        scrollAnimationComplete = true
        isScrolling = true
    }
    
    @IBAction func playbackPressed(_ sender: AnyObject) {
        if isPlayingBack {
            stopPlayingBack()
        } else {
            startPlayingBack()
        }
    }
    func startPlayingBack() {
        isPlayingBack = true
        playbackButton.setImage(UIImage(named: "speakerIcon-FullVolume"), for: UIControlState())
        if isScrolling == false && isCountingDown == false {
            startCountdown()
        }
    }
    func stopPlayingBack() {
        isPlayingBack = false
        playbackButton.setImage(UIImage(named: "speakerIcon-NoVolume"), for: UIControlState())
    }
    func setupMetronome() {
        metronomeSlider.maximumValue = constants.maxTempoFloat
        metronomeSlider.minimumValue = constants.minTempoFloat
        
        metronomeStepper.maximumValue = constants.maxTempoDouble
        metronomeStepper.minimumValue = constants.minTempoDouble
        
        let thisTempo = UserDefaults.standard.integer(forKey: "\(scrollerFile)Tempo")
        if thisTempo > 0 {
            beatsPerMinute = Float(thisTempo)
        } else {
            beatsPerMinute = fullBeatsPerMinute
        }
        
        metronomeSlider.value = beatsPerMinute
        metronomeStepper.value = Double(beatsPerMinute)
        tempoMetronomeLabel.text = "\(Int(metronomeSlider.value))"
        fullTempoLabel.text = "\(Int(fullBeatsPerMinute))"
    }
    @IBAction func metronomeSliderChanged(_ sender: UISlider) {
        tempoMetronomeLabel.text = "\(Int(sender.value))"
        metronomeStepper.value =  Double(sender.value)
        beatsPerMinute = Float(sender.value)
        UserDefaults.standard.set(Int(sender.value), forKey: "\(scrollerFile)Tempo")
    }
    @IBAction func metronomeStepperChanged(_ sender: UIStepper) {
        tempoMetronomeLabel.text = "\(Int(sender.value))"
        metronomeSlider.value =  Float(sender.value)
        beatsPerMinute = Float(sender.value)
        UserDefaults.standard.set(Int(sender.value), forKey: "\(scrollerFile)Tempo")
    }
    
    
    
    
    
    
    
    
    // MARK: SCROLLING
    
    var isScrolling: Bool = false
    var scrollAnimationComplete: Bool = false
    var isEndOfSong: Bool = false
    
    var currentNotesArray = [note]()
    var currentMeasureNoteArray = [note]()
    var nextNotePosX: CGFloat = 0
    var totalMeasureX: CGFloat = 0
    
    var playNoteShortest: Int = 24
    var playNoteShortestIndex: Int = 24
    var playNoteShortestDelay: Double = 0
    
    var isShortestDotted: Bool = false
    var isShortestTuplet: Bool = false
    
    func scroll() {
        if isScrolling {
            
            if scrollAnimationComplete {
                scrollAnimationComplete = false
                
                findCurrentNote()
                findNextNotePos()
                playChord()
                drawPressedKeys()
                
                
                if currentNotesArray.count > 1 {
                    if currentNotesArray.count > 1 {
                        var isFirstLoop: Bool = true
                        
                        for i in 0...currentNotesArray.count-1 {
                            let thisNote = currentNotesArray[i]
                            
                            if thisNote.noteGrace == false && thisNote.noteDuration > 0 {
                                if isFirstLoop == true {
                                    isFirstLoop = false
                                    playNoteShortest = thisNote.noteDuration
                                    playNoteShortestIndex = i
                                }
                                else {
                                    if thisNote.noteDuration < playNoteShortest && thisNote.noteDuration > 0 {
                                        playNoteShortest = thisNote.noteDuration
                                        playNoteShortestIndex = i
                                    }
                                }
                            }
                        }
                    }
                } else {
                    playNoteShortest = currentNotesArray[0].noteDuration
                    playNoteShortestIndex = 0
                }
                
                // Change half note timing based on rests
                if currentNotesArray[playNoteShortestIndex].noteType == "half" || currentNotesArray[playNoteShortestIndex].noteType == "quarter" || currentNotesArray[playNoteShortestIndex].noteType == "eighth" {
                    checkRestTiming()
                }
                
                let secondsToPlay = 60/beatsPerMinute
                let playnoteFloat: Float = Float(playNoteShortest)
                let divisionsFloat: Float = Float(divisions)
                
                playNoteShortestDelay = Double((playnoteFloat/divisionsFloat) * secondsToPlay)
                
                animateToNote()
            }
        }
    }
    func animateToNote() {
        UIView.animate(withDuration: playNoteShortestDelay, delay: 0.0, options: [.allowUserInteraction, .curveLinear], animations: {
            
            self.scrollingPoint = CGPoint(x: CGFloat(self.totalMeasureX) + self.nextNotePosX + 6 - self.noteGuiderView.center.x + self.keySigView.bounds.width, y: self.scrollingPoint!.y)
            
            self.ScrollerScrollView.contentOffset = self.scrollingPoint!
            
        }, completion: { finished in
            self.scrollAnimationComplete = true
        })
    }
    func playChord() {
        if self.isPlayingBack {
            for i in 0...currentNotesArray.count - 1 {
                if currentNotesArray[i].notePlay == true {
                    if let soundURL = Bundle.main.url(forResource: "/pianoAudio/\(currentNotesArray[i].notePitch!)", withExtension: "aif") {
                        var mySound: SystemSoundID = 0
                        AudioServicesCreateSystemSoundID(soundURL as CFURL, &mySound)
                        AudioServicesPlaySystemSound(mySound);
                    }
                }
            }
        }
    }
    func checkRestTiming() {
        var measureTodoRests: Int = 0
        var previousMeasureTodo: Int = 0
        var currentRestArray = [rest]()
        
        //Find Rests In Current Measure
        if currentMeasureInt <= 1 {
            if restNumberInMeasureArray[0] >= 1 {
                measureTodoRests = restNumberInMeasureArray[0] - 1
            } else {
                measureTodoRests = 0
            }
            previousMeasureTodo = 0
        } else if currentMeasureInt <= measureWidthArray.count {
            measureTodoRests = restNumberInMeasureArray[currentMeasureInt - 1] - 1
            previousMeasureTodo = restNumberInMeasureArray[currentMeasureInt - 2]
        }
        if measureTodoRests > previousMeasureTodo {
            currentRestArray.append(contentsOf: restArray[previousMeasureTodo...measureTodoRests])
        }
        if currentRestArray.count >= 1 {
            for r in 0...currentRestArray.count-1 {
                let thisRest = currentRestArray[r]
                if thisRest.restXPos > (currentNotesArray[playNoteShortestIndex].notePos.x - 40) && thisRest.restXPos < (currentNotesArray[playNoteShortestIndex].notePos.x + 40) {
                    if thisRest.restDuration < playNoteShortest && thisRest.restDuration > 0 {
                        playNoteShortest = thisRest.restDuration
                        print("REST \(playNoteShortest)")
                    }
                }
            }
        }
    }
    func findCurrentNote() {
        var measureTodoNotes: Int = 0
        var previousMeasureTodo: Int = 0
        var currentPos: CGFloat = 0
        
        //Find Notes In Current Measure
        if currentMeasureInt <= 1 {
            if noteNumberInMeasureArray[0] >= 1 {
                measureTodoNotes = noteNumberInMeasureArray[0] - 1
            } else {
                measureTodoNotes = 0
            }
            previousMeasureTodo = 0
        } else if currentMeasureInt <= measureWidthArray.count {
            measureTodoNotes = noteNumberInMeasureArray[currentMeasureInt - 1] - 1
            previousMeasureTodo = noteNumberInMeasureArray[currentMeasureInt - 2]
        }
        currentNotesArray.removeAll()
        currentMeasureNoteArray.removeAll()
        if measureTodoNotes-previousMeasureTodo >= 0 {
            currentMeasureNoteArray.append(contentsOf: noteArray[previousMeasureTodo...measureTodoNotes])
            
            currentPos = CGFloat(scrollingPoint!.x) + (CGFloat(noteGuiderView.center.x) - CGFloat(keySigView.bounds.width))
            
            totalMeasureX = CGFloat(firstMeasureOffset)
            if currentMeasureInt >= 2 {
                for j in 0...currentMeasureInt - 2 {
                    let thisMeasureWidth: CGFloat = CGFloat(measureWidthArray[j])
                    totalMeasureX += thisMeasureWidth
                }
            }
            
            var farthestLeftNoteIndex: Int = 0
            var farthestRightNoteIndex: Int = 0
            var farthestLeftDistance: CGFloat = 550.0
            var farthestRightDistance: CGFloat = 550.0
            var isFirstRight: Bool = true
            var isFirstLeft: Bool = true
            
            if currentMeasureNoteArray.count > 1 {
                for i in 0...currentMeasureNoteArray.count - 1 {
                    let thisNote = currentMeasureNoteArray[i]
                    
                    // find closest left & right notes
                    if thisNote.notePos.x + totalMeasureX < currentPos {
                        let leftDistance: CGFloat = currentPos - (thisNote.notePos.x + totalMeasureX)
                        if isFirstLeft == true {
                            isFirstLeft = false
                            farthestLeftNoteIndex = i
                        }
                        if leftDistance <= currentPos - (currentMeasureNoteArray[farthestLeftNoteIndex].notePos.x + totalMeasureX) {
                            farthestLeftNoteIndex = i
                            farthestLeftDistance = leftDistance
                        }
                    } else if thisNote.notePos.x + totalMeasureX > currentPos {
                        let rightDistance: CGFloat = (thisNote.notePos.x + totalMeasureX) - currentPos
                        if isFirstRight == true {
                            isFirstRight = false
                            farthestRightNoteIndex = i
                        }
                        if rightDistance <= (currentMeasureNoteArray[farthestRightNoteIndex].notePos.x + totalMeasureX) - currentPos {
                            farthestRightNoteIndex = i
                            farthestRightDistance = rightDistance
                        }
                    }
                    if i >= currentMeasureNoteArray.count - 1 {
                        // find which is closer
                        let firstNote: note!
                        
                        if farthestLeftDistance-12 <= farthestRightDistance {
                            firstNote = currentMeasureNoteArray[farthestLeftNoteIndex]
                        } else {
                            firstNote = currentMeasureNoteArray[farthestRightNoteIndex]
                        }
                        
                        // find all currant notes
                        for b in 0...currentMeasureNoteArray.count - 1 {
                            let noteToAdd = currentMeasureNoteArray[b]
                            
                            if (noteToAdd.notePos.x <= firstNote.notePos.x + 14) && (noteToAdd.notePos.x >= firstNote.notePos.x - 4) {
                                currentNotesArray.append(noteToAdd)
                            }
                        }
                    }
                }
            } else if currentMeasureNoteArray.count == 1 {
                currentNotesArray.append(currentMeasureNoteArray[0]) // Only one note in measure
            }
        }
    }
    func findNextNotePos() {
        findCurrentNote()
        if currentMeasureNoteArray.count >= 1 {
            var closestNoteIndex: Int = 0
            var nextNotesArray = [note]()
            
            for i in 0...currentMeasureNoteArray.count-1 {
                let thisNote = currentMeasureNoteArray[i]
                
                if thisNote.notePos.x > currentNotesArray[0].notePos.x + 12 {
                    nextNotesArray.append(thisNote)
                }
                if i >= currentMeasureNoteArray.count-1 {
                    if nextNotesArray.count >= 1 {
                        for b in 0...nextNotesArray.count-1 {
                            let laNota = nextNotesArray[b].notePos.x
                            
                            if laNota < nextNotesArray[closestNoteIndex].notePos.x {
                                closestNoteIndex = b
                            }
                            if b >= nextNotesArray.count-1 {
                                nextNotePosX = nextNotesArray[closestNoteIndex].notePos.x
                            }
                        }
                    } else { // End of measure
                        if currentMeasureInt <= measureWidthArray.count-1 {
                            let NextMeasureTodoNotes: Int = noteNumberInMeasureArray[currentMeasureInt] - 1
                            let thisMeasureTodo: Int = noteNumberInMeasureArray[currentMeasureInt - 1]
                            if NextMeasureTodoNotes-thisMeasureTodo >= 0 {
                            nextNotesArray.append(contentsOf: noteArray[thisMeasureTodo...NextMeasureTodoNotes])
                            }
                            if nextNotesArray.count >= 1 {
                                for b in 0...nextNotesArray.count-1 {
                                    let laNota = nextNotesArray[b].notePos.x
                                    
                                    if laNota < nextNotesArray[closestNoteIndex].notePos.x {
                                        closestNoteIndex = b
                                    }
                                    if b >= nextNotesArray.count-1 {
                                        totalMeasureX += CGFloat(measureWidthArray[currentMeasureInt-1])
                                        nextNotePosX = nextNotesArray[closestNoteIndex].notePos.x
                                    }
                                }
                            }
                        } else { // End of song
                            stopScroller()
                            countdownShowIsh()
                            isEndOfSong = true
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: EL MAESTRO
    var pianoView = drawPianoView()
    
    var whiteKeyWidth: CGFloat = 0.0
    var blackKeyWidth: CGFloat = 0.0
    var xStartPos: CGFloat = 0.0
    var xEndPos: CGFloat = 0.0
    
    var lowestNoteStaff: Int?
    var highestNoteStaff: Int?
    
    func setupMaestroView() {
        let distanceFromStaffToTop: CGFloat = self.view.bounds.height/2 - averageStaffDistance/2 - 55
        let pianoHeight: CGFloat = distanceFromStaffToTop/2
        
        elMaestroView.frame = CGRect(x: 0, y: self.view.bounds.height, width: elMaestroView.bounds.width, height: pianoHeight)
        elMeastroHeightConstraint.constant = pianoHeight
        self.elMeastroBottomConstraint.constant = -self.elMaestroView.bounds.height
        
        ///keysig shadow y width
        elMaestroView.layer.shadowColor = UIColor.black.cgColor
        elMaestroView.layer.shadowOpacity = 0.65
        elMaestroView.layer.shadowOffset = CGSize.zero
        elMaestroView.layer.shadowRadius = 4
    }
    @IBAction func showMaestroPressed(_ sender: AnyObject) {
        showMeastro()
    }
    func showMeastro() {
        elMaestroIsVisible = true
        elMaestroView.isHidden = false
        
        let distanceFromStaffToTop: CGFloat = self.view.bounds.height/2 - averageStaffDistance/2 - 55
        let distanceToMove: CGFloat = distanceFromStaffToTop/4
        
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
            self.elMaestroView.frame = CGRect(x: 0, y: self.view.bounds.height - self.elMaestroView.bounds.height, width: self.elMaestroView.bounds.width, height: self.elMaestroView.bounds.height)
            self.elMeastroBottomConstraint.constant = 0
            
            self.ScrollerScrollView.frame = CGRect(x: self.scrollerScrollViewLeftConstraint.constant, y: -distanceToMove, width: self.ScrollerScrollView.bounds.width, height: self.ScrollerScrollView.bounds.height)
            self.scrollerScrollViewTopConstraint.constant = -distanceToMove
            self.scrollerScrollViewBottomConstraint.constant = distanceToMove
            
            self.keySigView.frame = CGRect(x: self.keySigView.center.x - self.keySigView.bounds.width/2, y: -distanceToMove, width: self.keySigView.bounds.width, height: self.keySigView.bounds.height)
            self.keySigTopConstraint.constant = -distanceToMove
            self.keysigBottomConstraint.constant = distanceToMove
        }, completion: { finished in
        })
    }
    func elMaestroViewDwipedDown(_ sender: UISwipeGestureRecognizer) {
        hideMaestro()
    }
    func elMaestroViewTapped(_ sender: UISwipeGestureRecognizer) {
        hideMaestro()
    }
    func hideMaestro() {
        elMaestroIsVisible = false
        
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
            
            self.elMaestroView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.elMaestroView.bounds.width, height: self.elMaestroView.bounds.height)
            self.elMeastroBottomConstraint.constant = -self.elMaestroView.bounds.height
            
            self.ScrollerScrollView.frame = CGRect(x: self.scrollerScrollViewLeftConstraint.constant, y: 0, width: self.ScrollerScrollView.bounds.width, height: self.ScrollerScrollView.bounds.height)
            self.scrollerScrollViewTopConstraint.constant = 0
            self.scrollerScrollViewBottomConstraint.constant = 0
            
            self.keySigView.frame = CGRect(x: self.keySigView.center.x - self.keySigView.bounds.width/2, y: 0, width: self.keySigView.bounds.width, height: self.keySigView.bounds.height)
            self.keySigTopConstraint.constant = 0
            self.keysigBottomConstraint.constant = 0
            
            self.elMaestroView.frame = CGRect(x: 0, y: self.elMaestroView.center.y - self.elMaestroView.bounds.height/2, width: self.elMaestroView.bounds.width, height: self.elMaestroView.bounds.height)
            self.elMeastroHeightConstraint.constant = self.elMaestroView.bounds.height
            
        }, completion: { finished in
            self.elMaestroView.isHidden = true
        })
    }
    @IBAction func countDownStepperChanged(_ sender: UIStepper) {
        countdownLabel.text = "\(Int(sender.value))"
        countdownNumber = Int(sender.value)
        UserDefaults.standard.set(countdownNumber, forKey: "savedCountdown")
    }
    @IBAction func nextNoteButtonPressed(_ sender: AnyObject) {
        findNextNotePos()
        
        if currentNotesArray.count >= 1 {
            if ControlPanelIsOpen {
                scrollingPoint = CGPoint(x: CGFloat(totalMeasureX) + nextNotePosX + 6 - noteGuiderView.center.x + keySigView.bounds.width + controlPanalView.bounds.width, y: scrollingPoint!.y)
            } else {
                scrollingPoint = CGPoint(x: CGFloat(totalMeasureX) + nextNotePosX + 6 - noteGuiderView.center.x + keySigView.bounds.width, y: scrollingPoint!.y)
            }
            UIView.animate(withDuration: 0.15, delay: 0.0, options: [.allowUserInteraction, .curveLinear], animations: {
                
                self.ScrollerScrollView.contentOffset = self.scrollingPoint!
                
            }, completion: { finished in
                self.findCurrentNote()
                self.drawPressedKeys()
                self.playChord()
            })
        }
    }
    func drawPressedKeys() {
        pianoView.removeFromSuperview()
        let topPadding: CGFloat = 2.0
        pianoView = drawPianoView(frame: CGRect(x: 0, y: topPadding, width: self.elMaestroView.bounds.width, height: self.elMaestroView.bounds.height - topPadding))
        pianoView.pianoHeight = self.elMaestroView.bounds.height - topPadding
        pianoView.backgroundColor = UIColor.clear
        elMaestroView.addSubview(pianoView)
        
        if currentNotesArray.count >= 1 {
            pianoView.currentNotesArray.append(contentsOf: currentNotesArray)
        }
        elMaestroView.addSubview(pianoView)
    }
    func maestroFindCurrentNote() {
        findCurrentNote()
        
        if currentNotesArray.count >= 1 {
            
            scrollingPoint = CGPoint(x: CGFloat(totalMeasureX) + currentNotesArray[0].notePos!.x + 6 - noteGuiderView.center.x + keySigView.bounds.width, y: scrollingPoint!.y)
            
            UIView.animate(withDuration: 0.15, delay: 0.0, options: [.allowUserInteraction, .curveLinear], animations: {
                
                self.ScrollerScrollView.contentOffset = self.scrollingPoint!
                
            }, completion: { finished in
                self.drawPressedKeys()
                self.playChord()
            })
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: XML PARSING
    
    var parser: XMLParser!
    var parser2: XMLParser!
    var parserNumber: Int = 1
    var element = NSString()
    var endElement = NSString()
    
    var measureWidthArray: [Float] = []
    var measureWidth: CGFloat?
    var currentDrawMeasureXPos: CGFloat = 0.0
    var todoSongWidth: CGFloat = 0.0
    
    var averageStaffDistance: CGFloat = 65.0 //65 is default
    var currentStaffDistance: CGFloat = 65.0 //65 is default
    var noteStaff: Int = 0
    
    var newSystem: Bool = false
    var isChord: Bool = false
    
    var clef1: String = ""
    var clef2: String = ""
    var isFirstClef: Bool = true
    var isSecondClef: Bool = false
    var fifths: Int?
    var beats: Int?
    var beatType: Int?
    var checkForBeats: Bool = true
    var checkForBeatType: Bool = true
    var divisions: Int = 0
    
    var noteStep: String = ""
    var noteOctave: String = ""
    
    var measureNumber: Int = 0
    var noteNumber: Int = 0
    var noteNumberInMeasureArray: [Int] = []
    var restNumber: Int = 0
    var restNumberInMeasureArray: [Int] = []
    
    var isNote: Bool = false
    var previousIsNote: Bool = false
    var previousIsRest: Bool = false
    
    var noteArray = [note]()
    var noteClusterArray = [note]()
    var noteType: String = ""
    var noteXCGFloat: CGFloat = 0
    var noteYCGFloat: CGFloat = 0
    var notePos: CGPoint?
    var noteStem: String = ""
    var noteStemLength: CGFloat = 38.0 //36 is default
    var notePitch: Int = 0
    var noteDuration: Int = 0
    var noteAlter: Int = 5
    var noteDot: Bool = false
    var noteNatural: Bool = false
    var isGraceNote: Bool = false
    var noteTuplet: String = ""
    var octaveShiftArray = [octaveShift]()
    var isOctaveShift: Bool = false
    var arpeggioArray = [arpeggio]()
    var isArpeggiated: Bool = false
    var lastNoteArpeggiated: Bool = false
    var playNote: Bool = true
    
    var hasBeam1: Bool = false
    var hasBeam2: Bool = false
    var hasBeam3: Bool = false
    var hasBeam4: Bool = false
    
    var beam1: String = ""
    var beam2: String = ""
    var beam3: String = ""
    var beam4: String = ""
    
    var restArray = [rest]()
    var restType: String = ""
    var restXCGFloat: CGFloat = 0
    var restStaff: Int = 0
    
    var isRepeatStart: Bool = false
    var isRepeatEnd: Bool = false
    var isFirstEnding: Bool = false
    var isSecondEnding: Bool = false
    var repeatStartInfo: repeatSection = repeatSection(measureNumber: 0, todoSongWidth: 0, noteNumber: 0, restNumber: 0, octaveShiftArrayIndex: 0, arpeggioArrayIndex: 0, tieArrayIndex: 0)
    
    var octaveType: String = ""
    var octaveSize: Int = 0
    var octaveNumber: Int = 0
    
    var tieArray = [nameNPos]()
    var tieType: String = ""
    var isStartTie: Bool = false
    var isEndTie: Bool = false
    var tieStartXPos: CGFloat = 0
    
    var printObject: Bool = true
    var isForPiano: Bool = false
    
    func beginParsing() {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: String = paths[0] as String
        let urlpath: String = (documentsDirectory as NSString).appendingPathComponent("\(scrollerFile)")
        let url:URL = URL(fileURLWithPath: urlpath)
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: urlpath) {
            parser = XMLParser(contentsOf: url)!
            parser.delegate = self
            parser.parse()
            //Finished Parser 1:
            
            if isForPiano == false {
                // ALERT: NOT FOR PIANO
                let alertController = UIAlertController(title: "Currently not supported", message: "Scroller currenlty only supports songs for piano.", preferredStyle: .alert)
                let addSetlistAction = UIAlertAction(title: "OK", style: .default) { (_) in
                }
                alertController.addAction(addSetlistAction)
                present(alertController, animated: true, completion: nil)
            }
            setupKeySig()
            firstMeasureOffset = self.noteGuiderView.center.x - keySigViewWidth!
            
            parserNumber = 2
            parser2 = XMLParser(contentsOf: url)!
            parser2.delegate = self
            parser2.parse()
            //Finished Parser 2:
            
            let distanceToAdd: CGFloat = self.view.bounds.width - noteGuiderView.center.x
            ScrollerScrollView.delegate = self
            ScrollerScrollView.contentSize = CGSize(width: firstMeasureOffset + todoSongWidth + distanceToAdd, height: self.view.bounds.height)
            ScrollerScrollView.contentOffset = CGPoint(x: -1.0, y: 0.0)
            ScrollerScrollView.frame = CGRect(x: self.view.bounds.width - 1, y: 0, width: 1, height: self.view.bounds.height)
            scrollerScrollViewLeftConstraint.constant = self.view.bounds.width - 1
            
            drawMeasures()
            drawCrap()
            setupMaestroView()
            currentMeasureInt = 1
            noteGuiderMeasureNumberLabel.text = "\(currentMeasureInt)"
            
            hideLoading()
            CloseControlPanal(1.0, isSetup: true)
            showPlaybackButton(0.5)
            showMaestroButton(0.5)
            showNoteGuider(0.25)
            
            scrollerTimer = Timer.scheduledTimer(timeInterval: 1.0/60.0, target: self, selector: #selector(ScrollerViewController.scroll), userInfo: nil, repeats: true)
        } else {
            // ALERT: SONG DOES NOT EXIST
            let alertController = UIAlertController(title: "Song not found", message: "It looks like this song doesn't exist on this device.", preferredStyle: .alert)
            let addSetlistAction = UIAlertAction(title: "OK", style: .default) { (_) in
                self.goHome()
            }
            alertController.addAction(addSetlistAction)
            present(alertController, animated: true, completion: nil)
            
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        element = elementName as NSString
        if parserNumber == 2{
            if (element == "measure"){
                let measureWidthString: String = attributeDict ["width"]!
                measureWidth = CGFloat(Int(Float(measureWidthString)!))
                measureNumber += 1
            }
            if (element == "system-layout") {
                newSystem = true
            }
            if (element == "repeat") {
                let repeatAtribute: NSString? = attributeDict ["direction"] as NSString?
                if repeatAtribute != nil {
                    if (repeatAtribute as! String) == "forward" {
                        isRepeatStart = true
                    } else if (repeatAtribute as! String) == "backward" {
                        isRepeatEnd = true
                    }
                }
            }
            if (element == "note") {
                let noteXPos: NSString? = attributeDict ["default-x"] as NSString?
                if noteXPos != nil {
                    noteXCGFloat = CGFloat(Int(Float((noteXPos as? String)!)!))
                    isNote = true
                }
                let noteYPos: NSString? = attributeDict ["default-y"] as NSString?
                if noteYPos != nil {
                    noteYCGFloat = CGFloat(Int(Float((noteYPos as? String)!)!))
                    isNote = true
                }
                let printObjectString: NSString? = attributeDict ["print-object"] as NSString?
                if printObjectString != nil {
                    if printObjectString == "no" {
                        printObject = false
                    } else {
                        printObject = true
                    }
                }
            }
            if (element == "dot") {
                noteDot = true
            }
            if (element == "grace") {
                isGraceNote = true
                // atr = slash
            }
            if (element == "beam") {
                let beamNumber: NSString? = attributeDict ["number"] as NSString?
                if beamNumber != nil {
                    if Int(Float((beamNumber as? String)!)!) == 1 {
                        hasBeam1 = true
                    } else if Int(Float((beamNumber as? String)!)!) == 2 {
                        hasBeam2 = true
                    } else if Int(Float((beamNumber as? String)!)!) == 3 {
                        hasBeam3 = true
                    } else if Int(Float((beamNumber as? String)!)!) == 4 {
                        hasBeam4 = true
                    }
                }
            }
            if (elementName == "octave-shift") {
                isOctaveShift = true
                let typeAtr: NSString? = attributeDict ["type"] as NSString?
                let sizeAtr: NSString? = attributeDict ["size"] as NSString?
                let numberAtr: NSString? = attributeDict ["number"] as NSString?
                
                if typeAtr != nil {
                    octaveType = (typeAtr as? String)!
                }
                if sizeAtr != nil {
                    octaveSize = Int(Float((sizeAtr as? String)!)!)
                }
                if numberAtr != nil {
                    octaveNumber = Int(Float((numberAtr as? String)!)!)
                }
            }
            if (elementName == "ending") {
                let number: NSString? = attributeDict ["number"] as NSString?
                
                if number != nil {
                    if number == "1" {
                        isFirstEnding = true
                    } else if number == "2" {
                        isSecondEnding = true
                    }
                }
            }
            if (elementName == "tie") {
                let typeAtr: NSString? = attributeDict ["type"] as NSString?
                
                if typeAtr != nil {
                    tieType = (typeAtr as? String)!
                    if tieType == "stop" {
                        isEndTie = true
                    } else {
                        isStartTie = true
                    }
                }
            }
            if (elementName == "tuplet") {
                let typeAtr: NSString? = attributeDict ["type"] as NSString?
                
                if typeAtr != nil {
                    noteTuplet = (typeAtr as? String)!
                }
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if parserNumber == 1 {
            
            if element.isEqual(to: "staff-distance") {
                let staffDistanceThisMeasure = Float(string)
                if staffDistanceThisMeasure != nil {
                    let StaffDistanceCGFloat: CGFloat = CGFloat(Int(staffDistanceThisMeasure!))
                    
                    averageStaffDistance += StaffDistanceCGFloat
                    averageStaffDistance = averageStaffDistance/2
                }
            }
            if element.isEqual(to: "fifths") {
                let fifthsFloat = Float(string)
                if fifthsFloat != nil {
                    fifths = Int(fifthsFloat!)
                }
            }
            if element.isEqual(to: "divisions") {
                let divisionsFloat = Float(string)
                if divisionsFloat != nil {
                    divisions = Int(divisionsFloat!)
                }
            }
            if element.isEqual(to: "beats") {
                if checkForBeats {
                    let beatsFloat = Float(string)
                    if beatsFloat != nil {
                        beats = Int(beatsFloat!)
                        checkForBeats = false
                    }
                }
            }
            if element.isEqual(to: "beat-type") {
                if checkForBeatType {
                    let beatTypeFloat = Float(string)
                    if beatTypeFloat != nil {
                        beatType = Int(beatTypeFloat!)
                        checkForBeatType = false
                    }
                }
            }
            if element.isEqual(to: "sign") {
                if isFirstClef {
                    clef1.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
                }
                if isSecondClef {
                    clef2.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
                    isForPiano = true
                }
            }
            if element.isEqual(to: "instrument-name") {
                var thisInstrument: String = ""
                thisInstrument.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
                if thisInstrument == "piano" || thisInstrument == "Piano" || thisInstrument == "organ" || thisInstrument == "Organ" {
                    isForPiano = true
                }
            }
            if element.isEqual(to: "staves") {
                let numberOfStaves = Float(string)
                
                if numberOfStaves != nil {
                    if Int(numberOfStaves!) == 2 {
                        isForPiano = true
                    }
                }
            }
        }
    
        if parserNumber == 2{
            
            if element.isEqual(to: "staff-distance") {
                let staffDistanceThisMeasure = Float(string)
                if staffDistanceThisMeasure != nil {
                    let StaffDistanceCGFloat: CGFloat = CGFloat(Int(staffDistanceThisMeasure!))
                    
                    currentStaffDistance = StaffDistanceCGFloat
                }
            }
            if element.isEqual(to: "alter") {
                if isNote {
                    if Int(string) != nil {
                        noteAlter = Int(string)!
                    }
                }
            }
            if element.isEqual(to: "chord") {
                isChord = true
            }
            if element.isEqual(to: "fifths") {
                let fifthsFloat = Float(string)
                if fifthsFloat != nil {
                    fifths = Int(fifthsFloat!)
                }
            }
            if element.isEqual(to: "per-minute") {
                let fullBeatsPerMinuteFloat = Float(string)
                if fullBeatsPerMinuteFloat != nil {
                    fullBeatsPerMinute = fullBeatsPerMinuteFloat!
                }
            }
            if element.isEqual(to: "step") {
                if isNote {
                    noteStep.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
                }
            }
            if element.isEqual(to: "octave") {
                if isNote {
                    noteOctave.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
                }
            }
            if element.isEqual(to: "duration") {
                if isNote {
                    if Int(string) != nil {
                        noteDuration = Int(string)!
                    }
                }
            }
            if element.isEqual(to: "type") {
                if isNote {
                    noteType.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
                } else {
                    restType.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
                }
            }
            if element.isEqual(to: "stem") {
                if isNote {
                    noteStem.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
                }
            }
            if element.isEqual(to: "beam") {
                if hasBeam1 {
                    beam1.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
                    hasBeam1 = false
                } else if hasBeam2 {
                    beam2.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
                    hasBeam2 = false
                } else if hasBeam3 {
                    beam3.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
                    hasBeam3 = false
                } else if hasBeam4 {
                    beam4.append(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
                    hasBeam4 = false
                }
            }
            if element.isEqual(to: "arpeggiate") {
                if isNote {
                    isArpeggiated = true
                }
            }
            if element.isEqual(to: "accidental") {
                if isNote {
                    if (string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) == "natural" {
                        noteNatural = true
                    }
                    
                }
            }
            if element.isEqual(to: "staff") {
                if isNote {
                    if string.contains("1") {
                        noteStaff = 1
                    } else if string.contains("2") {
                        if noteStaff == 1 {
                            previousIsNote = false
                            previousIsRest = false
                        }
                        noteStaff = 2
                    }
                } else {
                    if string.contains("1") {
                        restStaff = 1
                    } else if string.contains("2") {
                        if restStaff == 1 {
                            previousIsRest = false
                        }
                        restStaff = 2
                    }
                }
            }
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        endElement = elementName as NSString
       
        if parserNumber == 1 {
            if (endElement == "sign") {
                if isFirstClef {
                    isFirstClef = false
                    isSecondClef = true
                } else if isSecondClef {
                    isSecondClef = false
                } else {
                    isFirstClef = false
                    isSecondClef = false
                    isForPiano = false
                }
            }
        } else if parserNumber == 2 {
            
            if (endElement == "measure") {
                
                var currentMeasureWidth: CGFloat = measureWidth!
                if newSystem {
                    currentMeasureWidth -= keySigViewWidth! - constants.newSystemCut
                }
                newSystem = false
                
                let widthForArray = Float(currentMeasureWidth)
                
                measureWidthArray.append(widthForArray)
                todoSongWidth += currentMeasureWidth
                
                noteNumberInMeasureArray.append(noteNumber)
                restNumberInMeasureArray.append(restNumber)
                
                isChord = false
                noteClusters()
                
                if isRepeatStart == true {
                    repeatStart()
                }
                if isRepeatEnd == true {
                    repeatEnd()
                }
                if isOctaveShift == true {
                    isOctaveShift = false
                    
                    var xpos: CGFloat = 0.0
                    if octaveType == "up" || octaveType == "down" {
                        xpos = noteArray[noteArray.count-1].notePos.x
                    } else if octaveType == "stop" {
                        xpos = noteArray[noteArray.count-1].notePos.x
                    }
                    octaveShiftArray.append(octaveShift(type: octaveType, size: octaveSize, number: octaveNumber, measureIndex: measureNumber-1, startEndPointX: xpos))
                    octaveType = ""
                    octaveSize = 0
                    octaveNumber = 0
                }
            }
            if (endElement == "note") {
                
                let noteOffestForStaff: CGFloat = averageStaffDistance - currentStaffDistance
                let staffOffset: CGFloat
                
                var newSystemOffset: CGFloat = 0.0
                if newSystem {
                    newSystemOffset = keySigViewWidth! - constants.newSystemCut
                }
                
                if noteStaff == 1 {
                    staffOffset = (self.view.bounds.height)/2 - averageStaffDistance/2 - 45.5
                } else if noteStaff == 2 {
                    staffOffset = (self.view.bounds.height)/2 - averageStaffDistance/2 - 44.5 + noteOffestForStaff
                } else {
                    staffOffset = (self.view.bounds.height)/2 - averageStaffDistance/2 - 45.5
                }
                
                notePos = CGPoint(x: noteXCGFloat - newSystemOffset, y: -noteYCGFloat + staffOffset)
                
                if isNote {
                    //APPEND NOTE
                    
                    findPitch()
                    if noteAlter != 5 {
                        notePitch += noteAlter
                    }
                    if isGraceNote == true {
                        isGraceNote = false
                        noteDuration = 0
                    }
                    if isEndTie == true {
                        playNote = false
                    }
                    cancelAlters()
                    
                    noteArray.append(note(notePos: notePos!, noteType: noteType, noteStem: noteStem, noteStemLength: noteStemLength, notePitch: notePitch, noteDuration: noteDuration, noteAlter: noteAlter, noteStep: noteStep, noteStaff: noteStaff, noteDot: noteDot, noteTuplet: noteTuplet, noteGrace: isGraceNote, notePlay: playNote, beam1: beam1, beam2: beam2, beam3: beam3, beam4: beam4))
                    
                    
                    noteClusters()
                    
                    
                    noteNumber += 1
                    previousIsNote = true
                    previousIsRest = false
                    
                } else {
                    //APPEND REST
                    if printObject == true {
                        
                        if restType == "" {
                            restType = "whole"
                        }
                        var restPosX: CGFloat = 40
                        
                        if previousIsNote == true {
                            if noteStaff == restStaff {
                                restPosX = notePos!.x + 40
                            } else {
                                restPosX = notePos!.x
                            }
                        } else if previousIsRest == true {
                            restPosX = notePos!.x + 65
                        }
                        
                        restArray.append(rest(restType: restType, restStaff: restStaff, restXPos: restPosX, restDuration: noteDuration, restDot: noteDot))
                        
                        restNumber += 1
                        previousIsRest = true
                        previousIsNote = false
                    }
                    
                }
                if noteTuplet == "start" {
                    noteTuplet = "continue"
                } else {
                    noteTuplet = ""
                }
                
                if isOctaveShift == true {
                    isOctaveShift = false
                    
                    var xpos: CGFloat = 0.0
                    if octaveType == "up" || octaveType == "down" {
                        xpos = noteArray[noteArray.count-1].notePos.x
                    } else if octaveType == "stop" {
                        xpos = noteArray[noteArray.count-2].notePos.x
                    }
                    octaveShiftArray.append(octaveShift(type: octaveType, size: octaveSize, number: octaveNumber, measureIndex: measureNumber-1, startEndPointX: xpos))
                    octaveType = ""
                    octaveSize = 0
                    octaveNumber = 0
                }
                if isArpeggiated == true {
                    isArpeggiated = false
                    arpeggioArray.append(arpeggio(measureIndex: measureNumber-1, xPos: (notePos?.x)!, yPos: (notePos?.y)!, staff: noteStaff))
                }
                
                if isEndTie == true {
                    isEndTie = false
                    var tieEndXPos: CGFloat = firstMeasureOffset + (notePos?.x)!
                    if measureWidthArray.count >= 1 {
                        for j in 0...measureWidthArray.count-1 {
                            let thisMeasure = CGFloat(measureWidthArray[j])
                            tieEndXPos += thisMeasure
                            if j >= measureWidthArray.count-1 {
                                tieArray.append(nameNPos(name: tieType, x1Pos: tieStartXPos, x2Pos: tieEndXPos, yPos: (notePos?.y)!))
                            }
                        }
                    } else {
                        tieArray.append(nameNPos(name: tieType, x1Pos: tieStartXPos, x2Pos: tieEndXPos, yPos: (notePos?.y)!))
                    }
                }
                if isStartTie == true {
                    isStartTie = false
                    tieStartXPos = firstMeasureOffset + (notePos?.x)!+12
                    if measureWidthArray.count >= 1 {
                        for j in 0...measureWidthArray.count-1 {
                            let thisMeasure = CGFloat(measureWidthArray[j])
                            tieStartXPos += thisMeasure
                        }
                    } else {
                        tieStartXPos = firstMeasureOffset + (notePos?.x)!+12
                    }
                }
                
                isNote = false
                noteAlter = 5
                noteType = ""
                noteStem = ""
                noteStemLength = 38.0
                noteStep = ""
                noteOctave = ""
                beam1 = ""
                beam2 = ""
                beam3 = ""
                beam4 = ""
                restType = ""
                noteNatural = false
                noteDot = false
                isGraceNote = false
                playNote = true
                
                printObject = true
            }
            if (endElement == "pitch") {
                let noteFinder = notePitchClass()
                noteFinder.noteStep = noteStep
                noteFinder.noteOctave = noteOctave
                noteFinder.noteAlter = noteAlter
                notePitch = noteFinder.findNoteNumber()
            }
        }
    }
    
    
    
    func repeatStart() {
        isRepeatStart = false
        
        var currentMeasureWidth: CGFloat = measureWidth!
        if newSystem {
            currentMeasureWidth -= keySigViewWidth! - constants.newSystemCut
        }
        
        var realNoteNumber: Int = 0
        if noteNumberInMeasureArray.count >= 2 {
            realNoteNumber = noteNumber-(noteNumberInMeasureArray[noteNumberInMeasureArray.count-1]-noteNumberInMeasureArray[noteNumberInMeasureArray.count-2])
        } else {
            realNoteNumber = noteNumber-(noteNumberInMeasureArray[noteNumberInMeasureArray.count-1])
        }
        
        var realRestNumber: Int = 0
        if restNumberInMeasureArray.count >= 2 {
            realRestNumber = restNumber-(restNumberInMeasureArray[restNumberInMeasureArray.count-1]-restNumberInMeasureArray[restNumberInMeasureArray.count-2])
        } else {
            realRestNumber = restNumber-(restNumberInMeasureArray[restNumberInMeasureArray.count-1])
        }
        if realRestNumber < 1 {
            realRestNumber = 0
        }
        var octaveShiftIndex: Int = 0
        if octaveShiftArray.count >= 2 && measureNumber > 1 {
            octaveShiftIndex = octaveShiftArray.count-1
        }
        var arpeggioIndex: Int = 0
        if arpeggioArray.count >= 1 && measureNumber > 1 {
            arpeggioIndex = arpeggioArray.count-1
        }
        var tieArrayIndex: Int = 0
        if tieArray.count >= 1 && measureNumber > 1 {
            tieArrayIndex = tieArray.count-1
        }
        repeatStartInfo = repeatSection(measureNumber: measureWidthArray.count-1, todoSongWidth: todoSongWidth, noteNumber: realNoteNumber, restNumber: realRestNumber, octaveShiftArrayIndex: octaveShiftIndex, arpeggioArrayIndex: arpeggioIndex, tieArrayIndex: tieArrayIndex)
    }
    func repeatEnd() {
        isRepeatEnd = false
        
        var currentMeasureWidth: CGFloat = measureWidth!
        if newSystem {
            currentMeasureWidth -= keySigViewWidth! - constants.newSystemCut
        }
        
        //copy ish
        var nu: Int = 1
        if isFirstEnding == true {
            isFirstEnding = false
            nu = 2
        } else {
            nu = 1
        }
        let oldMeasureNumber: Int = measureNumber
        let oldTodoSongWidth: CGFloat = todoSongWidth
        
        measureNumber += (measureNumber-(nu-1)-repeatStartInfo.measureNumber)
        measureWidthArray.append(contentsOf: measureWidthArray[repeatStartInfo.measureNumber...measureWidthArray.count-nu])
        if nu == 2 {
            todoSongWidth += todoSongWidth-repeatStartInfo.todoSongWidth
        } else {
            todoSongWidth += (todoSongWidth-repeatStartInfo.todoSongWidth)
        }
        
        var realNoteNumber: Int = 0
        if noteNumberInMeasureArray.count >= 2 {
            if nu == 2 {
                realNoteNumber = noteNumber-(noteNumberInMeasureArray[noteNumberInMeasureArray.count-1]-noteNumberInMeasureArray[noteNumberInMeasureArray.count-2])
            } else {
                realNoteNumber = noteNumber
            }
        } else {
            realNoteNumber = noteNumber-(noteNumberInMeasureArray[noteNumberInMeasureArray.count-1])
        }
        noteArray.append(contentsOf: noteArray[repeatStartInfo.noteNumber...noteNumberInMeasureArray[noteNumberInMeasureArray.count-nu]-1])
        noteNumber += (realNoteNumber-repeatStartInfo.noteNumber)
        
        var realRestNumber: Int = 0
        if restNumberInMeasureArray.count >= 2 {
            if nu == 2 {
                realRestNumber = restNumber-(restNumberInMeasureArray[restNumberInMeasureArray.count-1]-restNumberInMeasureArray[restNumberInMeasureArray.count-2])
            } else {
                realRestNumber = restNumber
            }
        } else {
            realRestNumber = restNumber-(restNumberInMeasureArray[restNumberInMeasureArray.count-1])
        }
        if restNumberInMeasureArray[restNumberInMeasureArray.count-nu]-1 >= repeatStartInfo.restNumber {
            restArray.append(contentsOf: restArray[repeatStartInfo.restNumber...restNumberInMeasureArray[restNumberInMeasureArray.count-nu]-1])
            restNumber += (realRestNumber-repeatStartInfo.restNumber)
        }
        
        if noteNumberInMeasureArray.count >= 1 {
            var arrayOfNoteNumbers = [Int]()
            var changinNoteNumber: Int = noteNumber
            changinNoteNumber -= (realNoteNumber-repeatStartInfo.noteNumber)
            
            for k in repeatStartInfo.measureNumber...noteNumberInMeasureArray.count-nu {
                var thisToAdd: Int = noteNumberInMeasureArray[k]
                
                if k >= 1 {
                    thisToAdd = noteNumberInMeasureArray[k]-noteNumberInMeasureArray[k-1]
                }
                
                changinNoteNumber += thisToAdd
                arrayOfNoteNumbers.append(changinNoteNumber)
                
                if k >= noteNumberInMeasureArray.count-nu {
                    noteNumberInMeasureArray.append(contentsOf: arrayOfNoteNumbers)
                }
            }
        }
        if restNumberInMeasureArray.count >= 1 {
            var arrayOfRestNumbers = [Int]()
            var changinRestNumber: Int = restNumber
            changinRestNumber -= (realRestNumber-repeatStartInfo.restNumber)
            
            for k in repeatStartInfo.measureNumber...restNumberInMeasureArray.count-nu {
                var thisToAdd: Int = restNumberInMeasureArray[k]
                
                if k >= 1 {
                    thisToAdd = restNumberInMeasureArray[k]-restNumberInMeasureArray[k-1]
                }
                
                changinRestNumber += thisToAdd
                arrayOfRestNumbers.append(changinRestNumber)
                
                if k >= restNumberInMeasureArray.count-nu {
                    restNumberInMeasureArray.append(contentsOf: arrayOfRestNumbers)
                }
            }
        }
        
        
        if octaveShiftArray.count >= 2 {
            var arrayOfOctaves = [octaveShift]()
            
            for e in repeatStartInfo.octaveShiftArrayIndex...octaveShiftArray.count-1 {
                let thisType = octaveShiftArray[e].type
                let thisSize = octaveShiftArray[e].size
                let thisNumber = octaveShiftArray[e].number
                let thisMeasureIndex = octaveShiftArray[e].measureIndex
                let thisStartEndXPos = octaveShiftArray[e].startEndPointX
                let newMeasureIndex = oldMeasureNumber + (thisMeasureIndex! - repeatStartInfo.measureNumber)
                
                arrayOfOctaves.append(octaveShift(type: thisType!, size: thisSize!, number: thisNumber!, measureIndex: newMeasureIndex, startEndPointX: thisStartEndXPos!))
                
                if e >= octaveShiftArray.count-1 {
                    octaveShiftArray.append(contentsOf: arrayOfOctaves)
                }
            }
        }
        if arpeggioArray.count >= 1 {
            var arrayOfArpeggios = [arpeggio]()
            
            for a in repeatStartInfo.arpeggioArrayIndex...arpeggioArray.count-1 {
                let thisMeasureIndex = arpeggioArray[a].measureIndex
                let thisXPos = arpeggioArray[a].xPos
                let thisYPos = arpeggioArray[a].yPos
                let thisStaff = arpeggioArray[a].staff
                let newMeasureIndex = oldMeasureNumber + (thisMeasureIndex! - repeatStartInfo.measureNumber)
                
                arrayOfArpeggios.append(arpeggio(measureIndex: newMeasureIndex, xPos: thisXPos!, yPos: thisYPos!, staff: thisStaff!))
                
                if a >= arpeggioArray.count-1 {
                    arpeggioArray.append(contentsOf: arrayOfArpeggios)
                }
            }
        }
        if tieArray.count >= 1 {
            var arrayOfTies = [nameNPos]()
            
            for t in repeatStartInfo.tieArrayIndex...tieArray.count-1 {
                let thisName = tieArray[t].name
                let thisXPos1 = tieArray[t].x1Pos
                let thisXPos2 = tieArray[t].x2Pos
                let thisYPos = tieArray[t].yPos
                
                let newXPos1 = thisXPos1! + (oldTodoSongWidth-repeatStartInfo.todoSongWidth) + CGFloat(measureWidthArray[repeatStartInfo.measureNumber])
                let newXPos2 = thisXPos2! + (oldTodoSongWidth-repeatStartInfo.todoSongWidth) + CGFloat(measureWidthArray[repeatStartInfo.measureNumber])
                
                arrayOfTies.append(nameNPos(name: thisName!, x1Pos: newXPos1, x2Pos: newXPos2, yPos: thisYPos!))
                
                if t >= tieArray.count-1 {
                    tieArray.append(contentsOf: arrayOfTies)
                }
            }
        }
        
    }
    func noteClusters() {
        if noteClusterArray.count < 1 {
            noteClusterArray.append(note(notePos: notePos!, noteType: noteType, noteStem: noteStem, noteStemLength: noteStemLength, notePitch: noteNumber, noteDuration: noteDuration, noteAlter: noteAlter, noteStep: noteStep, noteStaff: noteStaff, noteDot: noteDot, noteTuplet: noteTuplet, noteGrace: isGraceNote, notePlay: playNote, beam1: beam1, beam2: beam2, beam3: beam3, beam4: beam4))
        } else {
            
            if isChord {
                isChord = false
                
                noteClusterArray.append(note(notePos: notePos!, noteType: noteType, noteStem: noteStem, noteStemLength: noteStemLength, notePitch: noteNumber, noteDuration: noteDuration, noteAlter: noteAlter, noteStep: noteStep, noteStaff: noteStaff, noteDot: noteDot, noteTuplet: noteTuplet, noteGrace: isGraceNote, notePlay: playNote, beam1: beam1, beam2: beam2, beam3: beam3, beam4: beam4))
                
            } else {
                changeStems()
            }
        }
    }
    func changeStems() {
        if noteClusterArray.count >= 2 {
            
            if noteClusterArray[noteClusterArray.count - 1].noteStem == "up" {
                
                findHighestNoteInCluster()
                findClusterBeams()
                
                for i in 0...noteClusterArray.count - 1 {
                    
                    let noteIndex: Int = noteClusterArray[i].notePitch!
                    let highestNote = noteClusterArray[highestNoteInCluster]
                    let thisNote = noteClusterArray[i]
                    
                    let oldNotePos: CGPoint = noteArray[noteIndex].notePos
                    let oldNoteType: String = noteArray[noteIndex].noteType
                    let oldNotePitch: Int = noteArray[noteIndex].notePitch
                    let oldNoteDuration: Int = noteArray[noteIndex].noteDuration
                    let oldNoteAlter: Int = noteArray[noteIndex].noteAlter
                    let oldNoteStep: String = noteArray[noteIndex].noteStep
                    let oldNoteTuplet: String = noteArray[noteIndex].noteTuplet
                    let oldNoteDot: Bool = noteArray[noteIndex].noteDot!
                    let oldNoteGrace: Bool = noteArray[noteIndex].noteGrace!
                    let oldNotePlay: Bool = noteArray[noteIndex].notePlay!
                    
                    var NewNoteStaff: Int = 0
                    if noteClusterArray[noteClusterArray.count - 1].noteStaff == 1 {
                        NewNoteStaff = 1
                    } else if noteClusterArray[noteClusterArray.count - 1].noteStaff == 2 {
                        NewNoteStaff = 2
                    }
                    
                    
                    if i > 0 {
                        var extraStem: CGFloat = 38.0
                        
                        if noteClusterArray[i].notePos!.y < noteClusterArray[i - 1].notePos!.y {
                            extraStem = noteClusterArray[i - 1].notePos!.y - noteClusterArray[i].notePos!.y
                        } else {
                            extraStem = noteClusterArray[i].notePos!.y - noteClusterArray[i - 1].notePos!.y
                        }
                        
                        noteStemLength = extraStem + 8
                    }
                    
                    if i == highestNoteInCluster {
                        noteArray[noteIndex] = note(notePos: oldNotePos, noteType: oldNoteType, noteStem: "up", noteStemLength: noteStemLength, notePitch: oldNotePitch, noteDuration: oldNoteDuration, noteAlter: oldNoteAlter, noteStep: oldNoteStep, noteStaff: NewNoteStaff, noteDot: oldNoteDot, noteTuplet: oldNoteTuplet, noteGrace: oldNoteGrace, notePlay: oldNotePlay, beam1: clusterBeam1, beam2: clusterBeam2, beam3: clusterBeam3, beam4: clusterBeam4)
                        
                    } else {
                        
                        if thisNote.notePos!.x == highestNote.notePos!.x {
                            noteArray[noteIndex] = note(notePos: oldNotePos, noteType: oldNoteType, noteStem: "upPlain", noteStemLength: noteStemLength, notePitch: oldNotePitch, noteDuration: oldNoteDuration, noteAlter: oldNoteAlter, noteStep: oldNoteStep, noteStaff: NewNoteStaff, noteDot: oldNoteDot, noteTuplet: oldNoteTuplet, noteGrace: oldNoteGrace, notePlay: oldNotePlay, beam1: "", beam2: "", beam3: "", beam4: "")
                        } else if thisNote.notePos!.x > highestNote.notePos!.x && thisNote.notePos!.y < highestNote.notePos!.y {
                            noteArray[noteIndex] = note(notePos: oldNotePos, noteType: oldNoteType, noteStem: "none", noteStemLength: noteStemLength, notePitch: oldNotePitch, noteDuration: oldNoteDuration, noteAlter: oldNoteAlter, noteStep: oldNoteStep, noteStaff: NewNoteStaff, noteDot: oldNoteDot, noteTuplet: oldNoteTuplet, noteGrace: oldNoteGrace, notePlay: oldNotePlay, beam1: "", beam2: "", beam3: "", beam4: "")
                        } else if thisNote.notePos!.x > highestNote.notePos!.x && thisNote.notePos!.y > highestNote.notePos!.y {
                            noteArray[noteIndex] = note(notePos: oldNotePos, noteType: oldNoteType, noteStem: "upLeftPlain", noteStemLength: noteStemLength, notePitch: oldNotePitch, noteDuration: oldNoteDuration, noteAlter: oldNoteAlter, noteStep: oldNoteStep, noteStaff: NewNoteStaff, noteDot: oldNoteDot, noteTuplet: oldNoteTuplet, noteGrace: oldNoteGrace, notePlay: oldNotePlay, beam1: "", beam2: "", beam3: "", beam4: "")
                        } else {
                            noteArray[noteIndex] = note(notePos: oldNotePos, noteType: oldNoteType, noteStem: "upPlain", noteStemLength: noteStemLength, notePitch: oldNotePitch, noteDuration: oldNoteDuration, noteAlter: oldNoteAlter, noteStep: oldNoteStep, noteStaff: NewNoteStaff, noteDot: oldNoteDot, noteTuplet: oldNoteTuplet, noteGrace: oldNoteGrace, notePlay: oldNotePlay, beam1: "", beam2: "", beam3: "", beam4: "")
                        }
                    }
                }
                
            } else if noteClusterArray[noteClusterArray.count - 1].noteStem == "down" {
                
                findLowestNoteInCluster()
                findClusterBeams()
                
                for i in 0...noteClusterArray.count - 1 {
                    
                    let noteIndex: Int = noteClusterArray[i].notePitch!
                    let lowestNote = noteClusterArray[lowestNoteInCluster]
                    let thisNote = noteClusterArray[i]
                    
                    let oldNotePos: CGPoint = noteArray[noteIndex].notePos!
                    let oldNoteType: String = noteArray[noteIndex].noteType!
                    let oldNotePitch: Int = noteArray[noteIndex].notePitch!
                    let oldNoteDuration: Int = noteArray[noteIndex].noteDuration!
                    let oldNoteAlter: Int = noteArray[noteIndex].noteAlter!
                    let oldNoteStep: String = noteArray[noteIndex].noteStep!
                    let oldNoteTuplet: String = noteArray[noteIndex].noteTuplet
                    let oldNoteDot: Bool = noteArray[noteIndex].noteDot!
                    let oldNoteGrace: Bool = noteArray[noteIndex].noteGrace!
                    let oldNotePlay: Bool = noteArray[noteIndex].notePlay!
                    
                    var NewNoteStaff: Int = 0
                    if noteClusterArray[noteClusterArray.count - 1].noteStaff == 1 {
                        NewNoteStaff = 1
                    } else if noteClusterArray[noteClusterArray.count - 1].noteStaff == 2{
                        NewNoteStaff = 2
                    }
                    
                    
                    if i > 0 {
                        var extraStem: CGFloat = 38.0
                        
                        if noteClusterArray[i].notePos!.y > noteClusterArray[i - 1].notePos!.y {
                            extraStem = noteClusterArray[i].notePos!.y - noteClusterArray[i - 1].notePos!.y
                        } else {
                            extraStem = noteClusterArray[i - 1].notePos!.y - noteClusterArray[i].notePos!.y
                        }
                        
                        noteStemLength = extraStem + 8
                    }
                    
                    if i == lowestNoteInCluster {
                        noteArray[noteIndex] = note(notePos: oldNotePos, noteType: oldNoteType, noteStem: "down", noteStemLength: noteStemLength, notePitch: oldNotePitch, noteDuration: oldNoteDuration, noteAlter: oldNoteAlter, noteStep: oldNoteStep, noteStaff: NewNoteStaff, noteDot: oldNoteDot, noteTuplet: oldNoteTuplet, noteGrace: oldNoteGrace, notePlay: oldNotePlay, beam1: clusterBeam1, beam2: clusterBeam2, beam3: clusterBeam3, beam4: clusterBeam4)
                        
                    } else {
                        
                        if thisNote.notePos!.x == lowestNote.notePos!.x {
                            noteArray[noteIndex] = note(notePos: oldNotePos, noteType: oldNoteType, noteStem: "downPlain", noteStemLength: noteStemLength, notePitch: oldNotePitch, noteDuration: oldNoteDuration, noteAlter: oldNoteAlter, noteStep: oldNoteStep, noteStaff: NewNoteStaff, noteDot: oldNoteDot, noteTuplet: oldNoteTuplet, noteGrace: oldNoteGrace, notePlay: oldNotePlay, beam1: "", beam2: "", beam3: "", beam4: "")
                        } else if thisNote.notePos!.x < lowestNote.notePos!.x && thisNote.notePos!.y > lowestNote.notePos!.y {
                            noteArray[noteIndex] = note(notePos: oldNotePos, noteType: oldNoteType, noteStem: "none", noteStemLength: noteStemLength, notePitch: oldNotePitch, noteDuration: oldNoteDuration, noteAlter: oldNoteAlter, noteStep: oldNoteStep, noteStaff: NewNoteStaff, noteDot: oldNoteDot, noteTuplet: oldNoteTuplet, noteGrace: oldNoteGrace, notePlay: oldNotePlay, beam1: "", beam2: "", beam3: "", beam4: "")
                        } else if thisNote.notePos!.x < lowestNote.notePos!.x && thisNote.notePos!.y < lowestNote.notePos!.y {
                            noteArray[noteIndex] = note(notePos: oldNotePos, noteType: oldNoteType, noteStem: "downRightPlain", noteStemLength: noteStemLength, notePitch: oldNotePitch, noteDuration: oldNoteDuration, noteAlter: oldNoteAlter, noteStep: oldNoteStep, noteStaff: NewNoteStaff, noteDot: oldNoteDot, noteTuplet: oldNoteTuplet, noteGrace: oldNoteGrace, notePlay: oldNotePlay, beam1: "", beam2: "", beam3: "", beam4: "")
                        } else {
                            noteArray[noteIndex] = note(notePos: oldNotePos, noteType: oldNoteType, noteStem: "downPlain", noteStemLength: noteStemLength, notePitch: oldNotePitch, noteDuration: oldNoteDuration, noteAlter: oldNoteAlter, noteStep: oldNoteStep, noteStaff: NewNoteStaff, noteDot: oldNoteDot, noteTuplet: oldNoteTuplet, noteGrace: oldNoteGrace, notePlay: oldNotePlay, beam1: "", beam2: "", beam3: "", beam4: "")
                        }
                    }
                }
            }
        }
        
        noteClusterArray.removeAll()
        lowestNoteInCluster = 0
        highestNoteInCluster = 0
        clusterBeam1 = ""
        clusterBeam2 = ""
        clusterBeam3 = ""
        clusterBeam4 = ""
        
        noteClusterArray.append(note(notePos: notePos!, noteType: noteType, noteStem: noteStem, noteStemLength: noteStemLength, notePitch: noteNumber, noteDuration: noteDuration, noteAlter: noteAlter, noteStep: noteStep, noteStaff: noteStaff, noteDot: noteDot, noteTuplet: noteTuplet, noteGrace: isGraceNote, notePlay: playNote, beam1: beam1, beam2: beam2, beam3: beam3, beam4: beam4))
    }
    
    
    
    var lowestNoteInCluster: Int = 0
    var highestNoteInCluster: Int = 0
    var clusterBeam1: String = ""
    var clusterBeam2: String = ""
    var clusterBeam3: String = ""
    var clusterBeam4: String = ""
    
    func findLowestNoteInCluster() {
        for i in 0...noteClusterArray.count - 1 {
            let noteFromCluster: note = noteClusterArray[lowestNoteInCluster]
            
            if noteClusterArray[i].notePos!.x >= (noteFromCluster.notePos?.x)! + 2.0 {
                lowestNoteInCluster = Int(i)
            }
            if noteClusterArray[i].notePos!.y >= (noteFromCluster.notePos?.y)! && noteClusterArray[i].notePos!.x >= (noteFromCluster.notePos?.x)! {
                lowestNoteInCluster = Int(i)
            }
        }
    }
    func findHighestNoteInCluster() {
        for i in 0...noteClusterArray.count - 1 {
            let noteFromCluster: note = noteClusterArray[highestNoteInCluster]
            
            if noteClusterArray[i].notePos!.x <= (noteFromCluster.notePos?.x)! + 2.0 {
                highestNoteInCluster = Int(i)
            }
            if noteClusterArray[i].notePos!.y <= (noteFromCluster.notePos?.y)! && noteClusterArray[i].notePos!.x <= (noteFromCluster.notePos?.x)! {
                highestNoteInCluster = Int(i)
            }
        }
    }
    func findClusterBeams() {
        for i in 0...noteClusterArray.count - 1 {
            
            let noteIndex: Int = noteClusterArray[i].notePitch!
            
            let oldNoteBeam1: String = noteArray[noteIndex].beam1!
            let oldNoteBeam2: String = noteArray[noteIndex].beam2!
            let oldNoteBeam3: String = noteArray[noteIndex].beam3!
            let oldNoteBeam4: String = noteArray[noteIndex].beam4!
            
            if oldNoteBeam1 == "begin" || oldNoteBeam1 == "continue" || oldNoteBeam1 == "end"   {
                clusterBeam1 = oldNoteBeam1
            }
            if oldNoteBeam2 == "begin" || oldNoteBeam2 == "continue" || oldNoteBeam2 == "end"   {
                clusterBeam2 = oldNoteBeam2
            }
            if oldNoteBeam3 == "begin" || oldNoteBeam3 == "continue" || oldNoteBeam3 == "end"   {
                clusterBeam3 = oldNoteBeam3
            }
            if oldNoteBeam4 == "begin" || oldNoteBeam4 == "continue" || oldNoteBeam4 == "end"   {
                clusterBeam4 = oldNoteBeam4
            }
        }
    }
    
    
    
    
    // MARK: DRAWING
    func setupKeySig() {
        //SHARPS
        if fifths == 0 {
            setTimeSig(40)
            keySigViewWidth = 65
            keySigWidthContraint.constant = keySigViewWidth!
            drawKeySig(keySigViewWidth!)
        } else if fifths == 1 {
            setTimeSig(50)
            keySigViewWidth = 75
            keySigWidthContraint.constant = keySigViewWidth!
            drawKeySig(keySigViewWidth!)
        } else if fifths == 2 {
            setTimeSig(60)
            keySigViewWidth = 85
            keySigWidthContraint.constant = keySigViewWidth!
            drawKeySig(keySigViewWidth!)
        } else if fifths == 3 {
            setTimeSig(70)
            keySigViewWidth = 95
            keySigWidthContraint.constant = keySigViewWidth!
            drawKeySig(keySigViewWidth!)
        } else if fifths == 4 {
            setTimeSig(80)
            keySigViewWidth = 105
            keySigWidthContraint.constant = keySigViewWidth!
            drawKeySig(keySigViewWidth!)
        } else if fifths == 5 {
            setTimeSig(90)
            keySigViewWidth = 115
            keySigWidthContraint.constant = keySigViewWidth!
            drawKeySig(keySigViewWidth!)
        } else if fifths == 6  {
            setTimeSig(100)
            keySigViewWidth = 125
            keySigWidthContraint.constant = keySigViewWidth!
            drawKeySig(keySigViewWidth!)
        } else if fifths == 7  {
            setTimeSig(110)
            keySigViewWidth = 135
            keySigWidthContraint.constant = keySigViewWidth!
            drawKeySig(keySigViewWidth!)
        }
            //FLATS
        else if fifths == -1 {
            setTimeSig(50)
            keySigViewWidth = 75
            keySigWidthContraint.constant = keySigViewWidth!
            drawKeySig(keySigViewWidth!)
        } else if fifths == -2 {
            setTimeSig(58)
            keySigViewWidth = 83
            keySigWidthContraint.constant = keySigViewWidth!
            drawKeySig(keySigViewWidth!)
        } else if fifths == -3 {
            setTimeSig(66)
            keySigViewWidth = 91
            keySigWidthContraint.constant = keySigViewWidth!
            drawKeySig(keySigViewWidth!)
        } else if fifths == -4 {
            setTimeSig(74)
            keySigViewWidth = 99
            keySigWidthContraint.constant = keySigViewWidth!
            drawKeySig(keySigViewWidth!)
        } else if fifths == -5 {
            setTimeSig(82)
            keySigViewWidth = 107
            keySigWidthContraint.constant = keySigViewWidth!
            drawKeySig(keySigViewWidth!)
        } else if fifths == -6 {
            setTimeSig(90)
            keySigViewWidth = 115
            keySigWidthContraint.constant = keySigViewWidth!
            drawKeySig(keySigViewWidth!)
        } else if fifths == -7 {
            setTimeSig(98)
            keySigViewWidth = 123
            keySigWidthContraint.constant = keySigViewWidth!
            drawKeySig(keySigViewWidth!)
        }
            //DEFAULT NO SHARP/FLATS
        else {
            setTimeSig(40)
            keySigViewWidth = 65
            keySigWidthContraint.constant = keySigViewWidth!
            drawKeySig(keySigViewWidth!)
        }
        
        ///keysig shadow y width
        keySigWidthContraint.constant = keySigViewWidth!
        keySigView.layer.shadowColor = UIColor.black.cgColor
        keySigView.layer.shadowOpacity = 0.75
        keySigView.layer.shadowOffset = CGSize.zero
        keySigView.layer.shadowRadius = 5
        
        setClefs()
        
    }
    func setTimeSig(_ fifthsOffset: CGFloat) {
        for i in 1...2 {
            
            //BEATS
            
            var beatsImg: UIImageView?
            if beats == 1 {
                beatsImg = UIImageView(image: UIImage(named: "time1"))
            } else if beats == 2 {
                beatsImg = UIImageView(image: UIImage(named: "time2"))
            }  else if beats == 3 {
                beatsImg = UIImageView(image: UIImage(named: "time3"))
            }  else if beats == 4 {
                beatsImg = UIImageView(image: UIImage(named: "time4"))
            }  else if beats == 5 {
                beatsImg = UIImageView(image: UIImage(named: "time5"))
            }  else if beats == 6 {
                beatsImg = UIImageView(image: UIImage(named: "time6"))
            }  else if beats == 7 {
                beatsImg = UIImageView(image: UIImage(named: "time7"))
            }  else if beats == 8 {
                beatsImg = UIImageView(image: UIImage(named: "time8"))
            }  else if beats == 9 {
                beatsImg = UIImageView(image: UIImage(named: "time9"))
            }  else if beats == 10 {
                beatsImg = UIImageView(image: UIImage(named: "time10"))
            }  else if beats == 12 {
                beatsImg = UIImageView(image: UIImage(named: "time12"))
            } else {
                beatsImg = UIImageView(image: UIImage(named: "time4"))
            }
            
            //BEAT TYPE
            
            var beatTypeImg: UIImageView?
            if beatType == 1 {
                beatTypeImg = UIImageView(image: UIImage(named: "time1"))
            } else if beatType == 2 {
                beatTypeImg = UIImageView(image: UIImage(named: "time2"))
            }  else if beatType == 3 {
                beatTypeImg = UIImageView(image: UIImage(named: "time3"))
            }  else if beatType == 4 {
                beatTypeImg = UIImageView(image: UIImage(named: "time4"))
            }  else if beatType == 5 {
                beatTypeImg = UIImageView(image: UIImage(named: "time5"))
            }  else if beatType == 6 {
                beatTypeImg = UIImageView(image: UIImage(named: "time6"))
            }  else if beatType == 7 {
                beatTypeImg = UIImageView(image: UIImage(named: "time7"))
            }  else if beatType == 8 {
                beatTypeImg = UIImageView(image: UIImage(named: "time8"))
            }  else if beatType == 9 {
                beatTypeImg = UIImageView(image: UIImage(named: "time9"))
            }  else if beatType == 10 {
                beatTypeImg = UIImageView(image: UIImage(named: "time10"))
            }  else if beatType == 12 {
                beatTypeImg = UIImageView(image: UIImage(named: "time12"))
            }  else if beatType == 16 {
                beatTypeImg = UIImageView(image: UIImage(named: "time16"))
            }  else if beatType == 32 {
                beatTypeImg = UIImageView(image: UIImage(named: "time32"))
            } else {
                beatTypeImg = UIImageView(image: UIImage(named: "time4"))
            }
            
            if i == 1 {
                beatsImg!.frame = CGRect(x: fifthsOffset - 7, y: self.view.bounds.height/2 - averageStaffDistance/2 - 40.0, width: 30, height: 20)
                beatTypeImg!.frame = CGRect(x: fifthsOffset - 7, y: self.view.bounds.height/2 - averageStaffDistance/2 - 20, width: 30, height: 20)
            } else {
                
                beatsImg!.frame = CGRect(x: fifthsOffset - 7, y: self.view.bounds.height/2 + averageStaffDistance/2, width: 30, height: 20)
                beatTypeImg!.frame = CGRect(x: fifthsOffset - 7, y: self.view.bounds.height/2 + averageStaffDistance/2 + 20.0, width: 30, height: 20)
            }
            
            keySigView.addSubview(beatsImg!)
            keySigView.addSubview(beatTypeImg!)
        }
    }
    
    func setClefs() {
        let trebleImage: UIImage = UIImage(named: "trebleClef")!
        let bassImage: UIImage = UIImage(named: "bassClef")!
        
        //CLEF 1
        if clef1 == "G" {
            let clef1Img = UIImageView(image: trebleImage)
            clef1Img.frame = CGRect(x: 5, y: self.view.bounds.height/2 - averageStaffDistance/2 - 54.5, width: 24, height: 70)
            keySigView.addSubview(clef1Img)
        } else if clef1 == "F" {
            let clef1Img = UIImageView(image: trebleImage)
            clef1Img.frame = CGRect(x: 5, y: self.view.bounds.height/2 - averageStaffDistance/2 - 54.5, width: 24, height: 30)
            keySigView.addSubview(clef1Img)
        } else {
            let clef1Img = UIImageView(image: trebleImage)
            clef1Img.frame = CGRect(x: 5, y: self.view.bounds.height/2 - averageStaffDistance/2 - 54.5, width: 24, height: 70)
            keySigView.addSubview(clef1Img)
        }
        
        //CLEF 2
        if clef2 == "F" {
            let clef2Img = UIImageView(image: bassImage)
            clef2Img.frame = CGRect(x: 5, y: self.view.bounds.height/2 + averageStaffDistance/2, width: 24, height: 30)
            keySigView.addSubview(clef2Img)
        } else if clef2 == "G" {
            let clef2Img = UIImageView(image: trebleImage)
            clef2Img.frame = CGRect(x: 5, y: self.view.bounds.height/2 + averageStaffDistance/2 - 13, width: 24, height: 70)
            keySigView.addSubview(clef2Img)
        } else {
            let clef2Img = UIImageView(image: bassImage)
            clef2Img.frame = CGRect(x: 5, y: self.view.bounds.height/2 + averageStaffDistance/2, width: 24, height: 30)
            keySigView.addSubview(clef2Img)
        }
    }
    func drawKeySig(_ keySigWidthFloat: CGFloat) {
        let keySigGraphics: keySig = keySig(frame: CGRect(x: 0, y: 0, width: keySigWidthFloat, height: self.view.bounds.height))
        
        keySigGraphics.clef1 = clef1
        keySigGraphics.clef2 = clef2
        keySigGraphics.fifths = fifths
        
        keySigGraphics.keySigWidth = keySigWidthFloat
        keySigGraphics.averageStaffDistance = averageStaffDistance
        keySigGraphics.backgroundColor = UIColor.clear
        keySigView.addSubview(keySigGraphics)
    }
    
    func drawMeasures() {
        
        for i in 0...measureWidthArray.count-1 {
            if i == 0 {
                currentDrawMeasureXPos += firstMeasureOffset
            }
            
            let drawMeasureWidth = CGFloat(measureWidthArray[i])
            
            let measureView = measure(frame: CGRect(x: currentDrawMeasureXPos, y: 0, width: drawMeasureWidth, height: self.view.bounds.height))
            measureView.measureWidth = drawMeasureWidth
            measureView.averageStaffDistance = averageStaffDistance
            measureView.fifths = fifths
            measureView.backgroundColor = UIColor.clear
            
            
            //OCTAVE SHIFTS
            if octaveShiftArray.count >= 1 {
                for a in 0...octaveShiftArray.count-1 {
                    let thisOctaveShift = octaveShiftArray[a]
                    
                    if thisOctaveShift.measureIndex == i {
                        measureView.octaveShiftArray.append(thisOctaveShift)
                    }
                }
            }
            //APEGGIOS
            if arpeggioArray.count >= 1 {
                for b in 0...arpeggioArray.count-1 {
                    let thisArpeggioNote = arpeggioArray[b]
                    
                    if thisArpeggioNote.measureIndex == i {
                        measureView.arpeggioArray.append(thisArpeggioNote)
                    }
                }
            }
            
            if i == measureWidthArray.count - 1 {
                measureView.isLastMeasure = true
            }
            if i > 0 {
                let measureTodoNotes: Int = noteNumberInMeasureArray[i] - 1
                let previousMeasureTodo: Int = noteNumberInMeasureArray[i-1]
                if measureTodoNotes-previousMeasureTodo >= 0 {
                    measureView.thisMeasuresNoteArray.append(contentsOf: noteArray[previousMeasureTodo...measureTodoNotes])
                }
                if (restNumberInMeasureArray[i] - restNumberInMeasureArray[i - 1]) >= 1 {
                    let measureTodoRests: Int = restNumberInMeasureArray[i] - 1
                    let previousMeasureRestTodo: Int = restNumberInMeasureArray[i-1]
                    measureView.thisMeasuresRestArray.append(contentsOf: restArray[previousMeasureRestTodo...measureTodoRests])
                }
                ScrollerScrollView.addSubview(measureView)
                currentDrawMeasureXPos += drawMeasureWidth
                
            } else if i < 1 {
                let measureTodoNotes: Int = noteNumberInMeasureArray[i] - 1
                measureView.thisMeasuresNoteArray.append(contentsOf: noteArray[0...measureTodoNotes])
                
                if restNumberInMeasureArray[i] >= 1 {
                    let restMeasureTodoNotes: Int = restNumberInMeasureArray[i] - 1
                    measureView.thisMeasuresRestArray.append(contentsOf: restArray[0...restMeasureTodoNotes])
                }
                ScrollerScrollView.addSubview(measureView)
                currentDrawMeasureXPos += drawMeasureWidth
            }
        }
    }
    func drawCrap() {
        //DRAW TIES
        if tieArray.count >= 1 {
            for i in 0...tieArray.count-1 {
                let thisTie = tieArray[i]
                
                let tieWidth: CGFloat = thisTie.x2Pos-thisTie.x1Pos
                let tieHeight: CGFloat = 10
                let tieXPos: CGFloat = thisTie.x1Pos
                let tieYPos: CGFloat = thisTie.yPos - tieHeight
                let tieView = tie(frame: CGRect(x: tieXPos, y: tieYPos, width: tieWidth, height: tieHeight))
                tieView.backgroundColor = UIColor.clear
                ScrollerScrollView.addSubview(tieView)
            }
        }
        //DRAW SYMBOLS AND ALL THAT STUFF
    }
    
    func findPitch() {
        let notePitchChecker: notePitchClass = notePitchClass()
        notePitchChecker.noteStep = noteStep
        notePitchChecker.noteOctave = noteOctave
        notePitchChecker.noteAlter = noteAlter
        
        notePitch = notePitchChecker.findNoteNumber()
    }
    func cancelAlters() {
        if fifths == 1 {
            if noteStep == "F" {
                noteAlter = 5
            }
        } else if fifths == 2 {
            if noteStep == "F" || noteStep == "C" {
                noteAlter = 5
            }
        } else if fifths == 3 {
            if noteStep == "F" || noteStep == "C" || noteStep == "G" {
                noteAlter = 5
            }
        } else if fifths == 4 {
            if noteStep == "F" || noteStep == "C" || noteStep == "G" || noteStep == "D" {
                noteAlter = 5
            }
        } else if fifths == 5 {
            if noteStep == "F" || noteStep == "C" || noteStep == "G" || noteStep == "D" || noteStep == "A" {
                noteAlter = 5
            }
        } else if fifths == 6 {
            if noteStep == "F" || noteStep == "C" || noteStep == "G" || noteStep == "D" || noteStep == "A" || noteStep == "E" {
                noteAlter = 5
            }
        } else if fifths == 7 {
            if noteStep == "F" || noteStep == "C" || noteStep == "G" || noteStep == "D" || noteStep == "A" || noteStep == "E" || noteStep == "B" {
                noteAlter = 5
            }
        }
        
        if fifths == -1 {
            if noteStep == "B" {
                noteAlter = 5
            }
        } else if fifths == -2 {
            if noteStep == "B" || noteStep == "E" {
                noteAlter = 5
            }
        } else if fifths == -3 {
            if noteStep == "B" || noteStep == "E" || noteStep == "A" {
                noteAlter = 5
            }
        } else if fifths == -4 {
            if noteStep == "B" || noteStep == "E" || noteStep == "A" || noteStep == "D" {
                noteAlter = 5
            }
        } else if fifths == -5 {
            if noteStep == "B" || noteStep == "E" || noteStep == "A" || noteStep == "D" || noteStep == "G" {
                noteAlter = 5
            }
        } else if fifths == -6 {
            if noteStep == "B" || noteStep == "E" || noteStep == "A" || noteStep == "D" || noteStep == "G" || noteStep == "C" {
                noteAlter = 5
            }
        } else if fifths == -7 {
            if noteStep == "B" || noteStep == "E" || noteStep == "A" || noteStep == "D" || noteStep == "G" || noteStep == "C" || noteStep == "F" {
                noteAlter = 5
            }
        }
        
        if noteNatural {
            noteAlter = 0
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
