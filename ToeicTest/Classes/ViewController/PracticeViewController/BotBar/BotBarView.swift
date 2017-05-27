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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberTrueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Constants.setLayer(checkButton)
        checkButton.setTitle(Constants.LANGTEXT("PRACTICE_CHECK"), forState: .Normal)
        titleLabel.text = Constants.LANGTEXT("PRACTICE_NUMBER_ANSWER")
    }
 
    @IBAction func checkSelected(sender: AnyObject) {
        UIView.animateWithDuration(0.4) { 
            self.titleLabel.alpha = 1
            self.numberTrueLabel.alpha = 1
            self.backgroundColor =  UIColor.colorFromHexString("DEF0A2")
        }
    }
}
