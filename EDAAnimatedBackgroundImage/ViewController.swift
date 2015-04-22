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
        //pour que çà fonctionne il faut : NavigationController.navigationBar.barStyle  = UIBarStyle.Black
        return .LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func stopanimation(notification :NSNotification)
    {
        println("!!!!!!!! stop detecte !!!!!!!!!!")
        FlagPauseAnimation = true
        PauseLayer(self.view.layer)
    }
    
    
    func resumeanimation(notification :NSNotification)
    {
        println("!!!!!!!! resume detecte !!!!!!!!!!")
        self.backImageTrailingConstraint.constant = ZERO_TRAILLING_CONSTRAINT
        if let letimer = timer1
        {
            if letimer.valid
            {
                println("timer1 valid au resume")
            }
        }
        else
        {
            
            timer1 = NSTimer(timeInterval: 1.0, target: self, selector: Selector("AnimationBackGroundParSeconde"), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer1!, forMode:NSDefaultRunLoopMode)
        }
        
    }
    
    
    
    func AnimationBackGroundParSeconde()
    {
        println("-> animation will start")
        let tauxRaffraichissement = CGFloat(0.5)
        let motionRate = (backgroundImageView.frame.width / self.view.frame.size.width) * tauxRaffraichissement
        var offset = self.backImageTrailingConstraint.constant * motionRate
        self.backImageTrailingConstraint.constant = -400
        
        UIView.animateWithDuration(50.0
            , delay: 0.0
            , options: UIViewAnimationOptions.Repeat | UIViewAnimationOptions.Autoreverse
            , animations:
            {
                self.view.layoutIfNeeded()
                self.view.alpha = 1.0
            },
            completion: { finished in
                println("... 1 sec elapsed")
            }
        )
    }
    
    func PauseLayer(layer: CALayer)
    {
        timer1?.invalidate()
        timer1 = nil
    }

    
    

}

