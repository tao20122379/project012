//
//  Part2CellQuestion.swift
//  ToeicTest
//
//  Created by khactao on 12/31/16.
//
//

import UIKit

protocol Part2Question_Delegate {
    func explainQuestion(_ data: Part2Model)
}

class Part2CellQuestion: UITableViewCell {
    
    //MARK: - IBOutleft and variable
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var radioA: RadioButton!
    @IBOutlet weak var radioB: RadioButton!
    @IBOutlet weak var radioC: RadioButton!
    @IBOutlet weak var explainView: UIView!
    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var explainButton: UIButton!
    var delegate: Part2Question_Delegate?
    var numberQuestion: Int?
    var questionData: Part2Model?

    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        explainButton.setTitle(Constants.LANGTEXT("COMMON_EXPLAIN"), for: UIControlState())
        radioA.setImage(UIImage(named: "unchecked"), for: UIControlState())
        radioA.setImage(UIImage(named: "checked"), for: UIControlState.selected)
        radioA.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        radioB.setImage(UIImage(named: "unchecked"), for: UIControlState())
        radioB.setImage(UIImage(named: "checked"), for: UIControlState.selected)
        radioB.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        radioC.setImage(UIImage(named: "unchecked"), for: UIControlState())
        radioC.setImage(UIImage(named: "checked"), for: UIControlState.selected)
        radioC.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        radioA.groupButtons = [radioA, radioB, radioC]
    }

    func initWithData(_ data: Part2Model) {
        questionData = data
        if Constants.status == .review {
            showReview()
            explainView.isHidden = false
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Function
    func showReview() {
        switch (questionData?.answerSelected)! {
        case 1:
            radioA.isSelected = true
            radioA.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            radioA.setTitleColor(UIColor.red, for: UIControlState())
            break
        case 2:
            radioB.isSelected = true
            radioB.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            radioB.setTitleColor(UIColor.red, for: UIControlState())
            break
        case 3:
            radioC.isSelected = true
            radioC.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            radioC.setTitleColor(UIColor.red, for: UIControlState())
            break
        default:
            break
        }
        
        if questionData?.answer == questionData?.answerSelected {
            checkMark.isHidden = false
        }
        switch (questionData?.answer)! {
        case 1:
            radioA.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            radioA.setTitleColor(UIColor.colorFromHexString("008000"), for: UIControlState())
            break
        case 2:
            radioB.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            radioB.setTitleColor(UIColor.colorFromHexString("008000"), for: UIControlState())
            break
        case 3:
            radioC.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            radioC.setTitleColor(UIColor.colorFromHexString("008000"), for: UIControlState())
            break
        default:
            break
        }
    }
    
    // MARK: - Button action
    @IBAction func answerASelected(_ sender: AnyObject) {
        questionData?.answerSelected = 1
    }
    
    @IBAction func answerBSelected(_ sender: AnyObject) {
        questionData?.answerSelected = 2
    }
    
    @IBAction func answerCSelected(_ sender: AnyObject) {
        questionData?.answerSelected = 3
    }
    
    @IBAction func explainSelected(_ sender: AnyObject) {
        self.delegate?.explainQuestion(questionData!)
    }
    
}
