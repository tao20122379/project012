//
//  AccountViewController.swift
//  ToeicTest
//
//  Created by khactao on 4/26/17.
//
//

import UIKit

class AccountViewController: BaseViewController, UINavigationControllerDelegate {

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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.colorFromHexString("2BA8E5")
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizable()
        userImage.image = Constants.getImage()
        Constants.setCornerLayer(userImage)
        userNameLabel.text = Constants.userData?.name
        maleButton.setImage(UIImage(named: "unchecked"), for: UIControlState())
        maleButton.setImage(UIImage(named: "checked"), for: UIControlState.selected)
        maleButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        maleButton.tag = 0
        femaleButton.setImage(UIImage(named: "unchecked"), for: UIControlState())
        femaleButton.setImage(UIImage(named: "checked"), for: UIControlState.selected)
        femaleButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        femaleButton.tag = 1
        maleButton.groupButtons = [maleButton, femaleButton]
        if Constants.userData?.sex == .male {
            maleButton.setSelected(true)
        }
        else {
            femaleButton.setSelected(true)
        }
        userNameLabel.text = Constants.userData?.name
        photoButton.setTitle(Constants.LANGTEXT("RESULT_UPDATE"), for: UIControlState())
        maleLabel.text = Constants.LANGTEXT("RESULT_MALE")
        femaleLabel.text = Constants.LANGTEXT("RESULT_FEMALE")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Funcion
    func localizable() {
        loginLogout.setTitle(Constants.LANGTEXT("LOGIN_LOGOUT"), for: UIControlState())
    }
    
    // MARK: - Button Action
    @IBAction func logOutSelected(_ sender: AnyObject) {
        DatabaseManager().logOut(Constants.databaseName, user: self.user!)
        Constants.saveUserImage(UIImage(named: "user")!)
        Constants.userData = UserModel()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func photoSelected(_ sender: AnyObject) {
        let picker = TNKImagePickerController()
        picker.pickerDelegate = self
        let nav = UINavigationController(rootViewController: picker)
        nav.isToolbarHidden = false
        nav.modalPresentationStyle = .popover
        nav.popoverPresentationController!.sourceView = self.photoButton
        nav.popoverPresentationController!.sourceRect = self.photoButton.bounds
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func maleSelected(_ sender: AnyObject) {
        DatabaseManager().updateUserSex(Constants.databaseName, sex: sender.tag, email: (Constants.userData?.email)!)
    }
}

// MARK: - PieckerTNK image
extension AccountViewController: TNKImagePickerControllerDelegate {
    func imagePickerController(_ picker: TNKImagePickerController, didSelect assets: [PHAsset]) {
    
        PHImageManager().requestImage(for: assets.last!, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode(rawValue: 2)!, options: nil) { (image, datas) in
            Constants.saveUserImage(image!)
            self.userImage.image = Constants.getImage()
        }
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
}
