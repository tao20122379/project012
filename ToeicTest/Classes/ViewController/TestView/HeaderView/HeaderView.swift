//
//  HeaderView.swift
//  ToeicTest
//
//  Created by khactao on 12/31/16.
//
//

import UIKit
protocol HeaderView_Delegate {
    func explainSection()
}

class HeaderView: UIView {
    
    // MARK: - IBOutleft and variable
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var questionGroupInfor: UILabel!
    @IBOutlet weak var explainButton: UIButton!
    var delegate: HeaderView_Delegate?
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func explainSelected(_ sender: Any) {
        delegate?.explainSection()
    }
    
}
