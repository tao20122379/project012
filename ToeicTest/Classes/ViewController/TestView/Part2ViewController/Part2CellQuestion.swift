//
//  Part2CellQuestion.swift
//  ToeicTest
//
//  Created by khactao on 12/31/16.
//
//

import UIKit

protocol Part2Question_Delegate {
    func explainQuestion(data: Part2Model)
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

    // MARK: - IBOleft and variable
    override func awakeFromNib() {
        super.awakeFromNib()
        explainButton.setTitle(Constants.LANGTEXT("COMMON_EXPLAIN"), forState: .Normal)
        radioA.setImage(UIImage(named: "unchecked"), forState: UIControlState.Normal)
        radioA.setImage(UIImage(named: "checked"), forState: UIControlState.Selected)
        radioA.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        radioB.setImage(UIImage(named: "unchecked"), forState: UIControlState.Normal)
        radioB.setImage(UIImage(named: "checked"), forState: UIControlState.Selected)
        radioB.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        radioC.setImage(UIImage(named: "unchecked"), forState: UIControlState.Normal)
        radioC.setImage(UIImage(named: "checked"), forState: UIControlState.Selected)
        radioC.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        radioA.groupButtons = [radioA, radioB, radioC]
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initWithData(data: Part2Model) {
        questionData = data
        if Constants.status == .review {
            showReview()
            explainView.hidden = false
        }
    }
    
    func showReview() {
        switch (questionData?.answerSelected)! {
        case 1:
            radioA.selected = true
            radioA.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
            radioA.setTitleColor(UIColor.redColor(), forState: .Normal)
            break
        case 2:
            radioB.selected = true
            radioB.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
            radioB.setTitleColor(UIColor.redColor(), forState: .Normal)
            break
        case 3:
            radioC.selected = true
            radioC.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
            radioC.setTitleColor(UIColor.redColor(), forState: .Normal)
            break
        default:
            break
        }
        
        if questionData?.answer == questionData?.answerSelected {
            checkMark.hidden = false
        }
        switch (questionData?.answer)! {
        case 1:
            radioA.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
            radioA.setTitleColor(UIColor.colorFromHexString("008000"), forState: .Normal)
            break
        case 2:
            radioB.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
            radioB.setTitleColor(UIColor.colorFromHexString("008000"), forState: .Normal)
            break
        case 3:
            radioC.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
            radioC.setTitleColor(UIColor.colorFromHexString("008000"), forState: .Normal)
            break
        default:
            break
        }
    }
    
    @IBAction func answerASelected(sender: AnyObject) {
        questionData?.answerSelected = 1
    }
    
    @IBAction func answerBSelected(sender: AnyObject) {
        questionData?.answerSelected = 2
    }
    
    @IBAction func answerCSelected(sender: AnyObject) {
        questionData?.answerSelected = 3
    }
    
    @IBAction func explainSelected(sender: AnyObject) {
        self.delegate?.explainQuestion(questionData!)
    }
    
}
