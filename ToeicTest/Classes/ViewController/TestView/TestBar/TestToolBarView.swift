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
        canceTestButton.setTitle(Constants.LANGTEXT("COMMON_CANCEL"), forState: .Normal)
        if Constants.status == TestStatus.test {
            translateButton.hidden = true
        }
    }
    @IBAction func translateSelected(sender: AnyObject) {
        Constants.showTranslate()
    }
}
