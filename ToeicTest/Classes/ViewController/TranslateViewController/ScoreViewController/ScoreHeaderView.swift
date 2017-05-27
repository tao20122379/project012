//
//  ScoreHeaderView.swift
//  ToeicTest
//
//  Created by khactao on 4/24/17.
//
//

import UIKit

class ScoreHeaderView: UIView {
    
    @IBOutlet weak var numbeTrueLabel: UILabel!
    @IBOutlet weak var scoreListeningLabel: UILabel!
    @IBOutlet weak var scoreReadingLabel: UILabel!
    
    override func awakeFromNib() {
        numbeTrueLabel.text = Constants.LANGTEXT("RESULT_NUMBER_TRUE")
        scoreReadingLabel.text = Constants.LANGTEXT("RESULT_SCORE_READING")
        scoreListeningLabel.text = Constants.LANGTEXT("RESULT_SCORE_LISTENING")
    }
}
