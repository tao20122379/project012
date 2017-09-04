//
//  Part7HeaderView.swift
//  ToeicTest
//
//  Created by khactao on 1/1/17.
//
//

import UIKit
import AMPopTip

class Part7HeaderView: UIView, UITextViewDelegate{
    
    // MARK: - IBOUtleft and variable
    @IBOutlet weak var numberQuestionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passage1TextView: UITextView!
    @IBOutlet weak var passage2Textview: UITextView!
    var popTip: PopTip = PopTip()
    var textViewSelected: UITextView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        passage1TextView.layer.borderWidth = 1
        passage1TextView.layer.borderColor = UIColor.lightGray.cgColor
        passage1TextView.delegate = self
        passage1TextView.layer.borderColor = UIColor.colorFromHexString("4C4C4C").cgColor
        passage2Textview.layer.borderWidth = 1
        passage2Textview.layer.borderColor = UIColor.lightGray.cgColor
        passage2Textview.delegate = self
        passage2Textview.layer.borderColor = UIColor.colorFromHexString("4C4C4C").cgColor
        self.isUserInteractionEnabled = false
    }
    

    
    func textViewDidChangeSelection(_ textView: UITextView) {
        textViewSelected = textView
        popTip.hide()
    }
    
    func translate(_ sender: UITextView) {
       
        if let ranger: UITextRange = textViewSelected!.selectedTextRange {
            SVProgressHUD.show()
            let selectedText: String = textViewSelected!.text(in: ranger)!
            let startRect = textViewSelected!.caretRect(for: ranger.start)
            let endRect = textViewSelected!.caretRect(for: ranger.end)
            var textSelectedPoint: CGPoint?
            var tranlate: FGTranslator?
            NSLog(selectedText)
            let centerPoint = textViewSelected!.frame.origin.y+(startRect.origin.y+endRect.origin.y)/2
            var arrow = PopTipDirection.down
            if centerPoint >= self.frame.height*4/5 {
                arrow = PopTipDirection.up
                textSelectedPoint = CGPoint(x: textViewSelected!.frame.origin.x+(startRect.origin.x+endRect.origin.x)/2, y: textViewSelected!.frame.origin.y+startRect.origin.y)
            }
            else {
                arrow = PopTipDirection.down
                textSelectedPoint = CGPoint(x: textViewSelected!.frame.origin.x+(startRect.origin.x+endRect.origin.x)/2, y: textViewSelected!.frame.origin.y+endRect.origin.y+startRect.height)
            }
            tranlate = FGTranslator(googleAPIKey: Constants.translateAPI)
            tranlate?.translateText(selectedText, withSource: "en", target: "vi", completion: { (error, outPutText, text1) in
                SVProgressHUD.dismiss()
                self.popTip.bubbleColor = UIColor.colorFromHexString("4C4C4C")
                self.popTip.font = UIFont(name: "Avenir-Medium", size: 14)!
                self.popTip.shouldDismissOnTap = true
                self.popTip.edgeMargin = 5
                self.popTip.offset = 2
                self.popTip.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)
                var showText: String = selectedText
                if outPutText != nil {
                    showText = outPutText!
                }
                self.popTip.show(text: showText, direction: arrow, maxWidth:  Constants.SCREEN_WIDTH*3/4, in: self, from: CGRect(x: textSelectedPoint!.x, y: textSelectedPoint!.y, width: 1, height: 1))
            })
        }
    }
    
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(translate(_:)) {
            return true
        }
        if action == #selector(copy(_:)) {
            return false
        }
        
        return false
    }
    
}










