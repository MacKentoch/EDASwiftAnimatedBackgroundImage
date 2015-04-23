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
    
    enum direction
    {
        case toRight
        case toLeft
    }
    
    var imageBackGround : UIImage!
    var ZERO_TRAILLING_CONSTRAINT : CGFloat!
    var timer1 : NSTimer? = nil
    var FlagPauseAnimation : Bool? = nil
    var lastPosToReach : CGFloat?
    var lastDuration : NSTimeInterval?
    var lastDirection : direction?
    var secondElapse : Int?
    var justWakeUp :Bool?
    

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var backImageTrailingConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Init
        lastPosToReach = -400
        lastDuration = 30.0
        lastDirection = direction.toLeft
        secondElapse = 0
        justWakeUp = true
        
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
    
    //MARK: White StatusBar : better look
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
        
        lastPosToReach =  self.backImageTrailingConstraint.constant

        PauseLayer(self.view.layer)
    }
    
    
    func resumeanimation(notification :NSNotification)
    {

        if  justWakeUp == true
        {
            self.backImageTrailingConstraint.constant = ZERO_TRAILLING_CONSTRAINT
            self.secondElapse = 0
        }
        else
        {
          self.backImageTrailingConstraint.constant = -CGFloat(10 * (40 - self.secondElapse!))
            self.secondElapse = 0
        }
         justWakeUp = false
        //
        
        //self.backImageTrailingConstraint.constant = ZERO_TRAILLING_CONSTRAINT - CGFloat(10 * (40 - self.secondElapse!))
        //self.view.layoutIfNeeded()
        
        self.secondElapse = 0

        
        if let letimer = timer1
        {
            if letimer.valid
            {
                println("timer1 is in valid state while resume")
            }
        }
        else
        {
            //all is OK let's start another timer :
            timer1 = NSTimer(timeInterval: 1.0, target: self, selector: Selector("AnimationBackGroundParSeconde"), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer1!, forMode:NSDefaultRunLoopMode)
        }
        
    }
    
    
    
    func AnimationBackGroundParSeconde()
    {
        println("-> animation for 1 second")

        var duration = 40.0 //-  NSTimeInterval(self.secondElapse!)//lastDuration
        //self.secondElapse = 0
        
        self.backImageTrailingConstraint.constant = -400
        
        println("Objective constraint.constant: \(self.backImageTrailingConstraint.constant)" +
                            "\nFor duration (in seconds) : \(duration)")
        
       
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
                println("      ... 1 sec elapsed" +
                        "\ncurrent constraint constant : \(self.lastPosToReach)\n" +
                        "\ncurrent time elapsed since animation started : \(self.secondElapse)\n" +
                        "\n")
                
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

