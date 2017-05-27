//
//  BlinkLabel.swift
//  ToeicTest
//
//  Created by khactao on 4/30/17.
//
//

import Foundation

public class BlinkLabel : UILabel {
    
    /**
     Tells the label to start blinking.
     */
    public func startBlinking() {
        let options : UIViewAnimationOptions = .Repeat
        UIView.animateWithDuration(0.7, delay:0.0, options:options, animations: {
            self.alpha = 0.3
            }, completion: nil)
    }
    
    /**
     Tells the label to stop blinking.
     */
    public func stopBlinking() {
        alpha = 1
        layer.removeAllAnimations()
    }
}