//
//  Part3v4CellQuestion.swift
//  ToeicTest
//
//  Created by khactao on 12/31/16.
//
//

import UIKit

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
    var popTip: AMPopTip = AMPopTip()
    var textViewSelected: UITextView?
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        radioA.setImage(UIImage(named: "unchecked"), forState: UIControlState.Normal)
        radioA.setImage(UIImage(named: "checked"), forState: UIControlState.Selected)
        radioA.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        radioB.setImage(UIImage(named: "unchecked"), forState: UIControlState.Normal)
        radioB.setImage(UIImage(named: "checked"), forState: UIControlState.Selected)
        radioB.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        radioC.setImage(UIImage(named: "unchecked"), forState: UIControlState.Normal)
        radioC.setImage(UIImage(named: "checked"), forState: UIControlState.Selected)
        radioC.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        radioD.setImage(UIImage(named: "unchecked"), forState: UIControlState.Normal)
        radioD.setImage(UIImage(named: "checked"), forState: UIControlState.Selected)
        
        radioD.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        radioA.groupButtons = [radioA, radioB, radioC, radioD]
    }
    
    func initwithData(data: Part34Model) {
        questionData = data
        questionLabel.text = data.question
        if data.answerA != nil {answerALabel.text = "(A) " + (data.answerA)!}
        if data.answerB != nil {answerBLabel.text = "(B) " + (data.answerB)!}
        if data.answerC != nil {answerCLabel.text = "(C) " + (data.answerC)!}
        if data.answerD != nil {answerDLabel.text = "(D) " + (data.answerD)!}
        questionData?.answer = data.answer
        if Constants.status == .review {
            self.showReview()
            self.reviewView.hidden = false
        }
    }
    
    func showReview() {
   
        switch (questionData?.answerSelected)! {
        case 1:
            radioA.selected = true
            answerALabel.font = UIFont.boldSystemFontOfSize(14)
            answerALabel.textColor = UIColor.redColor()
            break
        case 2:
            radioB.selected = true
            answerBLabel.font = UIFont.boldSystemFontOfSize(14)
            answerBLabel.textColor = UIColor.redColor()
            break
        case 3:
            radioC.selected = true
            answerCLabel.font = UIFont.boldSystemFontOfSize(14)
            answerCLabel.textColor = UIColor.redColor()
            break
        case 4:
            radioD.selected = true
            answerDLabel.font = UIFont.boldSystemFontOfSize(14)
            answerDLabel.textColor = UIColor.redColor()
            break
        default:
            break
        }
        
    
        switch (questionData?.answer)! {
        case 1:
            if questionData?.answer == questionData?.answerSelected {
                checkAImage.hidden = false

            }
            answerALabel.font = UIFont.boldSystemFontOfSize(14)
            answerALabel.textColor = UIColor.colorFromHexString("008000")
            break
        case 2:
            if questionData?.answer == questionData?.answerSelected {
                checkBImage.hidden = false
            }
            answerBLabel.font = UIFont.boldSystemFontOfSize(14)
            answerBLabel.textColor = UIColor.colorFromHexString("008000")
            break
        case 3:
            if questionData?.answer == questionData?.answerSelected {
                checkCImage.hidden = false
            }
            answerCLabel.font = UIFont.boldSystemFontOfSize(14)
            answerCLabel.textColor = UIColor.colorFromHexString("008000")
            break
        case 4:
            if questionData?.answer == questionData?.answerSelected {
                checkDImage.hidden = false
            }
            answerDLabel.font = UIFont.boldSystemFontOfSize(14)
            answerDLabel.textColor = UIColor.colorFromHexString("008000")
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
    
    @IBAction func answerDSelected(sender: AnyObject) {
        questionData?.answerSelected = 4
    }
    
    @IBAction func explainSelected(sender: AnyObject) {
        
        
    }
    
    
    
    
}
