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

protocol Login_Delegate {
    func loginSuccess(_ user: UserModel)
}

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlet and variable
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.colorFromHexString("6A5440")
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        passwordTextField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginFacebook()
        localizable()
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
        loginButton.setTitle(Constants.LANGTEXT("LOGIN_BUTTON"), for: UIControlState())
        Constants.setLayer(loginButton)
    }
    
    func loginFacebook() {
        Constants.loginState = LoginState.facebook
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (result, error) in
            if (error != nil) {
            }
            else if (result?.isCancelled)! {
                print("isCancelled")
            }
            else {
                let accessToken = FBSDKAccessToken.current().tokenString
                let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,id,first_name,last_name"], tokenString: accessToken, version: nil, httpMethod: "GET")
                request?.start(completionHandler: { (conection, result, error) in
                    if error == nil, let result = result as? NSDictionary {
                        let firstName = result["first_name"] as! String
                        let lastName = result["last_name"] as! String
                        let user = UserModel()
                        user.email = result["email"] as! String
                        user.name = firstName + " " + lastName
                        user.birdDay = "27 th 2 1994"
                        let id = result["id"] as! String
                        let image = Constants.getProfPic(id)
                        Constants.saveUserImage(image!)
                        DatabaseManager().addUser(Constants.databaseName, user: user)
                        
                        self.dismiss(animated: true, completion: {
                            self.delegate?.loginSuccess(user)
                        })
                    }
                    else {
                    }

                })
                

            }
        }
    }

    // MARK: - Button Action
    @IBAction func facebookSelected(_ sender: AnyObject) {
        loginFacebook()
    }
    
    @IBAction func canceSelected(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginSelected(_ sender: AnyObject) {
        if DatabaseManager().checkAccount(Constants.databaseName, userName: userTextField.text!, password: passwordTextField.text!) {
            DatabaseManager().getUserData(Constants.databaseName, userName: userTextField.text!, completionHandler: { (status, data) in
                if status {
                    let user = data as? UserModel
                    self.dismiss(animated: true, completion: {
                        self.delegate?.loginSuccess(user!)
                    })
                }
            })
        }
        else {
            Constants.showAlertView("Login Faild", message: "User or Password Faild")
        }
    }
    
    @IBAction func googleSelected(_ sender: AnyObject) {
    
    }

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
