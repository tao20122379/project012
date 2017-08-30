//
//  ScoreTableCell.swift
//  ToeicTest
//
//  Created by khactao on 4/24/17.
//
//

import UIKit

class ScoreTableCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var scoreListeningLabel: UILabel!
    @IBOutlet weak var scoreReadingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initWith(_ data: ScoreModel) {
        numberLabel.text = String(format: "%i", data.number)
        scoreListeningLabel.text = String(format: "%i", data.scoreListening)
        scoreReadingLabel.text = String(format: "%i", data.scoreReading)
    }
    
}
