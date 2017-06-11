//
//  BaseViewController.swift
//  QA Social
//
//  Created by luckymanbk on 6/16/16.
//  Copyright © 2016 Le Thanh Dat. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    func startTimer() {
        Constants.timer?.invalidate()
        Constants.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(BaseViewController.updateTimer), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(Constants.timer!, forMode: NSRunLoopCommonModes)
    }
    
    func stopTimer() {
        Constants.timer?.invalidate()
    }
    
    func updateTimer() {
        showTimer()
            if Constants.second == 0 {
                Constants.second = 59
                Constants.minute -= 1
            }
            if Constants.minute == 0 {
                Constants.minute = 59
                Constants.hours -= 1
            }
            Constants.second -= 1
    }
    
    func showTimer() {
    
    }
    
    func endTest() {
    
    }
    
    //MARK: - custom LeftBarButtonItem
    internal func createLeftBarButton(imageName:String, target:AnyObject, sel:Selector) {
        let image: UIImage = UIImage(named: imageName)!
        let leftButton: UIButton = UIButton(type: UIButtonType.Custom)
        leftButton.frame = CGRectMake(0, 0, image.size.width, image.size.height)
        leftButton.setImage(UIImage(named:imageName), forState: UIControlState.Normal)
        leftButton.addTarget(target, action: sel, forControlEvents: UIControlEvents.TouchUpInside)
        
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    internal func createLeftBarButtonWithName(buttonName: String, target: AnyObject, sel:Selector) {
        let leftButton: UIButton = UIButton(type: UIButtonType.Custom)
        leftButton.setTitle(buttonName, forState: UIControlState.Normal)
        leftButton.frame = CGRectMake(0, 0, 60, 40)
        leftButton.addTarget(target, action: sel, forControlEvents: UIControlEvents.TouchUpInside)
        
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    //MARK: - custom RightBarButtonItem
    internal func createRightBarButton(imageName:String, target:AnyObject, sel:Selector) {
        let image: UIImage = UIImage(named: imageName)!
        let rightButton: UIButton = UIButton(type: UIButtonType.Custom)
        rightButton.frame = CGRectMake(0, 0, image.size.width, image.size.height)
        rightButton.setImage(UIImage(named:imageName), forState: UIControlState.Normal)
        rightButton.setTitle("", forState: UIControlState.Normal)
        rightButton.addTarget(target, action: sel, forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    internal func createTranslateButton(target: AnyObject) {
        let rightButton: UIButton = UIButton(type: UIButtonType.Custom)
        rightButton.setBackgroundImage(UIImage(named: "googleTranslate"), forState: .Normal)
        rightButton.frame = CGRectMake(0, 5, 30, 30)
        rightButton.addTarget(target, action: #selector(showTranslate), forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func showTranslate() {
        Constants.showTranslate()
    }
    
    //MARK: - Action functions
}