//
//  PassageCell.swift
//  ToeicTest
//
//  Created by khactao on 3/29/17.
//
//

import UIKit
import AMPopTip

class PassageCell: UITableViewCell, UITextViewDelegate {


    @IBOutlet weak var passageTextView: UITextView!
    var popTip: PopTip = PopTip()
    var textViewSelected: UITextView?
    override func awakeFromNib() {
        super.awakeFromNib()
        passageTextView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func initWith(_ title: String, passage: String) {
        let passageText: String = title + "\n\n" + passage
        passageTextView.text = passageText
        let multiAttribute = NSMutableAttributedString(string: passageText, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
        multiAttribute.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 15), range: NSRange(location: 0, length: title.characters.count))
        passageTextView.attributedText = multiAttribute
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
