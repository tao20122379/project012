//
//  Part1QuestionCell.swift
//  ToeicTest
//
//  Created by khactao on 12/30/16.
//
//

import UIKit

protocol Part1Question_Delegate {
    func explainQuestion(questionData: Part1Model)
}

class Part1QuestionCell: UITableViewCell {
    
    // MARK: - IBOutleft and variable
    @IBOutlet weak var pictureQuestion: UIImageView!
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var radioA: RadioButton!
    @IBOutlet weak var radioB: RadioButton!
    @IBOutlet weak var radioC: RadioButton!
    @IBOutlet weak var radioD: RadioButton!
    @IBOutlet weak var explainButton: UIButton!
    @IBOutlet weak var reviewCorver: UIView!
    @IBOutlet weak var checkMarkA: UIImageView!
    @IBOutlet weak var checkMarkB: UIImageView!
    @IBOutlet weak var checkMarkC: UIImageView!
    @IBOutlet weak var checkMarkD: UIImageView!
    var delegate: Part1Question_Delegate?
    var numberQuestion: Int?
    var questionData: Part1Model?
    
    // MARK: - Funcion
    override func awakeFromNib() {
        super.awakeFromNib()
        explainButton.setTitle(Constants.LANGTEXT("COMMON_EXPLAIN"), forState: .Normal)
        Constants.setGroupRadio( [radioA, radioB, radioC, radioD])
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func refresh() {
        radioA.selected = false
        radioB.selected = false
        radioC.selected = false
        radioD.selected = false
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
        case 4:
            radioD.selected = true
            radioD.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
            radioD.setTitleColor(UIColor.redColor(), forState: .Normal)
            break
        default:
            break
        }
        switch (questionData?.answer)! {
        case 1:
            if questionData?.answer == questionData?.answerSelected {
                checkMarkA.hidden = false
            }
            radioA.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
            radioA.setTitleColor(UIColor.colorFromHexString("008000"), forState: .Normal)
          
            break
        case 2:
            if questionData?.answer == questionData?.answerSelected {
                checkMarkB.hidden = false
            }
            radioB.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
            radioB.setTitleColor(UIColor.colorFromHexString("008000"), forState: .Normal)
            break
        case 3:
            if questionData?.answer == questionData?.answerSelected {
                checkMarkC.hidden = false
            }
            radioC.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
            radioC.setTitleColor(UIColor.colorFromHexString("008000"), forState: .Normal)
            break
        case 4:
            if questionData?.answer == questionData?.answerSelected {
                checkMarkD.hidden = false
            }
            radioD.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
            radioD.setTitleColor(UIColor.colorFromHexString("008000"), forState: .Normal)
            break
        default:
            break
        }
    }

    
    func initWithData(questionData: Part1Model) {
        self.questionData = questionData
        if Constants.status == .review {
            showReview()
            reviewCorver.hidden = false
        }
    }
    
    // MARK: - Button action
    @IBAction func answerASelected(sender: AnyObject) {
        self.questionData!.answerSelected = 1
    }
    
    @IBAction func answerBSelected(sender: AnyObject) {
        self.questionData!.answerSelected = 2
    }
    
    @IBAction func answerCSelected(sender: AnyObject) {
        self.questionData!.answerSelected = 3
    }
    
    @IBAction func answerDSelected(sender: AnyObject) {
        self.questionData!.answerSelected = 4
    }
    
    @IBAction func explainSelected(sender: AnyObject) {
        self.delegate?.explainQuestion(questionData!)
    }
    
}
