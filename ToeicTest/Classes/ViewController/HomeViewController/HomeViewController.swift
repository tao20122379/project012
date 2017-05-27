//
//  HomeViewController.swift
//  ToeicTest
//
//  Created by khactao on 12/30/16.
//
//

import UIKit
import ExpandingMenu
import GoogleMobileAds

enum TestStatus {
    case test
    case review
    case practice
    case end
}


class HomeViewController: UIViewController, Login_Delegate {
    
    // MARK: - IBOuleft and variable
    var mp3Player: MP3Player?
    var items = NSArray()
    var testID: Int?
    static var status: TestStatus = .test
    static var userData: UserModel?
    @IBOutlet weak var listImage1: UIImageView!
    @IBOutlet weak var toeic450Button: UIButton!
    @IBOutlet weak var grammarButton: UIButton!
    @IBOutlet weak var practiceButton: UIButton!
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var toeic700Button: UIButton!
    @IBOutlet weak var test700Button: UIButton!
    @IBOutlet weak var grammarImage: UIImageView!
    @IBOutlet weak var practiceImage: UIImageView!
    @IBOutlet weak var testImage: UIImageView!
    @IBOutlet weak var toeic700Image: UIImageView!
    @IBOutlet weak var test700Image: UIImageView!
    var interstitial: GADInterstitial!
    
    // MARK: - Cycle life
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addMenu()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setBorderImage(listImage1)
        setBorderImage(grammarImage)
        setBorderImage(practiceImage)
        setBorderImage(testImage)
        setBorderImage(test700Image)
        setBorderImage(toeic700Image)
        BaseViewController.bookID = 3
        BaseViewController.testID = 1
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.LandscapeRight
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BaseViewController.mp3Player = MP3Player()
        addTranslateText()
        showlistMenu()
        checkAccount()
        localizable()
  
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Funcion
    func checkAccount() {
        if DatabaseManager().checkAccountSave(Constants.databaseName) == true {
            DatabaseManager().getUserSave(Constants.databaseName, completionHandler: { (status, datas) in
                if status {
                    let user = datas as? UserModel
                    HomeViewController.userData = user
                }
            })
        }
        else {
            let imageView = UIImage(named: "user")
            Constants.saveUserImage(imageView!)
        }
    }
    
