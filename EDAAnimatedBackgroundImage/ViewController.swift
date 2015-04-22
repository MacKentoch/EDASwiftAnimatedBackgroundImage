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
    
    var imageBackGround : UIImage!
    var ZERO_TRAILLING_CONSTRAINT : CGFloat!
    var timer1 : NSTimer? = nil
    var FlagPauseAnimation : Bool? = nil
    

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var backImageTrailingConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        PauseLayer(self.view.layer)
    }
    
    
    func resumeanimation(notification :NSNotification)
    {

        self.backImageTrailingConstraint.constant = ZERO_TRAILLING_CONSTRAINT
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

        
        self.backImageTrailingConstraint.constant = -400
        
        UIView.animateWithDuration(30.0
            , delay: 0.0
            , options: UIViewAnimationOptions.Repeat | UIViewAnimationOptions.Autoreverse
            , animations:
            {
                
                self.view.layoutIfNeeded()
                //layoutIfNeeded is not animated, the trick to animate is to set alpha to 1.0 as it is already
                self.view.alpha = 1.0
            },
            completion: { finished in
                println("      ... 1 sec elapsed")
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

