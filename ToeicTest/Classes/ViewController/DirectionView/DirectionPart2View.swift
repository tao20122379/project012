//
//  DirectionPart2View.swift
//  ToeicTest
//
//  Created by khactao on 5/26/17.
//
//

import UIKit

class DirectionPart2View: UIView {
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var exampleLabel: UILabel!
    override func awakeFromNib() {
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.lightGray.cgColor
    }
}
