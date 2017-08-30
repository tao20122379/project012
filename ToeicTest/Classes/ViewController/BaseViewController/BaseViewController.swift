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
        Constants.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(BaseViewController.updateTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(Constants.timer!, forMode: RunLoopMode.commonModes)
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
    internal func createLeftBarButton(_ imageName:String, target:AnyObject, sel:Selector) {
        let image: UIImage = UIImage(named: imageName)!
        let leftButton: UIButton = UIButton(type: UIButtonType.custom)
        leftButton.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        leftButton.setImage(UIImage(named:imageName), for: UIControlState())
        leftButton.addTarget(target, action: sel, for: UIControlEvents.touchUpInside)
        
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    internal func createLeftBarButtonWithName(_ buttonName: String, target: AnyObject, sel:Selector) {
        let leftButton: UIButton = UIButton(type: UIButtonType.custom)
        leftButton.setTitle(buttonName, for: UIControlState())
        leftButton.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        leftButton.addTarget(target, action: sel, for: UIControlEvents.touchUpInside)
        
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    //MARK: - custom RightBarButtonItem
    internal func createRightBarButton(_ imageName:String, target:AnyObject, sel:Selector) {
        let image: UIImage = UIImage(named: imageName)!
        let rightButton: UIButton = UIButton(type: UIButtonType.custom)
        rightButton.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        rightButton.setImage(UIImage(named:imageName), for: UIControlState())
        rightButton.setTitle("", for: UIControlState())
        rightButton.addTarget(target, action: sel, for: UIControlEvents.touchUpInside)
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    internal func createTranslateButton(_ target: AnyObject) {
        let rightButton: UIButton = UIButton(type: UIButtonType.custom)
        rightButton.setBackgroundImage(UIImage(named: "googleTranslate"), for: UIControlState())
        rightButton.frame = CGRect(x: 0, y: 5, width: 30, height: 30)
        rightButton.addTarget(target, action: #selector(showTranslate), for: UIControlEvents.touchUpInside)
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func showTranslate() {
        Constants.showTranslate()
    }
    
    //MARK: - Action functions
}
