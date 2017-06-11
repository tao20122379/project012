//
//  BookTableCell.swift
//  ToeicTest
//
//  Created by khactao on 4/28/17.
//
//

import UIKit

class BookTableCell: UITableViewCell {

    @IBOutlet weak var bookNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initWithData(data: BookModel) {
        bookNameLabel.text = data.name
    }
    
}
