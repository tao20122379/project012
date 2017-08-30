//
//  TopBarView.swift
//  ToeicTest
//
//  Created by khactao on 4/29/17.
//
//

import UIKit

class TopBarView: UIView {
    @IBOutlet weak var partLabel: UILabel!
    @IBOutlet weak var canceButton: UIButton!
    @IBOutlet weak var googleTranslateButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        canceButton.setTitle(Constants.LANGTEXT("COMMON_CANCE"), for: UIControlState())
    }
    @IBAction func googleTranslateSelected(_ sender: AnyObject) {
        Constants.showTranslate()
    }
    
}
