//
//  GrammarMenuCell.swift
//  ToeicTest
//
//  Created by khactao on 4/30/17.
//
//

import UIKit

class GrammarMenuCell: UITableViewCell {

    // MARK: -  IBOutleft
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - init
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - function
    func settitle(_ title: String) {
        titleLabel.text! = title
    }
}
