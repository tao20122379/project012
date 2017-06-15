//
//  Part6Cell.swift
//  ToeicTest
//
//  Created by khactao on 5/17/17.
//
//

import UIKit

class Part6Cell: UITableViewCell {

    // MARK: - IBOutlet and variable
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var textLabel1: UILabel!
    @IBOutlet weak var A1answerLabel: UILabel!
    @IBOutlet weak var A1checkImage: UIImageView!
    @IBOutlet weak var B1answerLabel: UILabel!
    @IBOutlet weak var B1checkImage: UIImageView!
    @IBOutlet weak var C1answerLabel: UILabel!
    @IBOutlet weak var D1answerLabel: UILabel!
    @IBOutlet weak var D1checkImage: UIImageView!
    @IBOutlet weak var C1checkImage: UIImageView!
    @IBOutlet weak var radioA1: RadioButton!
    @IBOutlet weak var radioB1: RadioButton!
    @IBOutlet weak var radioC1: RadioButton!
    @IBOutlet weak var radioD1: RadioButton!
    @IBOutlet weak var textLabel2: UILabel!
    @IBOutlet weak var A2answerLabel: UILabel!
    @IBOutlet weak var B2answerLabel: UILabel!
    @IBOutlet weak var C2answerLabel: UILabel!
    @IBOutlet weak var D2answerLabel: UILabel!
    @IBOutlet weak var A2checkImage: UIImageView!
    @IBOutlet weak var B2checkImage: UIImageView!
    @IBOutlet weak var C2checkImage: UIImageView!
    @IBOutlet weak var D2checkImage: UIImageView!
    @IBOutlet weak var radioA2: RadioButton!
    @IBOutlet weak var radioB2: RadioButton!
    @IBOutlet weak var radioC2: RadioButton!
    @IBOutlet weak var radioD2: RadioButton!
    @IBOutlet weak var textLabel3: UILabel!
    @IBOutlet weak var A3answerLabel: UILabel!
    @IBOutlet weak var B3answerLabel: UILabel!
    @IBOutlet weak var C3answerLabel: UILabel!
    @IBOutlet weak var D3answerLabel: UILabel!
    @IBOutlet weak var A3checkImage: UIImageView!
    @IBOutlet weak var B3checkImage: UIImageView!
    @IBOutlet weak var C3checkImage: UIImageView!
    @IBOutlet weak var D3checkImage: UIImageView!
    @IBOutlet weak var radioA3: RadioButton!
    @IBOutlet weak var radioB3: RadioButton!
    @IBOutlet weak var radioC3: RadioButton!
    @IBOutlet weak var radioD3: RadioButton!
    @IBOutlet weak var textLabel4: UILabel!
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var question1Label: UILabel!
    @IBOutlet weak var question2Label: UILabel!
    @IBOutlet weak var question3Label: UILabel!
    
    
    var part6Data: Part6Model?
    var question1Data: Part6QuestionModel?
    var question2Data: Part6QuestionModel?
    var question3Data: Part6QuestionModel?
    
