//
//  DirectionPart1View.swift
//  ToeicTest
//
//  Created by khactao on 5/26/17.
//
//

import UIKit

class DirectionPart1View: UIView {

    @IBOutlet weak var exampleImage: UIImageView!
    @IBOutlet weak var exampleLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    
    override func awakeFromNib() {
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.lightGrayColor().CGColor
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
