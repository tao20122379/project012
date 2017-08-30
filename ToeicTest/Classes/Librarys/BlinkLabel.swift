//
//  BlinkLabel.swift
//  ToeicTest
//
//  Created by khactao on 4/30/17.
//
//

import Foundation

open class BlinkLabel : UILabel {
    
    /**
     Tells the label to start blinking.
     */
    open func startBlinking() {
        let options : UIViewAnimationOptions = .repeat
        UIView.animate(withDuration: 0.7, delay:0.0, options:options, animations: {
            self.alpha = 0.3
            }, completion: nil)
    }
    
    /**
     Tells the label to stop blinking.
     */
    open func stopBlinking() {
        alpha = 1
        layer.removeAllAnimations()
    }
}
