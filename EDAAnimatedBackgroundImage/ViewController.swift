//
//  ViewController.swift
//  EDAAnimatedBackgroundImage
//
//  Created by MacKentoch on 22/04/2015.
//  Copyright (c) 2015 MacKentoch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let DEFAULT_BACKGROUND_IMAGE = "2801-11"
    let REFERENCE_ANIMATION_DURATION = 40
    let REFERENCE_ANIMATION_FAST_RETURN_DURATION = 3
    let REFERENCE_MAX_TRAILING_CONTRAINT_CONSTANT = -400
    
    
    enum direction
    {
        case toRight
        case toLeft
    }
    
    var REFERENCE_TRAILING_CONTRAINT_CONSTANT_FACTOR : CGFloat!
    var imageBackGround : UIImage!
    var ZERO_TRAILLING_CONSTRAINT : CGFloat!
    var timer1 : NSTimer? = nil
    var FlagPauseAnimation : Bool? = nil
    var lastPosToReach : CGFloat?
    var lastDirection : direction?
    var secondElapse : Int?
    var justStartedApp :Bool?
    

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var backImageTrailingConstraint: NSLayoutConstraint!
    
    
    func initializePorperties()
    {
        //Init : must be called only in viewDidLoad
        lastPosToReach = -400
        lastDirection = direction.toLeft
        secondElapse = 0
        justStartedApp = true
        REFERENCE_TRAILING_CONTRAINT_CONSTANT_FACTOR = CGFloat(fabsf(Float(REFERENCE_MAX_TRAILING_CONTRAINT_CONSTANT / REFERENCE_ANIMATION_DURATION)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializePorperties()

        
        //set your image
        self.imageBackGround = UIImage(named: DEFAULT_BACKGROUND_IMAGE)
        backgroundImageView.image = self.imageBackGround
        
        //init constraint reference as Zero
        self.ZERO_TRAILLING_CONSTRAINT = self.backImageTrailingConstraint.constant
        
        //add observers to stop and resume your animation when application goes background
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resumeanimation:", name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stopanimation:", name: UIApplicationDidEnterBackgroundNotification, object: nil)

    }

    //launch timer to animate your background in viewWillAppear (not viewDidLoad)
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

        timer1 = NSTimer(timeInterval: 1.0, target: self, selector: Selector("AnimationBackGroundParSeconde"), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer1!, forMode:NSDefaultRunLoopMode)
        
    }
    
    //MARK: White StatusBar : just for a better look
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func stopanimation(notification :NSNotification)
    {
        FlagPauseAnimation = true
        PauseLayer(self.view.layer)
    }
    
    
    func resumeanimation(notification :NSNotification)
    {

        if  justStartedApp == true
        {
            //1 st app launch :
            lastDirection = direction.toLeft
            self.backImageTrailingConstraint.constant = ZERO_TRAILLING_CONSTRAINT
            self.secondElapse = 0
        }
        else
        {
            //app has just been resumed :
            
            ///////////////////////////////////////////////////////////////////////////////
            //1- layout backgroundImage as It was "visuallly" before entering backgroung
            ///////////////////////////////////////////////////////////////////////////////
            //  -> trick : it is related to duration and number of seconds elapsed before going background
            //      -> no use to save self.backImageTrailingConstraint.constant : its value does not change during animation (it is just visual)
            
            self.backImageTrailingConstraint.constant = -CGFloat(CGFloat(REFERENCE_TRAILING_CONTRAINT_CONSTANT_FACTOR) * CGFloat((REFERENCE_ANIMATION_DURATION - self.secondElapse!)))
            self.secondElapse = 0
        }
         justStartedApp = false
       
        
        self.secondElapse = 0

        
        if let letimer = timer1
        {
            if letimer.valid
            {
                println("\ntimer1 is in valid state while resume\n")
            }
        }
        else
        {
            println("\ntimer1 is nil, let's start again after a little break at home\n")

            //all is OK let's start another timer :
            timer1 = NSTimer(timeInterval: 1.0, target: self, selector: Selector("AnimationBackGroundParSeconde"), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer1!, forMode:NSDefaultRunLoopMode)
        }
        
    }
    
    func AnimationFastReturnZeroPoint()
    {
        println("\n-> animation zero point return")
        
        
        var duration = NSTimeInterval(REFERENCE_ANIMATION_FAST_RETURN_DURATION)
        self.backImageTrailingConstraint.constant = ZERO_TRAILLING_CONSTRAINT
        
//        println("Objective constraint.constant: \(self.backImageTrailingConstraint.constant)" +
//            "\nFor duration (in seconds) : \(duration)")
        
        UIView.animateWithDuration(duration
            , delay: 0.0
            , options: UIViewAnimationOptions.CurveLinear
            , animations:
            {
                
                self.view.layoutIfNeeded()
                //layoutIfNeeded is not animated, the trick to animate is to set alpha to 1.0 as it is already
                self.view.alpha = 1.0
            },
            completion: { finished in
           
                //resume timer, and start animation per seconds :
                
                self.timer1 = NSTimer(timeInterval: 1.0, target: self, selector: Selector("AnimationBackGroundParSeconde"), userInfo: nil, repeats: true)
                NSRunLoop.mainRunLoop().addTimer(self.timer1!, forMode:NSDefaultRunLoopMode)
                
            }
        )

        
    }
    

    func AnimationBackGroundParSeconde()
    {
        println("\n-> animation for 1 second")
        if self.secondElapse! == 40
        {
            println("##### <-> CHANGE direction #####")
            //self.lastDirection == direction.toLeft ? direction.toLeft : direction.toRight
            
            if self.lastDirection == direction.toLeft
            {
               self.lastDirection = direction.toRight
            }
            else
            {
                self.lastDirection = direction.toLeft
            }

            self.secondElapse = 0
        }
        else
        {
            println("##### -> SAME direction #####")
        }
        var directionString = "from right to left"
        if lastDirection == direction.toRight{
            directionString = "from left to right"
        }
        println("                        DIRECTION : \(directionString)")
        
        
        var duration = NSTimeInterval(REFERENCE_ANIMATION_DURATION)
        self.backImageTrailingConstraint.constant = CGFloat(REFERENCE_MAX_TRAILING_CONTRAINT_CONSTANT)
        
        println(" -- Objective constraint.constant: \(self.backImageTrailingConstraint.constant)" +
                            "\n -- For duration (in seconds) : \(duration)")
       
        UIView.animateWithDuration(duration
            , delay: 0.0
            , options: UIViewAnimationOptions.Repeat | UIViewAnimationOptions.Autoreverse
            , animations:
            {
                
                self.view.layoutIfNeeded()
                //layoutIfNeeded is not animated, the trick to animate is to set alpha to 1.0 as it is already
                self.view.alpha = 1.0
            },
            completion: { finished in
                self.secondElapse = self.secondElapse! + 1
                self.lastPosToReach = self.backImageTrailingConstraint.constant
                //verbose mode vars :
                var refDuration = String(self.REFERENCE_ANIMATION_DURATION)
                var secondBeforeChangeDirection = String(self.REFERENCE_ANIMATION_DURATION - self.secondElapse!)
                
                //here need to slash verboseMessage in multiple parts since all in 1 string would throw "to complex message error" during build
                var verboseMessagePart1 = "      ... 1 sec elapsed" +
                                        "\n -- current constraint constant : \(self.lastPosToReach)" +
                                        "\n -- current time elapsed since animation started in this direction : \(self.secondElapse)"
                
                var verboseMassagePart2 =
                                        "\n   ~~~ as REFERENCE_ANIMATION_DURATION is set to \(refDuration)" +
                                        "\n   ~~~ it means animation will change direction in \(secondBeforeChangeDirection)" +
                                        "\n"
                
                println(verboseMessagePart1 + verboseMassagePart2)
                
            }
        )
        
    }
    
    func PauseLayer(layer: CALayer)
    {
        timer1?.invalidate()
        //invalidation of the timer may be already good but to be sure timer is off :
        timer1 = nil
    }

    
    

}

