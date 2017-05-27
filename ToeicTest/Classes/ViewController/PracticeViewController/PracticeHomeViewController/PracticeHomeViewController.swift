//
//  Practice1ViewController.swift
//  ToeicTest
//
//  Created by khactao on 4/27/17.
//
//

import UIKit
import YLProgressBar
import AVFoundation
import AudioToolbox

class PracticeHomeViewController: UIViewController, UIScrollViewDelegate, Part1Practice_Delegate {

    @IBOutlet weak var checkNextButton: UIButton!
    @IBOutlet weak var questionScrollView: UIScrollView!
    @IBOutlet weak var progress: YLProgressBar!
    @IBOutlet weak var checkMarkButton: UIButton!
    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var bottomBar: UIView!

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        checkNextButton.layer.cornerRadius = checkNextButton.frame.size.height/2
        checkNextButton.layer.masksToBounds = true
        let tincolors: NSArray = [UIColor(colorLiteralRed: 33/255.0, green: 180/255.0, blue: 162/255.0, alpha: 1.0), UIColor(colorLiteralRed: 3/255.0, green: 137/255.0, blue: 166/255.0, alpha: 1.0), UIColor(colorLiteralRed: 91/255.0, green: 63/255.0, blue: 150/255.0, alpha: 1.0), UIColor(colorLiteralRed: 87/255.0, green: 26/255.0, blue:70/255.0, alpha: 1.0)]
        progress.progressTintColors       = tincolors as [AnyObject]
        progress.stripesOrientation       = .Left
        progress.indicatorTextDisplayMode = .Progress
        progress.progressStretch          = false
        progress.setProgress(0.0, animated: false)
        checkNextButton.tag = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionScrollView.delegate = self
        questionScrollView.contentSize = CGSize(width:questionScrollView.frame.width*10, height:questionScrollView.frame.height)
        for i in 0..<10 {
            let part1 = Part1PracticeViewController(nibName: "Part1PracticeViewController", bundle: nil)
            part1.view.frame = CGRectMake(CGFloat(i)*Constants.SCREEN_WIDTH, 0,questionScrollView.frame.width, questionScrollView.frame.height)
            part1.delegate = self
            questionScrollView.addSubview(part1.view)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Funcion
    func showAnswerTrue() {
        self.checkNextButton.setTitle("Next", forState: .Normal)
        self.checkNextButton.tag = 2
        UIView.animateWithDuration(0.5, animations: {
            self.checkMarkButton.alpha = 1
            self.checkLabel.alpha = 1
            self.answerLabel.alpha = 1
            self.answerLabel.textColor = UIColor.greenColor()
            self.bottomBar.backgroundColor = UIColor.colorFromHexString("DEF0A2")
            }) { (true) in
        }
    }
    
    func showAnswerFalse() {
        UIView.animateWithDuration(0.5, animations: {
            self.checkMarkButton.alpha = 1
            self.checkLabel.alpha = 1
            self.answerLabel.alpha = 1
            self.answerLabel.textColor = UIColor.redColor()
        }) { (true) in
            self.checkNextButton.setTitle("Next", forState: .Normal)
        }
    }
    
    func hidenAnswer() {
        checkNextButton.backgroundColor = UIColor.lightGrayColor()
        self.checkNextButton.setTitle("Kiem tra", forState: .Normal)
        self.checkNextButton.tag = 1
        UIView.animateWithDuration(0.5, animations: {
            self.checkMarkButton.alpha = 0
            self.checkLabel.alpha = 0
            self.answerLabel.alpha = 0
            self.bottomBar.backgroundColor = UIColor.colorFromHexString("D4D4D4")

        }) { (true) in
       
        }
    }
    
    // MARK: - Button Action

    @IBAction func canceSelected(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func checkNextSelected(sender: AnyObject) {
        if sender.tag == 1 {
            showAnswerTrue()
        }
        else {
            hidenAnswer()
            questionScrollView.setContentOffset(CGPoint(x:  questionScrollView.contentOffset.x+questionScrollView.frame.size.width, y: 0.0), animated: true)
        }

    }
    
    // MARK: - Delegate
    func answerSelected(index: Int) {
        checkNextButton.backgroundColor = UIColor.greenColor()
    }

}
