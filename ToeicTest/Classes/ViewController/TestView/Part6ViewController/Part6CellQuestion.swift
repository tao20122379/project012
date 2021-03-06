//
//  Part6cell.swift
//  ToeicTest
//
//  Created by khactao on 12/31/16.
//
//

import UIKit

class Part6CellQuestion: UITableViewCell {
    
    // MARK: - IBOutlet and variable
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
    
    // MARK: - Funcion
    override func awakeFromNib() {
        super.awakeFromNib()
        Constants.setGroupRadio([radioA, radioB, radioC, radioD])
    }
    
    func initWithData(_ data: Part6QuestionModel) {
        self.questionData = data
        self.textTopLabel.text = data.passage1
        self.textDownLabel.text = data.passage2
        ALabel.text = data.answerA
        BLabel.text = data.answerB
        CLabel.text = data.answerC
        DLabel.text = data.answerD
        if Constants.status == .review {
            showReview()
        }
    }
    
    func showReview() {
        switch (questionData?.answerSelected)! {
        case 1:
            radioA.isSelected = true
            ALabel.font = UIFont.boldSystemFont(ofSize: 14)
            ALabel.textColor = UIColor.red
            break
        case 2:
            radioB.isSelected = true
            BLabel.font = UIFont.boldSystemFont(ofSize: 14)
            BLabel.textColor = UIColor.red
            break
        case 3:
            radioC.isSelected = true
            CLabel.font = UIFont.boldSystemFont(ofSize: 14)
            CLabel.textColor = UIColor.red
            break
        case 4:
            radioD.isSelected = true
            DLabel.font = UIFont.boldSystemFont(ofSize: 14)
            DLabel.textColor = UIColor.red
            break
        default:
            break
        }

        switch (questionData?.answer)! {
        case 1:
            if questionData?.answer == questionData?.answerSelected {
                checkAImage.isHidden = false
                
            }
            ALabel.font = UIFont.boldSystemFont(ofSize: 14)
            ALabel.textColor = UIColor.colorFromHexString("008000")
            break
        case 2:
            if questionData?.answer == questionData?.answerSelected {
                checkBImage.isHidden = false
            }
            BLabel.font = UIFont.boldSystemFont(ofSize: 14)
            BLabel.textColor = UIColor.colorFromHexString("008000")
            break
        case 3:
            if questionData?.answer == questionData?.answerSelected {
                checkCImage.isHidden = false
            }
            CLabel.font = UIFont.boldSystemFont(ofSize: 14)
            CLabel.textColor = UIColor.colorFromHexString("008000")
            break
        case 4:
            if questionData?.answer == questionData?.answerSelected {
                checkDImage.isHidden = false
            }
            DLabel.font = UIFont.boldSystemFont(ofSize: 14)
            DLabel.textColor = UIColor.colorFromHexString("008000")
            break
        default:
            break
        }
        reviewView.isHidden = false
    }
    
    //MARK: - Button ACtion
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
    
    
}
