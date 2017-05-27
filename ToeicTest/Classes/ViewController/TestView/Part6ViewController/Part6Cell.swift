//
//  Part6Cell.swift
//  ToeicTest
//
//  Created by khactao on 5/17/17.
//
//

import UIKit

class Part6Cell: UITableViewCell {

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
    var part6Data: Part6Model?
    var question1Data: Part6QuestionModel?
    var question2Data: Part6QuestionModel?
    var question3Data: Part6QuestionModel?
    
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
        textLabel1.text = part6Data.text1
        textLabel2.text = part6Data.text2
        textLabel3.text = part6Data.text3
        textLabel4.text = part6Data.text4
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
    }
    
    @IBAction func answerA1Selected(sender: AnyObject) {
    }
    
    @IBAction func answerB1Selected(sender: AnyObject) {
    }
    
    @IBAction func answerC1Selected(sender: AnyObject) {
    }
    
    @IBAction func answerD1Selected(sender: AnyObject) {
    }
    
    @IBAction func answerA2Selected(sender: AnyObject) {
    }
    
    @IBAction func answerB2Selected(sender: AnyObject) {
    }
    
    @IBAction func answerC2Selected(sender: AnyObject) {
    }
    
    @IBAction func answerD2Selected(sender: AnyObject) {
    }
    
    @IBAction func answerA3Selected(sender: AnyObject) {
    }
    
    @IBAction func answerB3Selected(sender: AnyObject) {
    }
    
    @IBAction func answerC3Selected(sender: AnyObject) {
    }
    
    @IBAction func answerD3Selected(sender: AnyObject) {
    }

    
}
