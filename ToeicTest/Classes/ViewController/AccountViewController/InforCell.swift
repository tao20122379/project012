//
//  InforCell.swift
//  ToeicTest
//
//  Created by khactao on 5/26/17.
//
//

import UIKit

class InforCell: UITableViewCell {

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        titleTextField.text = "Dam Khac Tao"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func editTitle() {
        titleTextField.userInteractionEnabled = true
    }
    
    func saveTitle() {
        titleTextField.userInteractionEnabled = false
    }
    
    
}
