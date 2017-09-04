
import Foundation
import UIKit
import MZFormSheetPresentationController
import AFNetworking
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


// MARK: CompletionHandler
typealias CompletionHandler = (Bool, AnyObject?) -> ()
typealias CompletionHandler1 = (Bool, Int, AnyObject?) -> ()
typealias CompletionMp3 = (AnyObject?, AnyObject) -> ()
// MARK: Status Code
enum QuestionType: Int {
    case questionTypeUnresolved     = 0
    case questionTypeResolved       = 1
}

enum Sex: Int {
    case male     = 0
    case female   = 1
}

// MARK: Result sort
enum ResultSort: Int {
    case resultSortLatest           = 0
    case resultSortDescendingPoint  = 1
    case resultSortAscendingPoint   = 2
}

enum LoginState: Int {
    case facebook   = 0
    case google     = 1
}

enum TestStatus {
    case test
    case review
    case practice
    case reviewPractice
    case end
}

struct AnswerRequests: OptionSet {
    let rawValue: Int
    static let None            = AnswerRequests(rawValue: 0)
    static let General         = AnswerRequests(rawValue: 1 << 0)
    static let Professional    = AnswerRequests(rawValue: 1 << 1)
    static let Special         = AnswerRequests(rawValue: 1 << 2)
}

class Constants {
    //MARK: - Contants will use in all class
    
    // APP URL
    static let kBaseURL = "http://weboo.link/api/"
    static var loginState = LoginState.facebook
    static let databaseName = "toeic_test"
    static let translateAPI = "AIzaSyDrBApxgUPJVCcgNE1d84KI8II4_AMr9BE"
    static let kVersion = ""
    static let kBaseImageURL = ""
    static let kTimeoutIntervalForRequest = TimeInterval(30)
    static let USER_AES256_ENCRYPT = "QA_SOCIAL"
    static let USER_INFOR_PATH = NSHomeDirectory() + "/Documents/USERINFO"
    static let IOSVERSION = UIDevice.current.systemVersion .components(separatedBy: ".")[0]
    
    // CHECK IPhone and OS Version
    static let IS_IPAD = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
    static let IS_IPHONE = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)
    static let IS_RETINA = (UIScreen.main.scale >= 2.0)
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = fmax(SCREEN_HEIGHT, SCREEN_WIDTH)
    static let SCREEN_MIN_LENGTH = fmin(SCREEN_WIDTH, SCREEN_HEIGHT)
    
    static let IS_IPHONE_4_OR_LESS = (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
    static let IS_IPHONE_5 = (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
    static let IS_IPHONE_6 = (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
    static let IS_IPHONE_6P = (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
    
    // Imobile sdk
    static let IMOBILE_NATIVE_PID = "55934"
    static let IMOBILE_NATIVE_MID = "317767"
    static let IMOBILE_NATIVE_SID = "1061048"
    static let TIME_CHANGE: Double = 5
    static let PAGE_ROW = 30
    
    static let IS_OS_5_OR_LATER = (Int(IOSVERSION) == 5)
    static let IS_OS_6_OR_LATER = (Int(IOSVERSION) == 6)
    static let IS_OS_7_OR_LATER = (Int(IOSVERSION) == 7)
    static let IS_OS_8_OR_LATER = (Int(IOSVERSION) == 8)
    static let IS_OS_9_OR_LATER = (Int(IOSVERSION) == 9)
    static let WINSIZE = UIApplication.shared.keyWindow?.frame.size
    static let SCREENSIZE = UIScreen.main.bounds.size
    static let iPhone568 = (WINSIZE?.height == 568.0)
    static let iPhone480 = (WINSIZE?.height <= 480.0)
    
    // MARK: - TestData
    
    // Derections
    static let directionPart3 = "Directions: You will hear some conversations between two people. You will be asked to answer three questions about what the speakers say in each conversation. Select the best response to each question and mark the letter (A), (B), (C), or (D) on your answer sheet. The conversations will not be printed in your test book and will be spoken only one time."
    static let directionPart4 = "Directions: You will hear some talks given by a single speaker. You will be asked to answer three questions about what the speaker says in each talk. Select the best response to each question and mark the letter (A), (B), (C), or (D) on your answer sheet. The talks will not be printed in your test book and will be spoken only one time."
    // Status
    static var status: TestStatus = .test
    static var second: Int = 0
    static var minute: Int = 0
    static var hours: Int = 0
    static var bookID: Int?
    static var testID: Int?
    static var audioName: String?
    static var iamgeName: String?
    static var mp3Player:MP3Player?
    static var isTranslate: Bool = false
    static var timer: Timer?
    static var part6Index: Int! = 0

    
    // Data
    static var testData: TestModel?
    static var userData: UserModel?
    static var bookData: BookModel? = BookModel()
    static var numberListenngTrue: Int = 0
    static var numberReadingTrue: Int = 0
    static var questionPar1List: Array = Array<Part1Model>()
    static var questionPar2List: Array = Array<Part2Model>()
    static var questionPar3List: Array = Array<Part34Model>()
    static var questionPar4List: Array = Array<Part34Model>()
    static var questionPar5List: Array = Array<Part34Model>()
    static var questionPar6List: Array = Array<Part6Model>()
    static var questionPar7List: Array = Array<Part7Model>()
    

    
    
    // Standard UserDefault
    static let SETTINGs = UserDefaults.standard
    

    static func showAlertView(_ title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style:.default) { (action) in
            // write code here
        }
        alertController.addAction(okAction)
        
        var presentedVC = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentedVC?.presentedViewController {
            presentedVC = pVC
        }
        
        if presentedVC == nil {
            print("UIAlertController Error: You don't have any views set. You may be calling in viewdidload. Try viewdidappear.")
        }
        
        presentedVC!.present(alertController, animated: true, completion: nil)
    }
    
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
    
    internal class func GetTabbarHeight()-> CGFloat{
        return SCREEN_HEIGHT*50/667
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
    
    
    // Notification
    static let kReloadUserNotification: String = "reloadUser"
    
    // Icon selected and un selected
    static let kImageSelected = UIImage(named: "common_icon_choose_circle_on")
    static let kImageUnSelected = UIImage(named: "common_icon_choose_circle_off")
    
}

extension UIColor {
    
    /**
     creates a UIColor from a hex string
     
     - parameter hex: Hex string with format "#cccccc"
     
     - returns: a UIColor object
     */
    class func colorFromHexString(_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines as CharacterSet).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))
        }
        
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


extension Array
{
    mutating func shuffle(_ number: Int)
    {
        for _ in 0..<number
        {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage!)!)
    }
}

