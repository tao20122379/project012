//
//  FooterExplainView.swift
//  ToeicTest
//
//  Created by khactao on 4/10/17.
//
//

import UIKit
protocol FooterExplain_Delegate {
    func explainSection(_ section: Int)
}

class FooterExplainView: UIView {
    
    @IBOutlet weak var explainButton: UIButton!
    var sectionID: Int?
    var delegate: FooterExplain_Delegate?
    @IBAction func explainSelected(_ sender: AnyObject) {
        self.delegate?.explainSection(sectionID!)
    }
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        explainButton.setTitle(Constants.LANGTEXT("COMMON_EXPLAIN"), for: UIControlState())
    }
    
}