    func addTranslateText() {
        let myMenuController: UIMenuController = UIMenuController.sharedMenuController()
        myMenuController.menuVisible = true
        let myMenuItem_1: UIMenuItem = UIMenuItem(title: "translate", action: #selector(Part7HeaderView.translate(_:)))
        let myMenuItems: NSArray = [myMenuItem_1]
        myMenuController.menuItems = myMenuItems as? [UIMenuItem]
    }
    
    func setBorderImage(imageView: UIImageView) {
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
    }

    func addMenu() {
        let menuButtonSize: CGSize = CGSize(width: 40.0, height: 40.0)
        let menuButton = ExpandingMenuButton(frame:  CGRect(origin: CGPointZero, size: menuButtonSize), centerImage: UIImage(named: "menu")!, centerHighlightedImage: UIImage(named: "menu")!)
        menuButton.center = CGPoint(x: self.view.bounds.width - 32.0, y: self.view.bounds.height - 30.0)
        let item1 = ExpandingMenuItem(size: menuButtonSize, title: Constants.LANGTEXT("HOME_ACCOUNT"), image: UIImage(named: "user1")!, highlightedImage: UIImage(named: "user1")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            self.menuSelect(1)
        }
        let item2 = ExpandingMenuItem(size: menuButtonSize, title: Constants.LANGTEXT("HOME_GRAMMAR"), image: UIImage(named: "education1")!, highlightedImage: UIImage(named: "education1")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            self.menuSelect(2)
        }
        let item3 = ExpandingMenuItem(size: menuButtonSize, title: Constants.LANGTEXT("HOME_PRACTICE"), image: UIImage(named: "practice1")!, highlightedImage: UIImage(named: "practice1")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            self.menuSelect(3)
            
        }
        let item4 = ExpandingMenuItem(size: menuButtonSize, title: Constants.LANGTEXT("HOME_TEST"), image: UIImage(named: "test1")!, highlightedImage: UIImage(named: "test1")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            self.menuSelect(4)
        }
        menuButton.addMenuItems([item4, item3, item2, item1])
        self.view.addSubview(menuButton)
    }
    
    
    func showlistMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.listImage1.transform = CGAffineTransformMakeTranslation(200, 0)
            self.toeic450Button.transform = CGAffineTransformMakeTranslation(200, 0)
        }) { (true) in
            UIView.animateWithDuration(0.4, animations: {
                self.grammarImage.transform = CGAffineTransformMakeTranslation(230, 0)
                self.grammarButton.transform = CGAffineTransformMakeTranslation(230, 0)
            }) { (true) in
                UIView.animateWithDuration(0.4, animations: {
                    self.practiceImage.transform = CGAffineTransformMakeTranslation(230, 0)
                    self.practiceButton.transform = CGAffineTransformMakeTranslation(230, 0)
                }) { (true) in
                    UIView.animateWithDuration(0.4, animations: {
                        self.testImage.transform = CGAffineTransformMakeTranslation(230, 0)
                        self.testButton.transform = CGAffineTransformMakeTranslation(230, 0)
                    }) { (true) in
                        UIView.animateWithDuration(0.4, animations: {
                            self.toeic700Image.transform = CGAffineTransformMakeTranslation(200, 0)
                            self.toeic700Button.transform = CGAffineTransformMakeTranslation(200, 0)
                        }) { (true) in
                            UIView.animateWithDuration(0.4, animations: {
                                self.test700Image.transform = CGAffineTransformMakeTranslation(230, 0)
                                self.test700Button.transform = CGAffineTransformMakeTranslation(230, 0)
                            })
                        }
                    }
                }
            }
        }
    }
    
    func localizable() {
        grammarButton.setTitle(Constants.LANGTEXT("HOME_GRAMMAR"), forState: .Normal)
        practiceButton.setTitle(Constants.LANGTEXT("HOME_PRACTICE"), forState: .Normal)
        testButton.setTitle(Constants.LANGTEXT("HOME_TEST"), forState: .Normal)
        test700Button.setTitle(Constants.LANGTEXT("HOME_TEST"), forState: .Normal)
    }

    // MARK: - Delegate
    func menuSelect(menu: Int) {
        switch menu {
        case 1:
            if DatabaseManager().checkAccountSave(Constants.databaseName) == true {
                DatabaseManager().getUserSave(Constants.databaseName, completionHandler: { (status, datas) in
                    if status {
                        let user = datas as? UserModel
                        self.loginSuccess(user!)
                    }
                })
            }
            else {
                let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
                loginVC.delegate = self
                self.navigationController?.navigationBar.hidden = false
                self.navigationController?.presentViewController(loginVC, animated: true, completion: nil)
            }
            break
        case 2:
            let bookTest = GrammarViewController(nibName: "GrammarViewController", bundle: nil)
            self.navigationController?.navigationBar.hidden = false
            self.navigationController?.pushViewController(bookTest, animated: true)
            break
        case 3:
            let bookTest = PracticeViewController(nibName: "PracticeViewController", bundle: nil)
            self.navigationController?.navigationBar.hidden = false
            self.navigationController?.pushViewController(bookTest, animated: true)
            break
        case 4:
            let bookTest = TestMenuViewController(nibName: "TestMenuViewController", bundle: nil)
            self.navigationController?.navigationBar.hidden = false
            self.navigationController?.pushViewController(bookTest, animated: true)
            break
        default:
            break
        }
    }
    
    func loginSuccess(user: UserModel) {
        let accountVC = AccountViewController(nibName: "AccountViewController", bundle: nil)
        accountVC.user = user
        HomeViewController.userData = user
        DatabaseManager().login(Constants.databaseName, user: user)
        self.navigationController?.pushViewController(accountVC, animated: true)
    }
    
    // MARK: - Button action
    @IBAction func grammarSelected(sender: AnyObject) {
        let bookTest = GrammarViewController(nibName: "GrammarViewController", bundle: nil)
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.pushViewController(bookTest, animated: true)
    }
    
    @IBAction func practiceSelected(sender: AnyObject) {
        let bookTest = PracticeViewController(nibName: "PracticeViewController", bundle: nil)
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.pushViewController(bookTest, animated: true)
    }
    
    @IBAction func testSelected(sender: AnyObject) {
        let bookTest = TestMenuViewController(nibName: "TestMenuViewController", bundle: nil)
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.pushViewController(bookTest, animated: true)
    }
    
    @IBAction func test700Selected(sender: AnyObject) {
        let bookTest = TestMenuViewController(nibName: "TestMenuViewController", bundle: nil)
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.pushViewController(bookTest, animated: true)
    }
}
