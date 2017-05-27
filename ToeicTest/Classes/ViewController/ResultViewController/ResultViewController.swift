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
    var scoreTimer: NSTimer?
    var listeningScore: Int = 0
    var listeningButtonScore: Int = 5
    var readingScore: Int = 0
    var readingButtonScore: Int = 5
    var formSheetController: MZFormSheetPresentationViewController?
    var interstitial: GADInterstitial!
    
    // MARK: - Cycle life
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        DatabaseManager().loadScoreListenning(Constants.databaseName, numberAnswerTrue: TestViewController.numberListenngTrue) { (status, data) in
            if status {
                self.listeningScore = data as! Int
            }
        }
        
        DatabaseManager().loadScoreReading(Constants.databaseName, numberAnswerTrue: TestViewController.numberReadingTrue) { (status, data) in
            if status {
                 self.readingScore = data as! Int
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if DatabaseManager().checkAccountSave(Constants.databaseName) == true {
            userImageView.image = Constants.getImage()
            userNameLabel.text = HomeViewController.userData?.name
        }

        localizable()
        createAndLoadInterstitial()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func createAndLoadInterstitial() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-8928391130390155/3398997629")
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.loadRequest(request)
    }

    func interstitialDidReceiveAd(ad: GADInterstitial!) {
        ad.presentFromRootViewController(self)
        closeButton.enabled = true
    }
    
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        closeButton.enabled = true
        startScore()
    }
    
    func interstitialDidFailToPresentScreen(ad: GADInterstitial!) {
        closeButton.enabled = true
        startScore()
    }
    
    func interstitial(ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
        closeButton.enabled = true
        startScore()
    }
   
    // Mark: Funcion
    func localizable() {
        reviewButton.setTitle(Constants.LANGTEXT("RESULT_REVIEW"), forState: .Normal)
        scoreButton.setTitle(Constants.LANGTEXT("RESULT_SCORE"), forState: .Normal)
        closeButton.setTitle(Constants.LANGTEXT("COMMON_CLOSE"), forState: .Normal)
    }
    
    func startScore() {
        scoreTimer = NSTimer.scheduledTimerWithTimeInterval(0.03, target: self, selector: #selector(scoreAnimation), userInfo: nil, repeats: true)
    }
    
    func scoreAnimation() {
            if listeningButtonScore < listeningScore {
                listeningButtonScore = listeningButtonScore + 5
                self.scoreListening.setTitle(String(format: "%i", listeningButtonScore), forState: .Normal)
                self.scoreListening.frame.origin.x =   self.scoreListening.frame.origin.x + scoreLineListening.frame.size.width*5/495
            }
            if readingButtonScore < readingScore {
                readingButtonScore = readingButtonScore + 5
                self.scoreReading.setTitle(String(format: "%i", readingButtonScore), forState: .Normal)
                self.scoreReading.frame.origin.x =   self.scoreReading.frame.origin.x + scoreLineReading.frame.size.width*5/495
            }
            if listeningButtonScore >= listeningScore && readingButtonScore >= readingScore {
                stopScore()
                let totalScore = readingButtonScore+listeningButtonScore
                totalScoreButton.setTitle(String(format: "%i", totalScore), forState: .Normal)
                if totalScore > TestViewController.testData?.highScore {
                    DatabaseManager().updateHighScore(Constants.databaseName, bookID: BaseViewController.bookID!, testID: BaseViewController.testID!, score: totalScore)
                    Constants.showAlertView(Constants.LANGTEXT("RESULT_HIGHSCORE"), message: Constants.LANGTEXT("RESULT_HIGHSCORE_MESSAGE")+String(format: "%i", totalScore))
                }
            }
    }
    
    func stopScore() {
        scoreTimer?.invalidate()
    }
    
    
    // MARK: - Button action
    @IBAction func showScoreSlected(sender: AnyObject) {
        let scoreVC = ScoreToeicViewController(nibName: "ScoreToeicViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: scoreVC)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.navigationBar.barTintColor = UIColor.blueColor()
        formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController!.presentationController!.landscapeTopInset = 20
        formSheetController!.presentationController?.contentViewSize = CGSizeMake(Constants.SCREEN_WIDTH*3/5, Constants.SCREEN_HEIGHT-40)
        formSheetController!.allowDismissByPanningPresentedView = true
        formSheetController!.presentationController!.shouldDismissOnBackgroundViewTap = true
        formSheetController!.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.SlideFromTop
        self.presentViewController(formSheetController!, animated: true, completion: nil)
    }
    
    @IBAction func reviewSelected(sender: AnyObject) {
        let part1 = Part1ViewController(nibName: "Part1ViewController", bundle: nil)
        HomeViewController.status = TestStatus.review
        self.navigationController?.pushViewController(part1, animated: true)
    }
    
    @IBAction func menuButtonSelected(sender: AnyObject) {
        let viewcontroller = self.navigationController?.viewControllers[1]
        self.navigationController?.popToViewController(viewcontroller!, animated: true)
    }

    @IBAction func facebooShareSelected(sender: AnyObject) {
        let facebookOGJ = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        facebookOGJ.addImage(UIImage(view: self.resultView))
        self.presentViewController(facebookOGJ, animated: true, completion: nil)
    }

    @IBAction func twiterShareSelected(sender: AnyObject) {
        let tweetSheetOGJ = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        tweetSheetOGJ.addImage(UIImage(view: self.resultView))
        self.presentViewController(tweetSheetOGJ, animated: true, completion: nil)
    }
}
