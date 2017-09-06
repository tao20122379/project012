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

class HomeViewController: UIViewController, Login_Delegate {
    
    // MARK: - IBOuleft and variable
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
    var mp3Player: MP3Player?
    var items = NSArray()
    var testID: Int?

    // MARK: - Cycle life
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addMenu()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setBorderImage(listImage1)
        setBorderImage(grammarImage)
        setBorderImage(practiceImage)
        setBorderImage(testImage)
        setBorderImage(test700Image)
        setBorderImage(toeic700Image)
        Constants.bookID = 3
        Constants.testID = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Constants.mp3Player = MP3Player()
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
                    Constants.userData = user
                }
            })
        }
        else {
            let imageView = UIImage(named: "user")
            Constants.saveUserImage(imageView!)
        }
    }
    
    func addTranslateText() {
        let myMenuController: UIMenuController = UIMenuController.shared
        myMenuController.isMenuVisible = true
        let myMenuItem_1: UIMenuItem = UIMenuItem(title: "translate", action: #selector(Part7HeaderView.translate(_:)))
        let myMenuItems: NSArray = [myMenuItem_1]
        myMenuController.menuItems = myMenuItems as? [UIMenuItem]
    }
    
    func setBorderImage(_ imageView: UIImageView) {
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
    }

    func addMenu() {
        let menuButtonSize: CGSize = CGSize(width: 40.0, height: 40.0)
        let menuButton = ExpandingMenuButton(frame:  CGRect(origin: CGPoint.zero, size: menuButtonSize), centerImage: UIImage(named: "menu")!, centerHighlightedImage: UIImage(named: "menu")!)
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
    
    func localizable() {
        grammarButton.setTitle(Constants.LANGTEXT("HOME_GRAMMAR"), for: UIControlState())
        practiceButton.setTitle(Constants.LANGTEXT("HOME_PRACTICE"), for: UIControlState())
        testButton.setTitle(Constants.LANGTEXT("HOME_TEST"), for: UIControlState())
        test700Button.setTitle(Constants.LANGTEXT("HOME_TEST"), for: UIControlState())
    }
    
    func showlistMenu() {
        UIView.animate(withDuration: 0.4, animations: {
            self.listImage1.transform = CGAffineTransform(translationX: 200, y: 0)
            self.toeic450Button.transform = CGAffineTransform(translationX: 200, y: 0)
        }, completion: { (true) in
            UIView.animate(withDuration: 0.4, animations: {
                self.grammarImage.transform = CGAffineTransform(translationX: 230, y: 0)
                self.grammarButton.transform = CGAffineTransform(translationX: 230, y: 0)
            }, completion: { (true) in
                UIView.animate(withDuration: 0.4, animations: {
                    self.practiceImage.transform = CGAffineTransform(translationX: 230, y: 0)
                    self.practiceButton.transform = CGAffineTransform(translationX: 230, y: 0)
                }, completion: { (true) in
                    UIView.animate(withDuration: 0.4, animations: {
                        self.testImage.transform = CGAffineTransform(translationX: 230, y: 0)
                        self.testButton.transform = CGAffineTransform(translationX: 230, y: 0)
                    }, completion: { (true) in
                        UIView.animate(withDuration: 0.4, animations: {
                            self.toeic700Image.transform = CGAffineTransform(translationX: 200, y: 0)
                            self.toeic700Button.transform = CGAffineTransform(translationX: 200, y: 0)
                        }, completion: { (true) in
                            UIView.animate(withDuration: 0.4, animations: {
                                self.test700Image.transform = CGAffineTransform(translationX: 230, y: 0)
                                self.test700Button.transform = CGAffineTransform(translationX: 230, y: 0)
                            })
                        }) 
                    }) 
                }) 
            }) 
        }) 
    }
    


    // MARK: - Delegate
    func menuSelect(_ menu: Int) {
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
                self.navigationController?.navigationBar.isHidden = false
                self.navigationController?.present(loginVC, animated: true, completion: nil)
            }
            break
        case 2:
            let bookTest = GrammarViewController(nibName: "GrammarViewController", bundle: nil)
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.pushViewController(bookTest, animated: true)
            break
        case 3:
            let bookTest = PracticeViewController(nibName: "PracticeViewController", bundle: nil)
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.pushViewController(bookTest, animated: true)
            break
        case 4:
            let bookTest = TestMenuViewController(nibName: "TestMenuViewController", bundle: nil)
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.pushViewController(bookTest, animated: true)
            break
        default:
            break
        }
    }
    
    func loginSuccess(_ user: UserModel) {
        let accountVC = AccountViewController(nibName: "AccountViewController", bundle: nil)
        accountVC.user = user
        Constants.userData = user
        DatabaseManager().login(Constants.databaseName, user: user)
        self.navigationController?.pushViewController(accountVC, animated: true)
    }
    
    // MARK: - Button action
    @IBAction func grammarSelected(_ sender: AnyObject) {
        let bookTest = GrammarViewController(nibName: "GrammarViewController", bundle: nil)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(bookTest, animated: true)
    }
    
    @IBAction func practiceSelected(_ sender: AnyObject) {
        let bookTest = PracticeViewController(nibName: "PracticeViewController", bundle: nil)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(bookTest, animated: true)
    }
    
    @IBAction func testSelected(_ sender: AnyObject) {
        let bookTest = TestMenuViewController(nibName: "TestMenuViewController", bundle: nil)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(bookTest, animated: true)
    }
    
    @IBAction func test700Selected(_ sender: AnyObject) {
        let bookTest = TestMenuViewController(nibName: "TestMenuViewController", bundle: nil)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(bookTest, animated: true)
    }
}

