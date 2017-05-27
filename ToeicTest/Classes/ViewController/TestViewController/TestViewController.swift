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
    static var testData: TestModel?
    static var questionPar1List: Array = Array<Part1Model>()
    static var questionPar2List: Array = Array<Part2Model>()
    static var questionPar3List: Array = Array<Part34Model>()
    static var questionPar4List: Array = Array<Part34Model>()
    static var questionPar5List: Array = Array<Part34Model>()
    static var questionPar6List: Array = Array<Part6Model>()
    static var questionPar7List: Array = Array<Part7Model>()
    static var numberListenngTrue: Int = 0
    static var numberReadingTrue: Int = 0
    static var bookData: BookModel?
    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        localizable()
        Constants.setCornerLayer(avatarImaeView)
        Constants.setLayer(startButton)
        checkAccount()
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
            userNameLabel.text = HomeViewController.userData?.name
        }
    }
    
    func loadData() {
        self.bookLabel.text = bookName
        self.testLabel.text = String(format: "Test %i", BaseViewController.testID!)
        HomeViewController.status = .test
        TestViewController.numberListenngTrue = 0
        TestViewController.numberReadingTrue = 0
        buyDataLabel.startBlinking()
        DatabaseManager().loadTestData(Constants.databaseName, bookID: BaseViewController.bookID!, testID: BaseViewController.testID!) { (status, datas) in
            if status {
                let testModel = datas as! TestModel
                TestViewController.testData = testModel
                self.highScoreLabel.text = Constants.LANGTEXT("TEST_HIGH_SCORE") + String(format: "%i", testModel.highScore)
                if testModel.numberPartData == 7 {
                BaseViewController.audioName = testModel.audioName
                BaseViewController.iamgeName = testModel.imageName
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
        DatabaseManager().loadPart1Data("toeic_test", bookID: BaseViewController.bookID!, testID: BaseViewController.testID!) { (status, datas) in
            if status == true {
                TestViewController.questionPar1List = datas as! Array<Part1Model>
                self.loadDataPart2()
            }
        }
    }
    
    func loadDataPart2() {
        DatabaseManager().loadPart2Data("toeic_test", bookID: BaseViewController.bookID!, testID: BaseViewController.testID!) { (status, datas) in
            if status == true {
                TestViewController.questionPar2List = datas as! Array<Part2Model>
                self.loadDataPart3()
            }
        }
    }
    
    func loadDataPart3() {
        DatabaseManager().loadPart3Data("toeic_test", bookID: BaseViewController.bookID!, testID: BaseViewController.testID!) { (status, datas) in
            if status == true {
                TestViewController.questionPar3List = datas as! Array<Part34Model>
                self.loadDataPart4()
            }
        }
    }
    
    func loadDataPart4() {
        DatabaseManager().loadPart4Data("toeic_test", bookID: BaseViewController.bookID!, testID: BaseViewController.testID!) { (status, datas) in
            if status == true {
                TestViewController.questionPar4List = datas as! Array<Part34Model>
                self.loadDataPart5()
            }
        }
    }
    
    func loadDataPart5() {
        DatabaseManager().loadPart5Data("toeic_test", bookID: BaseViewController.bookID!, testID: BaseViewController.testID!) { (status, datas) in
            if status == true {
                TestViewController.questionPar5List = datas as! Array<Part34Model>
                self.loadDataPart6()
            }
        }
    }
    
    func loadDataPart6() {
        DatabaseManager().loadPart6Data("toeic_test", bookID: BaseViewController.bookID!, testID: BaseViewController.testID!) { (status, datas) in
            if status == true {
                TestViewController.questionPar6List = (datas as? Array<Part6Model>)!
                self.loadDataPart7()
            }
        }
    }
    
    
    func loadDataPart7() {
        if BaseViewController.bookID! <= 2 {
            DatabaseManager().loadPart7Data("toeic_test", bookID: BaseViewController.bookID!, testID: BaseViewController.testID!) { (status, datas) in
                if status == true {
                    TestViewController.questionPar7List = datas as! Array<Part7Model>
                    self.startButton.userInteractionEnabled = true
                    self.startButton.alpha = 1
                }
            }
        }
        else {
            DatabaseManager().loadPart7Data("toeic_test", bookID: 1, testID: 1) { (status, datas) in
                if status == true {
                    TestViewController.questionPar7List = datas as! Array<Part7Model>
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