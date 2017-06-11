//
//  GrammarMenuCell.swift
//  ToeicTest
//
//  Created by khactao on 4/30/17.
//
//

import UIKit

class GrammarMenuCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func settitle(title: String) {
        titleLabel.text! = title
    }
}
