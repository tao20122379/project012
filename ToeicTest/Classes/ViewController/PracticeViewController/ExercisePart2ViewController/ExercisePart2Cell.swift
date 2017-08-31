//
//  ExercisePart2Cell.swift
//  ToeicTest
//
//  Created by khactao on 8/31/17.
//
//

import UIKit

protocol Part2Exercise_Delegate {
    func explainQuestion(_ questionData: Part2Model)
    func selectAnswer(_ state: Bool)
}

class ExercisePart2Cell: UITableViewCell {
    
    // MARK: - IBOleft and variable
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var radioA: RadioButton!
    @IBOutlet weak var radioB: RadioButton!
    @IBOutlet weak var radioC: RadioButton!

    @IBOutlet weak var checkAImage: UIImageView!
    @IBOutlet weak var checkBImage: UIImageView!
    @IBOutlet weak var checkCImage: UIImageView!

    @IBOutlet weak var answerALabel: UILabel!
    @IBOutlet weak var answerBLabel: UILabel!
    @IBOutlet weak var answerCLabel: UILabel!

    @IBOutlet weak var reviewView: UIView!
    var numberQuestion: Int?
    var questionData: Part2Model?
    var explainData: Explain2Model?
    var textViewSelected: UITextView?
    var delegate: Part2Exercise_Delegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
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
    
    func initwithExplainData(_ data: Explain2Model) {
        explainData = data
        questionNumber.text = String(format: "%i.", (questionData?.questionID)!+10 )
        questionLabel.text = data.question.question
        questionLabel.isHidden = true
        answerALabel.text = "(A)"
        answerBLabel.text = "(B)"
        answerCLabel.text = "(C)"
    }
    
    func refresh() {
        radioA.isSelected = false
        radioB.isSelected = false
        radioC.isSelected = false
        reviewView.isHidden = true
        checkAImage.isHidden = true
        checkBImage.isHidden = true
        checkCImage.isHidden = true
        answerALabel.textColor = UIColor.black
        answerBLabel.textColor = UIColor.black
        answerCLabel.textColor = UIColor.black
    }
    
    
    func showReview() {
        reviewView.isHidden = false
        questionLabel.isHidden = false
        if explainData?.question.answerA != nil {answerALabel.text = "(A) " + (explainData?.question.answerA)!}
        if explainData?.question.answerB != nil {answerBLabel.text = "(B) " + (explainData?.question.answerB)!}
        if explainData?.question.answerC != nil {answerCLabel.text = "(C) " + (explainData?.question.answerC)!}
        switch (questionData?.answerSelected)! {
        case 1:
            radioA.isSelected = true
            answerALabel.font = UIFont.boldSystemFont(ofSize: 14)
            answerALabel.textColor = UIColor.red
            break
        case 2:
            radioB.isSelected = true
            answerBLabel.font = UIFont.boldSystemFont(ofSize: 14)
            answerBLabel.textColor = UIColor.red
            break
        case 3:
            radioC.isSelected = true
            answerCLabel.font = UIFont.boldSystemFont(ofSize: 14)
            answerCLabel.textColor = UIColor.red
            break
        default:
            break
        }
        
        
        switch (questionData?.answer)! {
        case 1:
            if questionData?.answer == questionData?.answerSelected {
                checkAImage.isHidden = false
            }
            answerALabel.font = UIFont.boldSystemFont(ofSize: 14)
            answerALabel.textColor = UIColor.colorFromHexString("008000")
            break
        case 2:
            if questionData?.answer == questionData?.answerSelected {
                checkBImage.isHidden = false
            }
            answerBLabel.font = UIFont.boldSystemFont(ofSize: 14)
            answerBLabel.textColor = UIColor.colorFromHexString("008000")
            break
        case 3:
            if questionData?.answer == questionData?.answerSelected {
                checkCImage.isHidden = false
            }
            answerCLabel.font = UIFont.boldSystemFont(ofSize: 14)
            answerCLabel.textColor = UIColor.colorFromHexString("008000")
            break
        default:
            break
        }
        
        if questionData?.answer == questionData?.answerSelected {
            delegate?.selectAnswer(true)
        }
        else {
            delegate?.selectAnswer(false)
        }
    }
    
    @IBAction func answerASelected(_ sender: AnyObject) {
        questionData?.answerSelected = 1
    }
    
    @IBAction func answerBSelected(_ sender: AnyObject) {
        questionData?.answerSelected = 2
    }
    
    @IBAction func answerCSelected(_ sender: AnyObject) {
        questionData?.answerSelected = 3
    }

    @IBAction func explainSelected(_ sender: Any) {
        delegate?.explainQuestion(questionData!)
    }
}
