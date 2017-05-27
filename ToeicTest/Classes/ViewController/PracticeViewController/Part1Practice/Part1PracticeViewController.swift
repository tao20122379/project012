//
//  Part1PracticeViewController.swift
//  ToeicTest
//
//  Created by khactao on 4/27/17.
//
//

import UIKit

protocol Part1Practice_Delegate {
    func answerSelected(index: Int)
}

class Part1PracticeViewController: UIViewController {

    @IBOutlet weak var answerA: RadioButton!
    @IBOutlet weak var answerB: RadioButton!
    @IBOutlet weak var answerC: RadioButton!
    @IBOutlet weak var answerD: RadioButton!
    @IBOutlet weak var audioView: UIView!
    var audioview: AudioExplainView?
    var delegate: Part1Practice_Delegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioview = NSBundle.mainBundle().loadNibNamed("AudioExplainView", owner: self, options: nil).first as? AudioExplainView
       // audioView!.audioPlayWithName(BaseViewController.audioName!+"1", startTime: (explainPart1?.startTime)!, endTime: (explainPart1?.endTime)!)
        audioview!.frame = CGRect(x: 0, y: 0, width: Constants.SCREEN_WIDTH-30 , height: audioView.frame.size.height)
        audioview?.layer.borderWidth = 0
        audioView.addSubview(audioview!)
        
        answerA.setBackgroundImage(UIImage(named: "buttonImage"), forState: .Normal)
        answerA.setBackgroundImage(UIImage(named: "buttonImageSelected"), forState: UIControlState.Selected)
        answerA.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        answerA.tag = 1
        
        answerB.setBackgroundImage(UIImage(named: "buttonImage"), forState: UIControlState.Normal)
        answerB.setBackgroundImage(UIImage(named: "buttonImageSelected"), forState: UIControlState.Selected)
        answerB.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        answerA.tag = 2
        
        answerC.setBackgroundImage(UIImage(named: "buttonImage"), forState: UIControlState.Normal)
        answerC.setBackgroundImage(UIImage(named: "buttonImageSelected"), forState: UIControlState.Selected)
        answerC.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        answerA.tag = 3
        
        answerD.setBackgroundImage(UIImage(named: "buttonImage"), forState: UIControlState.Normal)
        answerD.setBackgroundImage(UIImage(named: "buttonImageSelected"), forState: UIControlState.Selected)
        answerD.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        answerA.tag = 4
        
        answerA.groupButtons = [answerA, answerB, answerC, answerD]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func answerSelected(sender: AnyObject) {
        self.delegate?.answerSelected(sender.tag)
    }


}
