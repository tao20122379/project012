//
//  HeaderView.swift
//  ToeicTest
//
//  Created by khactao on 12/31/16.
//
//

import UIKit


class HeaderView: UIView {
    
    // MARK: - IBOutleft and variable
    
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var questionGroupInfor: UILabel!
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}