//
//  Utility.swift
//  ToeicTest
//
//  Created by khactao on 9/6/17.
//
//

import Foundation
import UIKit
import MZFormSheetPresentationController
import AFNetworking

class Utility {
    internal class func setGroupRadio(_ radioArray: Array<RadioButton>) {
        radioArray.forEach { (button) in
            button.setImage(UIImage(named: "unchecked"), for: UIControlState())
            button.setImage(UIImage(named: "checked"), for: UIControlState.selected)
            button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        }
        radioArray[0].groupButtons = radioArray
    }
    
    internal class func showTranslate() {
        var presentedVC = UIApplication.shared.keyWindow?.rootViewController
        var formSheetController: MZFormSheetPresentationViewController?
        while let pVC = presentedVC?.presentedViewController {
            presentedVC = pVC
        }
        
        if presentedVC == nil {
            print("UIAlertController Error: You don't have any views set. You may be calling in viewdidload. Try viewdidappear.")
        }
        
        let translateVC = TranslateViewController(nibName: "TranslateViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: translateVC)
        MZFormSheetPresentationController.appearance().shouldApplyBackgroundBlurEffect = false
        formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController!.presentationController!.landscapeTopInset = Constants.SCREEN_HEIGHT*5/7
        formSheetController!.presentationController?.contentViewSize = CGSize(width: Constants.SCREEN_WIDTH, height: Constants.SCREEN_HEIGHT*2/7)
        formSheetController!.presentationController?.movementActionWhenKeyboardAppears = .centerVertically
        formSheetController!.allowDismissByPanningPresentedView = true
        formSheetController!.contentViewCornerRadius = 0
        formSheetController!.presentationController!.shouldDismissOnBackgroundViewTap = true
        formSheetController!.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.slideFromBottom
        presentedVC!.present(formSheetController!, animated: true, completion: nil)
        
    }
    
    internal class func dismissViewControllerr() {
        var presentedVC = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentedVC?.presentedViewController {
            presentedVC = pVC
        }
        
        if presentedVC == nil {
            print("UIAlertController Error: You don't have any views set. You may be calling in viewdidload. Try viewdidappear.")
        }
        presentedVC!.dismiss(animated: true, completion: nil)
    }
    
    
    // Convinient function
    internal class func RGBA2UIColor(_ red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
    
    internal class func getProfPic(_ fid: String) -> UIImage? {
        if (fid != "") {
            let imgURLString = "http://graph.facebook.com/" + fid + "/picture?type=large" //type=normal
            let imgURL = URL(string: imgURLString)
            let imageData = try? Data(contentsOf: imgURL!)
            let image = UIImage(data: imageData!)
            return image
        }
        return nil
    }
    
    internal class func Rgb2UIColor(_ red: Int, green: Int, blue: Int) -> UIColor{
        
        return Constants.RGBA2UIColor(red, green: green, blue: blue, alpha: 1.0)
    }
    
    internal class func getPercent(_ numbletrue: Int, total: Int) -> Double{
        return Double(numbletrue)/Double(total*20)
    }
    
    internal class func radians(_ degrees: CGFloat)-> CGFloat{
        
        return (degrees * CGFloat(Double.pi)/180)
    }
    
    internal class func setLayer(_ sender: AnyObject) {
        sender.layer.cornerRadius = sender.frame.size.height/2-1
        sender.layer.masksToBounds = true
    }
    
    internal class func setCornerLayer(_ sender: AnyObject) {
        sender.layer.cornerRadius = sender.frame.size.height/2
        sender.layer.masksToBounds = true
        sender.layer.borderWidth = 1
        sender.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    internal class func degrees(_ radians: CGFloat)-> CGFloat{
        
        return (radians * 180/CGFloat(Double.pi))
    }
    
    internal class func LANGTEXT(_ key: String)-> String{
        
        return NSLocalizedString(key, comment: "")
    }
    
    internal class func formatTimer(_ second: Int, minute: Int, hours: Int)-> String{
        var secondStr: String?
        var minuteStr: String?
        if second < 10 {
            secondStr = String(format: "0%i", second)
        }
        else {
            secondStr = String(format: "%i", second)
        }
        
        if minute < 10 {
            minuteStr = String(format: "0%i", minute)
        }
        else {
            minuteStr = String(format: "%i", minute)
        }
        
        return String(format: "0%i : %@ : %@", hours, minuteStr!, secondStr!)
    }
    internal class func saveUserImage(_ image: UIImage){
        UserDefaults.standard.set(UIImagePNGRepresentation(image), forKey: "userImage")
    }
    
    internal class func getImage() -> UIImage{
        if UserDefaults.standard.object(forKey: "userImage") != nil {
            let imageData = UserDefaults.standard.object(forKey: "userImage") as! Data
            let imageView = UIImage(data: imageData)
            return imageView!
        }
        else {
            let imageView = UIImage(named: "user")
            return imageView!
        }
    }
    
    // define font
    //    static let kRegularFont = UIFont(name: "Hiragino Sans", size: 13)
    
    // RegisterConstant
    internal struct RegisterMode {
        let kModeRegister: Int = 0
        let kModeEdit: Int = 1
    }
    
    // Get height tabbar
    
    // Edit answer mode
    internal struct AnswerMode {
        internal let kModePost = 0
        internal let kModeEdit = 1
    }

}
