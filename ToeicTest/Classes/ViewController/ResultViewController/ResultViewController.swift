//
//  ResultViewController.swift
//  ToeicTest
//
//  Created by khactao on 1/5/17.
//
//

import UIKit
import MZFormSheetPresentationController
import FBSDKShareKit
import FBSDKCoreKit
import Social
import GoogleMobileAds
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
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

class ResultViewController: UIViewController, GADInterstitialDelegate {

    // MARK: - IBOuleft and variable
    @IBOutlet weak var scoreListening: UIButton!
    @IBOutlet weak var scoreReading: UIButton!
    @IBOutlet weak var scoreLineListening: UIImageView!
    @IBOutlet weak var scoreLineReading: UIImageView!
    @IBOutlet weak var totalScoreButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var facebookShareButton: UIButton!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var scoreButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    var scoreTimer: Timer?
    var listeningScore: Int = 0
    var listeningButtonScore: Int = 5
    var readingScore: Int = 0
    var readingButtonScore: Int = 5
    var formSheetController: MZFormSheetPresentationViewController?
    var interstitial: GADInterstitial!
    
    // MARK: - Cycle life
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DatabaseManager().loadScoreListenning(Constants.databaseName, numberAnswerTrue: Constants.numberListenngTrue) { (status, data) in
            if status {
                self.listeningScore = data as! Int
            }
        }
        DatabaseManager().loadScoreReading(Constants.databaseName, numberAnswerTrue: Constants.numberReadingTrue) { (status, data) in
            if status {
                 self.readingScore = data as! Int
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if DatabaseManager().checkAccountSave(Constants.databaseName) == true {
            userImageView.image = Constants.getImage()
            userNameLabel.text = Constants.userData?.name
        }
        localizable()
        createAndLoadInterstitial()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startScore()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    fileprivate func createAndLoadInterstitial() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-8928391130390155/3398997629")
        interstitial.delegate = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        //interstitial.loadRequest(request)
        closeButton.isEnabled = true
    }

    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        ad.present(fromRootViewController: self)
        closeButton.isEnabled = true
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        closeButton.isEnabled = true
        
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        closeButton.isEnabled = true
        startScore()
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        closeButton.isEnabled = true
        startScore()
    }
   
    // Mark: Funcion
    func localizable() {
        reviewButton.setTitle(Constants.LANGTEXT("RESULT_REVIEW"), for: UIControlState())
        scoreButton.setTitle(Constants.LANGTEXT("RESULT_SCORE"), for: UIControlState())
        closeButton.setTitle(Constants.LANGTEXT("COMMON_CLOSE"), for: UIControlState())
    }
    
    func startScore() {
        scoreTimer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(scoreAnimation), userInfo: nil, repeats: true)
    }
    
    func scoreAnimation() {
            if listeningButtonScore < listeningScore {
                listeningButtonScore = listeningButtonScore + 5
                self.scoreListening.setTitle(String(format: "%i", listeningButtonScore), for: UIControlState())
                self.scoreListening.frame.origin.x =   self.scoreListening.frame.origin.x + scoreLineListening.frame.size.width*5/495
            }
            if readingButtonScore < readingScore {
                readingButtonScore = readingButtonScore + 5
                self.scoreReading.setTitle(String(format: "%i", readingButtonScore), for: UIControlState())
                self.scoreReading.frame.origin.x =   self.scoreReading.frame.origin.x + scoreLineReading.frame.size.width*5/495
            }
            if listeningButtonScore >= listeningScore && readingButtonScore >= readingScore {
                stopScore()
                let totalScore = readingButtonScore+listeningButtonScore
                totalScoreButton.setTitle(String(format: "%i", totalScore), for: UIControlState())
                if totalScore > Constants.testData?.highScore {
                    DatabaseManager().updateHighScore(Constants.databaseName, bookID: Constants.bookID!, testID: Constants.testID!, score: totalScore)
                    Constants.showAlertView(Constants.LANGTEXT("RESULT_HIGHSCORE"), message: Constants.LANGTEXT("RESULT_HIGHSCORE_MESSAGE")+String(format: "%i", totalScore))
                }
            }
    }
    
    func stopScore() {
        scoreTimer?.invalidate()
    }
    
    
    // MARK: - Button action
    @IBAction func showScoreSlected(_ sender: AnyObject) {
        let scoreVC = ScoreToeicViewController(nibName: "ScoreToeicViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: scoreVC)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.navigationBar.barTintColor = UIColor.blue
        formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController!.presentationController!.landscapeTopInset = 20
        formSheetController!.presentationController?.contentViewSize = CGSize(width: Constants.SCREEN_WIDTH*3/5, height: Constants.SCREEN_HEIGHT-40)
        formSheetController!.allowDismissByPanningPresentedView = true
        formSheetController!.presentationController!.shouldDismissOnBackgroundViewTap = true
        formSheetController!.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.slideFromTop
        self.present(formSheetController!, animated: true, completion: nil)
    }
    
    @IBAction func reviewSelected(_ sender: AnyObject) {
        let part1 = Part1ViewController(nibName: "Part1ViewController", bundle: nil)
        Constants.part6Index = 0
        Constants.status = TestStatus.review
        self.navigationController?.pushViewController(part1, animated: true)
    }
    
    @IBAction func menuButtonSelected(_ sender: AnyObject) {
        let viewcontroller = self.navigationController?.viewControllers[1]
        self.navigationController?.popToViewController(viewcontroller!, animated: true)
    }

    @IBAction func facebooShareSelected(_ sender: AnyObject) {
        let facebookOGJ = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        facebookOGJ?.add(UIImage(view: self.resultView))
        self.present(facebookOGJ!, animated: true, completion: nil)
    }

    @IBAction func twiterShareSelected(_ sender: AnyObject) {
        let tweetSheetOGJ = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        tweetSheetOGJ?.add(UIImage(view: self.resultView))
        self.present(tweetSheetOGJ!, animated: true, completion: nil)
    }
}
