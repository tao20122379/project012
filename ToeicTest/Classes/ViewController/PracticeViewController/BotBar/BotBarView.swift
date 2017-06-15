//
//  BotBarView.swift
//  ToeicTest
//
//  Created by khactao on 4/29/17.
//
//

import UIKit

class BotBarView: UIView {


    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var numberTrueLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Constants.setLayer(checkButton)
        Constants.setLayer(backButton)
        checkButton.setTitle(Constants.LANGTEXT("PRACTICE_CHECK"), forState: .Normal)
    }
 
    @IBAction func checkSelected(sender: AnyObject) {
        UIView.animateWithDuration(0.4) { 

            self.numberTrueLabel.alpha = 1
            self.backgroundColor =  UIColor.colorFromHexString("DEF0A2")
        }
    }
}
