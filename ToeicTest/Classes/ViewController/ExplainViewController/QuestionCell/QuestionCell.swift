//
//  QuestionCell.swift
//  ToeicTest
//
//  Created by khactao on 4/20/17.
//
//

import UIKit
import AMPopTip

class QuestionCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var questionNumberLabel: UILabel!
    var popTip: PopTip  = PopTip()
    
    var textViewSelected: UITextView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        questionTextView.delegate = self
    }
    
    func initWithData(_ question: Part34Model) {
        let questionString = question.question == nil ? "":question.question+"\n\n"
        let answerA = "(A) " + question.answerA + "\n\n"
        let answerB = "(B) " + question.answerB + "\n\n"
        let answerC = question.answerD == "" ? "(C) " + question.answerC:"(C) " + question.answerC + "\n\n"
        let answerD = question.answerD == "" ? "":"(D) " + question.answerD
        let text = questionString + answerA + answerB + answerC + answerD
        questionText.text = text
        var start: Int = 0
        var lengt: Int = 0
        switch question.answer! {
        case 1:
            start = questionString.characters.count
            lengt = answerA.characters.count
            break
        case 2:
            start = questionString.characters.count + answerA.characters.count
            lengt = answerB.characters.count
            break
        case 3:
            start = questionString.characters.count + answerA.characters.count + answerB.characters.count
            lengt = answerC.characters.count
            break
        case 4:
            start = questionString.characters.count + answerA.characters.count + answerB.characters.count + answerC.characters.count
            lengt = answerD.characters.count
            break
        default:
            break
        }
        let multiAttribute = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
        multiAttribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorFromHexString("008000"), range: NSRange(location: start, length: lengt))
        questionTextView.attributedText = multiAttribute
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Translate
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
            let centerPoint = textViewSelected!.frame.origin.y+(startRect.origin.y+endRect.origin.y)/2
            var arrow = PopTipDirection.down
            if centerPoint >= self.frame.height*4/5 {
                arrow = .up
                textSelectedPoint = CGPoint(x: textViewSelected!.frame.origin.x+(startRect.origin.x+endRect.origin.x)/2, y: textViewSelected!.frame.origin.y+startRect.origin.y)
            }
            else {
                arrow = .down
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
