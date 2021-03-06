//
//  TestToolBarView.swift
//  ToeicTest
//
//  Created by khactao on 4/6/17.
//
//

import UIKit

class TestToolBarView: UIView {

    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var canceTestButton: UIButton!
    @IBOutlet weak var partName: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        Constants.setLayer(canceTestButton)
        canceTestButton.setTitle(Constants.LANGTEXT("COMMON_CANCEL"), for: UIControlState())
        if Constants.status == TestStatus.test {
            translateButton.isHidden = true
        }
    }
    @IBAction func translateSelected(_ sender: AnyObject) {
        Constants.showTranslate()
    }
}
