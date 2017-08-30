//
//  BottomBarView.swift
//  ToeicTest
//
//  Created by khactao on 4/29/17.
//
//

import UIKit

class BottomBarView: UIView {

    @IBOutlet weak var numberTrueLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        nextButton.setTitle(Constants.LANGTEXT("COMMON_NEXT"), for: UIControlState())
        backButton.setTitle(Constants.LANGTEXT("COMMON_BACK"), for: UIControlState())
    }
}
