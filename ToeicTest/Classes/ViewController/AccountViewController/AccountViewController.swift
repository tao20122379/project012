//
//  AccountViewController.swift
//  ToeicTest
//
//  Created by khactao on 4/26/17.
//
//

import UIKit

class AccountViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: - IBOutlet and variable
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var femaleButton: RadioButton!
    @IBOutlet weak var maleButton: RadioButton!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var loginLogout: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    var user: UserModel?

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
        userImage.image = Constants.getImage()
        Constants.setCornerLayer(userImage)
        userNameLabel.text = Constants.userData?.name
        maleButton.setImage(UIImage(named: "unchecked"), forState: UIControlState.Normal)
        maleButton.setImage(UIImage(named: "checked"), forState: UIControlState.Selected)
        maleButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        maleButton.tag = 0
        femaleButton.setImage(UIImage(named: "unchecked"), forState: UIControlState.Normal)
        femaleButton.setImage(UIImage(named: "checked"), forState: UIControlState.Selected)
        femaleButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        femaleButton.tag = 1
        maleButton.groupButtons = [maleButton, femaleButton]
        if Constants.userData?.sex == .male {
            maleButton.setSelected(true)
        }
        else {
            femaleButton.setSelected(true)
        }
        userNameLabel.text = Constants.userData?.name
        photoButton.setTitle(Constants.LANGTEXT("RESULT_UPDATE"), forState: .Normal)
        maleLabel.text = Constants.LANGTEXT("RESULT_MALE")
        femaleLabel.text = Constants.LANGTEXT("RESULT_FEMALE")
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
        Constants.saveUserImage(UIImage(named: "user")!)
        Constants.userData = UserModel()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func photoSelected(sender: AnyObject) {
        let picker = TNKImagePickerController()
        picker.pickerDelegate = self
        let nav = UINavigationController(rootViewController: picker)
        nav.toolbarHidden = false
        nav.modalPresentationStyle = .Popover
        nav.popoverPresentationController!.sourceView = self.photoButton
        nav.popoverPresentationController!.sourceRect = self.photoButton.bounds
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    @IBAction func maleSelected(sender: AnyObject) {
        DatabaseManager().updateUserSex(Constants.databaseName, sex: sender.tag, email: (Constants.userData?.email)!)
    }
}

extension AccountViewController: TNKImagePickerControllerDelegate {
    func imagePickerController(picker: TNKImagePickerController, didSelectAssets assets: [PHAsset]) {
        PHImageManager().requestImageForAsset(assets.last!, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.Default, options: nil) { (image, datas) in
            Constants.saveUserImage(image!)
            self.userImage.image = Constants.getImage()
        }
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
}
