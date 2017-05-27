//
//  AccountViewController.swift
//  ToeicTest
//
//  Created by khactao on 4/26/17.
//
//

import UIKit

class AccountViewController: UIViewController {

    // MARK: - IBOutleft
    @IBOutlet weak var userImage: UIImageView!
    var user: UserModel?
    @IBOutlet weak var loginLogout: UIButton!
    
    // MARK: - Cycle Life
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.colorFromHexString("2BA8E5")
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizable()
        if user?.fid != "" && user!.fid != nil{
             userImage.image = Constants.getProfPic(user!.fid)
        }
        else {
            userImage.image = UIImage(named: (user?.imageName)!)
        }
        HomeViewController.userData!.image = userImage.image
        Constants.setCornerLayer(userImage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Funcion
    func localizable() {
        loginLogout.setTitle(Constants.LANGTEXT("LOGIN_LOGOUT"), forState: .Normal)
    }
    
    // MARK: - Button Action
    @IBAction func logOutSelected(sender: AnyObject) {
        DatabaseManager().logOut(Constants.databaseName, user: self.user!)
        HomeViewController.userData = UserModel()
        self.navigationController?.popViewControllerAnimated(true)
    }

}
