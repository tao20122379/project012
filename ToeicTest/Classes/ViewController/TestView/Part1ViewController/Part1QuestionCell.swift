//
//  Part1QuestionCell.swift
//  ToeicTest
//
//  Created by khactao on 12/30/16.
//
//

import UIKit

protocol Part1Question_Delegate {
    func explainQuestion(_ questionData: Part1Model)
    func selectAnswer(_ state: Bool)
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
        explainButton.setTitle(Constants.LANGTEXT("COMMON_EXPLAIN"), for: UIControlState())
        Constants.setGroupRadio( [radioA, radioB, radioC, radioD])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func refresh() {
        radioA.isSelected = false
        radioB.isSelected = false
        radioC.isSelected = false
        radioD.isSelected = false
        reviewCorver.isHidden = true
        checkMarkA.isHidden = true
        checkMarkB.isHidden = true
        checkMarkC.isHidden = true
        checkMarkD.isHidden = true
        radioA.setTitleColor(UIColor.black, for: UIControlState())
        radioB.setTitleColor(UIColor.black, for: UIControlState())
        radioC.setTitleColor(UIColor.black, for: UIControlState())
        radioD.setTitleColor(UIColor.black, for: UIControlState())
    }
    
    func showReview() {
        reviewCorver.isHidden = false
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
        case 4:
            radioD.isSelected = true
            radioD.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            radioD.setTitleColor(UIColor.red, for: UIControlState())
            break
        default:
            break
        }
        
        switch (questionData?.answer)! {
        case 1:
            if questionData?.answer == questionData?.answerSelected {
                checkMarkA.isHidden = false
                self.delegate?.selectAnswer(true)
            }
            else {
                self.delegate?.selectAnswer(false)
            }
            radioA.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            radioA.setTitleColor(UIColor.colorFromHexString("008000"), for: UIControlState())
        
            break
        case 2:
            if questionData?.answer == questionData?.answerSelected {
                checkMarkB.isHidden = false
                self.delegate?.selectAnswer(true)
            }
            else {
                self.delegate?.selectAnswer(false)
            }
            radioB.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            radioB.setTitleColor(UIColor.colorFromHexString("008000"), for: UIControlState())
            break
        case 3:
            if questionData?.answer == questionData?.answerSelected {
                checkMarkC.isHidden = false
                self.delegate?.selectAnswer(true)
            }
            else {
                self.delegate?.selectAnswer(false)
            }
            radioC.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            radioC.setTitleColor(UIColor.colorFromHexString("008000"), for: UIControlState())
            break
        case 4:
            if questionData?.answer == questionData?.answerSelected {
                checkMarkD.isHidden = false
                self.delegate?.selectAnswer(true)
            }
            else {
                self.delegate?.selectAnswer(false)
            }
            radioD.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            radioD.setTitleColor(UIColor.colorFromHexString("008000"), for: UIControlState())
            break
        default:
            break
        }
    }

    
    func initWithData(_ questionData: Part1Model) {
        self.questionData = questionData
        self.questionData?.answer = questionData.answer
        if Constants.status == .review {
            showReview()
            
        }
    }
    

    // MARK: - Button action
    @IBAction func answerASelected(_ sender: AnyObject) {
        self.questionData!.answerSelected = 1
    }
    
    @IBAction func answerBSelected(_ sender: AnyObject) {
        self.questionData!.answerSelected = 2
    }
    
    @IBAction func answerCSelected(_ sender: AnyObject) {
        self.questionData!.answerSelected = 3
    }
    
    @IBAction func answerDSelected(_ sender: AnyObject) {
        self.questionData!.answerSelected = 4
    }
    
    @IBAction func explainSelected(_ sender: AnyObject) {
        self.delegate?.explainQuestion(questionData!)
    }
    
}
