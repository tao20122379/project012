//
//  Part6cell.swift
//  ToeicTest
//
//  Created by khactao on 12/31/16.
//
//

import UIKit

class Part6CellQuestion: UITableViewCell {
    
    
    @IBOutlet weak var textTopLabel: UILabel!
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var radioA: RadioButton!
    @IBOutlet weak var radioB: RadioButton!
    @IBOutlet weak var radioC: RadioButton!
    @IBOutlet weak var radioD: RadioButton!
    @IBOutlet weak var textDownLabel: UILabel!
    @IBOutlet weak var borderTop: UIView!
    @IBOutlet weak var borderBottom: UIView!
    @IBOutlet weak var borderLeft: UIView!

    @IBOutlet weak var ALabel: UILabel!
    @IBOutlet weak var BLabel: UILabel!
    @IBOutlet weak var CLabel: UILabel!
    @IBOutlet weak var DLabel: UILabel!
    
    @IBOutlet weak var checkAImage: UIImageView!
    @IBOutlet weak var checkBImage: UIImageView!
    @IBOutlet weak var checkCImage: UIImageView!
    @IBOutlet weak var checkDImage: UIImageView!
    
    @IBOutlet weak var reviewView: UIView!
    
    var questionData: Part6QuestionModel?
    override func awakeFromNib() {
        super.awakeFromNib()
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
    
    func initWithData(data: Part6QuestionModel) {
        self.questionData = data
        self.textTopLabel.text = data.passage1
        self.textDownLabel.text = data.passage2
        ALabel.text = data.answerA
        BLabel.text = data.answerB
        CLabel.text = data.answerC
        DLabel.text = data.answerD
        if HomeViewController.status == .review {
            showReview()
        }
    }
    
    func showReview() {
        
        switch (questionData?.answerSelected)! {
        case 1:
            radioA.selected = true
            ALabel.font = UIFont.boldSystemFontOfSize(14)
            ALabel.textColor = UIColor.redColor()
            break
        case 2:
            radioB.selected = true
            BLabel.font = UIFont.boldSystemFontOfSize(14)
            BLabel.textColor = UIColor.redColor()
            break
        case 3:
            radioC.selected = true
            CLabel.font = UIFont.boldSystemFontOfSize(14)
            CLabel.textColor = UIColor.redColor()
            break
        case 4:
            radioD.selected = true
            DLabel.font = UIFont.boldSystemFontOfSize(14)
            DLabel.textColor = UIColor.redColor()
            break
        default:
            break
        }
        
        
        switch (questionData?.answer)! {
        case 1:
            if questionData?.answer == questionData?.answerSelected {
                checkAImage.hidden = false
                
            }
            ALabel.font = UIFont.boldSystemFontOfSize(14)
            ALabel.textColor = UIColor.colorFromHexString("008000")
            break
        case 2:
            if questionData?.answer == questionData?.answerSelected {
                checkBImage.hidden = false
            }
            BLabel.font = UIFont.boldSystemFontOfSize(14)
            BLabel.textColor = UIColor.colorFromHexString("008000")
            break
        case 3:
            if questionData?.answer == questionData?.answerSelected {
                checkCImage.hidden = false
            }
            CLabel.font = UIFont.boldSystemFontOfSize(14)
            CLabel.textColor = UIColor.colorFromHexString("008000")
            break
        case 4:
            if questionData?.answer == questionData?.answerSelected {
                checkDImage.hidden = false
            }
            DLabel.font = UIFont.boldSystemFontOfSize(14)
            DLabel.textColor = UIColor.colorFromHexString("008000")
            break
        default:
            break
        }
        reviewView.hidden = false
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
    
    
}