    // MARK: - Funcion
    override func awakeFromNib() {
        borderView.layer.borderWidth = 1
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initWithData(part6Data: Part6Model) {
        Constants.setGroupRadio([radioA1, radioB1, radioC1, radioD1])
        Constants.setGroupRadio([radioA2, radioB2, radioC2, radioD2])
        Constants.setGroupRadio([radioA3, radioB3, radioC3, radioD3])
        self.part6Data = part6Data
        question1Data = part6Data.questionArray[0]
        question2Data = part6Data.questionArray[1]
        question3Data = part6Data.questionArray[2]
        textLabel1.text = part6Data.passage1
        textLabel2.text = part6Data.passage2
        textLabel3.text = part6Data.passage3
        textLabel4.text = part6Data.passage4
        A1answerLabel.text = question1Data?.answerA
        B1answerLabel.text = question1Data?.answerB
        C1answerLabel.text = question1Data?.answerC
        D1answerLabel.text = question1Data?.answerD
        A2answerLabel.text = question2Data?.answerA
        B2answerLabel.text = question2Data?.answerB
        C2answerLabel.text = question2Data?.answerC
        D2answerLabel.text = question2Data?.answerD
        A3answerLabel.text = question3Data?.answerA
        B3answerLabel.text = question3Data?.answerB
        C3answerLabel.text = question3Data?.answerC
        D3answerLabel.text = question3Data?.answerD
        if Constants.status == .review || Constants.status == .reviewPractice {
            showReview(question1Data!, answerAlabel: A1answerLabel, answerBlabel: B1answerLabel, answerClabel: C1answerLabel, answerDlabel: D1answerLabel, ACheckImage: A1checkImage, BCheckImage: B1checkImage, CCheckImage: C1checkImage, DCheckImage: D1checkImage, Aradio: radioA1, Bradio: radioB1, Cradio: radioC1, Dradio: radioD1)
            showReview(question2Data!, answerAlabel: A2answerLabel, answerBlabel: B2answerLabel, answerClabel: C2answerLabel, answerDlabel: D2answerLabel, ACheckImage: A2checkImage, BCheckImage: B2checkImage, CCheckImage: C2checkImage, DCheckImage: D2checkImage, Aradio: radioA2, Bradio: radioB2, Cradio: radioC2, Dradio: radioD1)
            showReview(question3Data!, answerAlabel: A3answerLabel, answerBlabel: B3answerLabel, answerClabel: C3answerLabel, answerDlabel: D3answerLabel, ACheckImage: A3checkImage, BCheckImage: B3checkImage, CCheckImage: C3checkImage, DCheckImage: D3checkImage, Aradio: radioA3, Bradio: radioB3, Cradio: radioC3, Dradio: radioD3)
        }
    }
    
    func showReview(question: Part6QuestionModel, answerAlabel: UILabel, answerBlabel: UILabel, answerClabel: UILabel, answerDlabel: UILabel, ACheckImage: UIImageView, BCheckImage: UIImageView, CCheckImage: UIImageView, DCheckImage: UIImageView, Aradio: RadioButton, Bradio: RadioButton, Cradio: RadioButton, Dradio: RadioButton) {
        NSLog("%i-%i", question.answerSelected, question.answer)
        switch (question.answerSelected) {
        case 1:
            Aradio.selected = true
            answerAlabel.font = UIFont.boldSystemFontOfSize(14)
            answerAlabel.textColor = UIColor.redColor()
            break
        case 2:
            Bradio.selected = true
            answerBlabel.font = UIFont.boldSystemFontOfSize(14)
            answerBlabel.textColor = UIColor.redColor()
            break
        case 3:
            Cradio.selected = true
            answerClabel.font = UIFont.boldSystemFontOfSize(14)
            answerClabel.textColor = UIColor.redColor()
            break
        case 4:
            Dradio.selected = true
            answerDlabel.font = UIFont.boldSystemFontOfSize(14)
            answerDlabel.textColor = UIColor.redColor()
            break
        default:
            break
        }
        
        switch (question.answer) {
        case 1:
            if question.answer == question.answerSelected {
                ACheckImage.hidden = false
            }
            answerAlabel.font = UIFont.boldSystemFontOfSize(14)
            answerAlabel.textColor = UIColor.colorFromHexString("008000")
            break
        case 2:
            if question.answer == question.answerSelected {
                BCheckImage.hidden = false
            }
            answerBlabel.font = UIFont.boldSystemFontOfSize(14)
            answerBlabel.textColor = UIColor.colorFromHexString("008000")
            break
        case 3:
            if question.answer == question.answerSelected {
                CCheckImage.hidden = false
            }
            answerClabel.font = UIFont.boldSystemFontOfSize(14)
            answerClabel.textColor = UIColor.colorFromHexString("008000")
            break
        case 4:
            if question.answer == question.answerSelected {
                DCheckImage.hidden = false
            }
            answerDlabel.font = UIFont.boldSystemFontOfSize(14)
            answerDlabel.textColor = UIColor.colorFromHexString("008000")
            break
        default:
            break
        }
        reviewView.hidden = false
    }
    
    
    
    // MARK: - Button Action
    @IBAction func answerA1Selected(sender: AnyObject) {
        question1Data?.answerSelected = 1
    }
    
    @IBAction func answerB1Selected(sender: AnyObject) {
        question1Data?.answerSelected = 2
    }
    
    @IBAction func answerC1Selected(sender: AnyObject) {
        question1Data?.answerSelected = 3
    }
    
    @IBAction func answerD1Selected(sender: AnyObject) {
        question1Data?.answerSelected = 4
    }
    
    @IBAction func answerA2Selected(sender: AnyObject) {
        question2Data?.answerSelected = 1
    }
    
    @IBAction func answerB2Selected(sender: AnyObject) {
        question2Data?.answerSelected = 2
    }
    
    @IBAction func answerC2Selected(sender: AnyObject) {
        question2Data?.answerSelected = 3
    }
    
    @IBAction func answerD2Selected(sender: AnyObject) {
        question2Data?.answerSelected = 4
    }
    
    @IBAction func answerA3Selected(sender: AnyObject) {
        question3Data?.answerSelected = 1
    }
    
    @IBAction func answerB3Selected(sender: AnyObject) {
        question3Data?.answerSelected = 2
    }
    
    @IBAction func answerC3Selected(sender: AnyObject) {
        question3Data?.answerSelected = 3
    }
    
    @IBAction func answerD3Selected(sender: AnyObject) {
        question3Data?.answerSelected = 4
    }

    
}
