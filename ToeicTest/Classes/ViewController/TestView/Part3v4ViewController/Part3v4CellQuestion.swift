//
//  Part3v4CellQuestion.swift
//  ToeicTest
//
//  Created by khactao on 12/31/16.
//
//

import UIKit
import AMPopTip

class Part3v4CellQuestion: UITableViewCell {
    
    // MARK: - IBOleft and variable
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var radioA: RadioButton!
    @IBOutlet weak var radioB: RadioButton!
    @IBOutlet weak var radioC: RadioButton!
    @IBOutlet weak var radioD: RadioButton!
    @IBOutlet weak var checkAImage: UIImageView!
    @IBOutlet weak var checkBImage: UIImageView!
    @IBOutlet weak var checkCImage: UIImageView!
    @IBOutlet weak var checkDImage: UIImageView!
    @IBOutlet weak var answerALabel: UILabel!
    @IBOutlet weak var answerBLabel: UILabel!
    @IBOutlet weak var answerCLabel: UILabel!
    @IBOutlet weak var answerDLabel: UILabel!
    @IBOutlet weak var reviewView: UIView!
    var numberQuestion: Int?
    var questionData: Part34Model?
    var popTip: PopTip = PopTip()
    var textViewSelected: UITextView?
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
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
        
        radioD.setImage(UIImage(named: "unchecked"), for: UIControlState())
        radioD.setImage(UIImage(named: "checked"), for: UIControlState.selected)
        
        radioD.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        radioA.groupButtons = [radioA, radioB, radioC, radioD]
    }
    
    func initwithData(_ data: Part34Model) {
        questionData = data
        questionLabel.text = data.question
        if data.answerA != nil {answerALabel.text = "(A) " + (data.answerA)!}
        if data.answerB != nil {answerBLabel.text = "(B) " + (data.answerB)!}
        if data.answerC != nil {answerCLabel.text = "(C) " + (data.answerC)!}
        if data.answerD != nil {answerDLabel.text = "(D) " + (data.answerD)!}
        questionData?.answer = data.answer
        if Constants.status == .review {
            self.showReview()
            self.reviewView.isHidden = false
        }
    }
    
    func showReview() {
   
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
        case 4:
            radioD.isSelected = true
            answerDLabel.font = UIFont.boldSystemFont(ofSize: 14)
            answerDLabel.textColor = UIColor.red
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
        case 4:
            if questionData?.answer == questionData?.answerSelected {
                checkDImage.isHidden = false
            }
            answerDLabel.font = UIFont.boldSystemFont(ofSize: 14)
            answerDLabel.textColor = UIColor.colorFromHexString("008000")
            break
        default:
            break
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
    
    @IBAction func answerDSelected(_ sender: AnyObject) {
        questionData?.answerSelected = 4
    }
    
    @IBAction func explainSelected(_ sender: AnyObject) {
        
        
    }
    
    
    
    
}
