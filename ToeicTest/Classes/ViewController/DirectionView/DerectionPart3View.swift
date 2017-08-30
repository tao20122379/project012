//
//  DerectionPart3View.swift
//  ToeicTest
//
//  Created by khactao on 5/26/17.
//
//

import UIKit

class DerectionPart3View: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    
    override func awakeFromNib() {
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.lightGray.cgColor
    }
}
