//
//  LoginViewController.swift
//  ToeicTest
//
//  Created by khactao on 5/2/17.
//
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleMobileAds
//import GoogleSignIn

protocol Login_Delegate {
    func loginSuccess(user: UserModel)
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOleft and variable
    var delegate: Login_Delegate?
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginwithLabel: UILabel!
    @IBOutlet weak var welcomLabel: UILabel!
    var interstiial: GADInterstitial!
    
    // MARKK: - Cycle life
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.colorFromHexString("6A5440")
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        passwordTextField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginFacebook()
        localizable()
       //GIDSignIn.sharedInstance().uiDelegate = self
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID]
        interstiial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstiial.loadRequest(request)
        if interstiial.isReady {
            interstiial.presentFromRootViewController(self)
        }
        else {
            NSLog("not already")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Funcion
    func localizable() {
        welcomLabel.text = Constants.LANGTEXT("LOGIN_TITLE")
        userLabel.text = Constants.LANGTEXT("LOGIN_USER")
        passwordLabel.text = Constants.LANGTEXT("LOGIN_PASSWORD")
        loginwithLabel.text = Constants.LANGTEXT("LOGIN_WITH")
        loginButton.setTitle(Constants.LANGTEXT("LOGIN_BUTTON"), forState: .Normal)
        Constants.setLayer(loginButton)
    }
    
    func loginFacebook() {
        Constants.loginState = LoginState.Facebook
        let loginManager = FBSDKLoginManager()
        loginManager.logInWithReadPermissions(["public_profile", "email", "user_friends"], fromViewController: self) { (result, error) in
            if (error != nil) {
            }
            else if (result.isCancelled) {
                print("isCancelled")
            }
            else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,id,first_name,last_name"], tokenString: accessToken, version: nil, HTTPMethod: "GET")
                request.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
                    if error == nil, let result = result as? NSDictionary {
                        let firstName = result["first_name"] as! String
                        let lastName = result["last_name"] as! String
                        let user = UserModel()
                        user.fid = result["id"] as! String
                        user.email = result["email"] as! String
                        user.name = firstName + " " + lastName
                        user.image = Constants.getProfPic(user.fid)
                        DatabaseManager().addUser(Constants.databaseName, user: user)
                        self.dismissViewControllerAnimated(true, completion: {
                            self.delegate?.loginSuccess(user)
                        })
                    }
                    else {
                    }
                })
            }
        }
        
    }
    
    // MARK: - Delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
//    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
//        if error != nil {
//            print("signInWillDispatch\(error.localizedDescription)")
//        }
//        
//    }

//    
//    // Present a view that prompts the user to sign in with Google
//    func signIn(signIn: GIDSignIn!,
//                presentViewController viewController: UIViewController!) {
//        self.presentViewController(viewController, animated: true, completion: nil)
//    }
//    
//    // Dismiss the "Sign in with Google" view
//    func signIn(signIn: GIDSignIn!,
//                dismissViewController viewController: UIViewController!) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
//        if (error == nil) {
//            // Perform any operations on signed in user here.
//        } else {
//            
//        }
//    }

    // MARK: - Button Action
    @IBAction func facebookSelected(sender: AnyObject) {
        loginFacebook()
    }
    
    @IBAction func canceSelected(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func loginSelected(sender: AnyObject) {
        if DatabaseManager().checkAccount(Constants.databaseName, userName: userTextField.text!, password: passwordTextField.text!) {
            DatabaseManager().getUserData(Constants.databaseName, userName: userTextField.text!, completionHandler: { (status, data) in
                if status {
                    let user = data as? UserModel
                    self.dismissViewControllerAnimated(true, completion: {
                        self.delegate?.loginSuccess(user!)
                    })
                }
            })
        }
        else {
            Constants.showAlertView("Login Faild", message: "User or Password Faild")
        }
    }
    
    @IBAction func googleSelected(sender: AnyObject) {
//        GIDSignIn.sharedInstance().clientID = "1090167895363-r3c0irnm4a3m2qa0tc6pi4tik90ensk5.apps.googleusercontent.com"
//        GIDSignIn.sharedInstance().signIn()
    }

}
