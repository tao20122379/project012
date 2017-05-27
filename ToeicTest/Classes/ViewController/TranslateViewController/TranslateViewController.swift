//
//  TranslateViewController.swift
//  ToeicTest
//
//  Created by khactao on 4/3/17.
//
//

import UIKit

protocol Translate_delegate {
    func translateCance()
}

class TranslateViewController: UIViewController, UITextViewDelegate {

  
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var outPutTextView: UITextView!
    
    @IBOutlet weak var inputSegment: UISegmentedControl!
    @IBOutlet weak var outPutSegment: UISegmentedControl!
    @IBOutlet weak var canceButton: UIButton!
    
    var tranlate: FGTranslator?
    var delegate: Translate_delegate?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
        inputTextView.layer.borderWidth = 0.5
        inputTextView.layer.borderColor = UIColor.blueColor().CGColor
    }
    
    @IBAction func changeSelected(sender: AnyObject) {
        if inputSegment.selectedSegmentIndex == 0 {
            inputSegment.selectedSegmentIndex = 1
            outPutSegment.selectedSegmentIndex = 1
            translateTextVietnam(inputTextView.text)
        }
        else {
            inputSegment.selectedSegmentIndex = 0
            outPutSegment.selectedSegmentIndex = 0
            translateTextEnglish(inputTextView.text)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func inputSegmentSelected(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            outPutSegment.selectedSegmentIndex = 0
            translateTextEnglish(inputTextView.text)
        }
        else {
            outPutSegment.selectedSegmentIndex = 1
            translateTextVietnam(inputTextView.text)
            
        }
    }
    
    @IBAction func outputSegmentSelected(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            inputSegment.selectedSegmentIndex = 0
            translateTextEnglish(inputTextView.text)
        }
        else {
            inputSegment.selectedSegmentIndex = 1
            translateTextVietnam(inputTextView.text)
        }
    }

    @IBAction func canceSelected(sender: AnyObject) {
        Constants.dismissViewControllerr()
    }
    
    func translateTextEnglish(text: String) {
        tranlate = FGTranslator(googleAPIKey: Constants.translateAPI)
        tranlate?.translateText(inputTextView.text, withSource: "en", target: "vi", completion: { (error, outPutText, text1) in
            self.outPutTextView.text = outPutText
            
        })
    }
    
    func translateTextVietnam(text: String) {
        tranlate = FGTranslator(googleAPIKey: Constants.translateAPI)
        tranlate?.translateText(inputTextView.text, withSource: "vi", target: "en", completion: { (error, outPutText, text1) in
            self.outPutTextView.text = outPutText
            
        })
    }
    
    func textViewDidChange(textView: UITextView) {
        if inputSegment.selectedSegmentIndex == 0 {
            translateTextEnglish(inputTextView.text)
        }
        else {
            translateTextVietnam(inputTextView.text)
        }
    }
    

    
    

}
