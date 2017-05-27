//
//  Part7Header2View.swift
//  ToeicTest
//
//  Created by khactao on 4/11/17.
//
//

import UIKit

class Part7Header2View: UIView, UITextViewDelegate{

    // MARK: - IBOUtleft and variable
    
    @IBOutlet weak var numberQuestionLabel: UILabel!
    
    @IBOutlet weak var titleHeaderLabel: UILabel!
    @IBOutlet weak var passage1TextView: UITextView!
    var popTip: AMPopTip = AMPopTip()
    var textViewSelected: UITextView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        passage1TextView.layer.borderWidth = 1
        passage1TextView.delegate = self
        passage1TextView.layer.borderColor = UIColor.colorFromHexString("4C4C4C").CGColor
        self.userInteractionEnabled = false
    }
    
    
    
    func textViewDidChangeSelection(textView: UITextView) {
        textViewSelected = textView
        popTip.hide()
    }
    
    func translate(sender: UITextView) {
        
        if let ranger: UITextRange = textViewSelected!.selectedTextRange {
            SVProgressHUD.show()
            let selectedText: String = textViewSelected!.textInRange(ranger)!
            let startRect = textViewSelected!.caretRectForPosition(ranger.start)
            let endRect = textViewSelected!.caretRectForPosition(ranger.end)
            var textSelectedPoint: CGPoint?
            var tranlate: FGTranslator?
            NSLog(selectedText)
            let centerPoint = textViewSelected!.frame.origin.y+(startRect.origin.y+endRect.origin.y)/2
            var arrow = AMPopTipDirection.Down
            if centerPoint >= self.frame.height*4/5 {
                arrow = AMPopTipDirection.Up
                textSelectedPoint = CGPoint(x: textViewSelected!.frame.origin.x+(startRect.origin.x+endRect.origin.x)/2, y: textViewSelected!.frame.origin.y+startRect.origin.y)
            }
            else {
                arrow = AMPopTipDirection.Down
                textSelectedPoint = CGPoint(x: textViewSelected!.frame.origin.x+(startRect.origin.x+endRect.origin.x)/2, y: textViewSelected!.frame.origin.y+endRect.origin.y+startRect.height)
            }
            tranlate = FGTranslator(googleAPIKey: Constants.translateAPI)
            tranlate?.translateText(selectedText, withSource: "en", target: "vi", completion: { (error, outPutText, text1) in
                SVProgressHUD.dismiss()
                self.popTip.popoverColor = UIColor.colorFromHexString("4C4C4C")
                self.popTip.font = UIFont(name: "Avenir-Medium", size: 14)
                self.popTip.shouldDismissOnTap = true
                self.popTip.edgeMargin = 5
                self.popTip.offset = 2
                self.popTip.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)
                var showText: String = selectedText
                if outPutText != nil {
                    showText = outPutText
                }
                self.popTip.showText(showText, direction: arrow, maxWidth: Constants.SCREEN_WIDTH*3/4, inView: self, fromFrame: CGRect(x: textSelectedPoint!.x, y: textSelectedPoint!.y, width: 1, height: 1))
            })
        }
    }
    
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == #selector(translate(_:)) {
            return true
        }
        if action == #selector(copy(_:)) {
            return false
        }
        
        return false
    }

}
