//
//  TestViewController.swift
//  ToeicTest
//
//  Created by khactao on 3/27/17.
//
//

import UIKit

class TestViewController: UIViewController {

    // MARK: - IBOutleft and variable
    @IBOutlet weak var avatarImaeView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var buyDataButton: UIButton!
    @IBOutlet weak var buyDataLabel: BlinkLabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bookLabel: UILabel!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    var bookName: String?
    
    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        localizable()
        Constants.setCornerLayer(avatarImaeView)
        Constants.setLayer(startButton)
        checkAccount()
        Constants.numberListenngTrue = 0
        Constants.numberReadingTrue = 0
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: -funcion
    func localizable() {
        buyDataLabel.text = Constants.LANGTEXT("TEST_NOTE_DATA")
        startButton.setTitle(Constants.LANGTEXT("COMMON_START"), forState: .Normal)

    }
    
    func checkAccount() {
        if DatabaseManager().checkAccountSave(Constants.databaseName) == true {
            avatarImaeView.image = Constants.getImage()
            userNameLabel.text = Constants.userData?.name
        }
    }
    
    func loadData() {
        self.bookLabel.text = bookName
        self.testLabel.text = String(format: "Test %i", Constants.testID!)
        Constants.status = .test
        buyDataLabel.startBlinking()
        DatabaseManager().loadTestData(Constants.databaseName, bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
            if status {
                let testModel = datas as! TestModel
                Constants.testData = testModel
                self.highScoreLabel.text = Constants.LANGTEXT("TEST_HIGH_SCORE") + String(format: "%i", testModel.highScore)
                if testModel.numberPartData == 7 {
                Constants.audioName = testModel.audioName
                Constants.iamgeName = testModel.imageName
                self.startButton.enabled = true
                self.loadDataPart1()
                }
                else {
                    self.buyDataLabel.hidden = false
                    self.startButton.backgroundColor = UIColor.lightGrayColor()
                    self.startButton.enabled = false
                }
            }
            else  {
                self.buyDataLabel.hidden = false
                self.startButton.backgroundColor = UIColor.lightGrayColor()
                self.startButton.enabled = false
            }
        }
    }
    
    func loadDataPart1() {
        startButton.userInteractionEnabled = false
        startButton.alpha = 0.5
        DatabaseManager().loadPart1Data("toeic_test", bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
            if status == true {
                Constants.questionPar1List = datas as! Array<Part1Model>
                self.loadDataPart2()
            }
        }
    }
    
    func loadDataPart2() {
        DatabaseManager().loadPart2Data("toeic_test", bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
            if status == true {
                Constants.questionPar2List = datas as! Array<Part2Model>
                self.loadDataPart3()
            }
        }
    }
    
    func loadDataPart3() {
        DatabaseManager().loadPart3Data("toeic_test", bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
            if status == true {
                Constants.questionPar3List = datas as! Array<Part34Model>
                self.loadDataPart4()
            }
        }
    }
    
    func loadDataPart4() {
        DatabaseManager().loadPart4Data("toeic_test", bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
            if status == true {
                Constants.questionPar4List = datas as! Array<Part34Model>
                self.loadDataPart5()
            }
        }
    }
    
    func loadDataPart5() {
        DatabaseManager().loadPart5Data("toeic_test", bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
            if status == true {
                Constants.questionPar5List = datas as! Array<Part34Model>
                self.loadDataPart6()
            }
        }
    }
    
    func loadDataPart6() {
        DatabaseManager().loadPart6Data("toeic_test", bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
            if status == true {
                Constants.questionPar6List = (datas as? Array<Part6Model>)!
                self.loadDataPart7()
            }
        }
    }
    
    
    func loadDataPart7() {
        if Constants.bookID! <= 2 {
            DatabaseManager().loadPart7Data("toeic_test", bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
                if status == true {
                    Constants.questionPar7List = datas as! Array<Part7Model>
                    self.startButton.userInteractionEnabled = true
                    self.startButton.alpha = 1
                }
            }
        }
        else {
            DatabaseManager().loadPart7Data("toeic_test", bookID: 1, testID: 1) { (status, datas) in
                if status == true {
                    Constants.questionPar7List = datas as! Array<Part7Model>
                    self.startButton.userInteractionEnabled = true
                    self.startButton.alpha = 1
                }
            }
        }
    }

    // MARK: - Button Action
    @IBAction func startSeleted(sender: AnyObject) {
        let part1 = Part1ViewController.shareTest
        part1.isNewTest = true
        self.navigationController?.pushViewController(part1, animated: true)
    }
    
    
    

}