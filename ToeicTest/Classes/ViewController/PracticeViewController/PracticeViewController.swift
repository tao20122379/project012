//
//  PracticeViewController.swift
//  ToeicTest
//
//  Created by khactao on 4/26/17.
//
//

import UIKit
import MZFormSheetPresentationController
import YLProgressBar

class PracticeViewController: UIViewController {

    // MARK: - Variable and IBOutlet
    @IBOutlet weak var part1Button: UIButton!
    @IBOutlet weak var part2Button: UIButton!
    @IBOutlet weak var part3Button: UIButton!
    @IBOutlet weak var part4Button: UIButton!
    @IBOutlet weak var part5Button: UIButton!
    @IBOutlet weak var part6Button: UIButton!
    @IBOutlet weak var part7Button: UIButton!
    @IBOutlet weak var exerciseSegment: UISegmentedControl!
    @IBOutlet weak var startButton: UIButton!
    
    var selected: Int = 0
    var part: Int = 1
    var listBook = Array<BookModel>()
    var testData:TestModel?
    var formSheetController: MZFormSheetPresentationViewController?
    var isSingle: Bool = true
    
    // MARK: - Cycle life
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Constants.LANGTEXT("PRACTICE_TITLE")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.colorFromHexString("2BA8E5")
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        part1Button.tag = 1
        part2Button.tag = 2
        part3Button.tag = 3
        part4Button.tag = 4
        part5Button.tag = 5
        part6Button.tag = 6
        part7Button.tag = 7
        setLayer(startButton)
        Constants.status = .practice
        loadData(part)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DatabaseManager().loadTestData(Constants.databaseName, bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
            self.testData = datas as? TestModel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBook()
        setPracticeAnimation(1)
        localizable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Data
    func loadBook() {
        DatabaseManager().loadBookData(Constants.databaseName) { (status, datas) in
            if status {
                self.listBook = datas as! Array<BookModel>

            }
        }
    }

    func localizable() {
        startButton.setTitle(Constants.LANGTEXT("COMMON_START"), for: UIControlState())
    }
    
    func setLayer(_ sender: AnyObject) {
        sender.layer.cornerRadius = sender.frame.size.height/2
        sender.layer.masksToBounds = true
    }
    
    func setPracticeAnimation(_ index: Int) {
        UIView.animate(withDuration: 0.4, animations: {
            self.part1Button.transform = CGAffineTransform(translationX: 0, y: 0)
            self.part2Button.transform = CGAffineTransform(translationX: 0, y: 0)
            self.part3Button.transform = CGAffineTransform(translationX: 0, y: 0)
            self.part4Button.transform = CGAffineTransform(translationX: 0, y: 0)
            self.part5Button.transform = CGAffineTransform(translationX: 0, y: 0)
            self.part6Button.transform = CGAffineTransform(translationX: 0, y: 0)
            self.part7Button.transform = CGAffineTransform(translationX: 0, y: 0)
        }) 
        switch index {
        case 1:
            UIView.animate(withDuration: 0.4, animations: {
                self.part = 1
                self.part1Button.transform = CGAffineTransform(translationX: 30, y: 0)
            }) 
            break
        case 2:
            UIView.animate(withDuration: 0.4, animations: {
                self.part = 2
                self.part2Button.transform = CGAffineTransform(translationX: 30, y: 0)
            }) 
            break
        case 3:
            UIView.animate(withDuration: 0.4, animations: {
                self.part = 3
                self.part3Button.transform = CGAffineTransform(translationX: 30, y: 0)
            }) 
            break
        case 4:
            UIView.animate(withDuration: 0.4, animations: {
                self.part = 4
                self.part4Button.transform = CGAffineTransform(translationX: 30, y: 0)
            }) 
            break
        case 5:
            UIView.animate(withDuration: 0.4, animations: {
                self.part = 5
                self.part5Button.transform = CGAffineTransform(translationX: 30, y: 0)
            }) 
            break
        case 6:
            UIView.animate(withDuration: 0.4, animations: {
                self.part = 6
                self.part6Button.transform = CGAffineTransform(translationX: 30, y: 0)
            }) 
            break
        case 7:
            UIView.animate(withDuration: 0.4, animations: {
                self.part = 7
                self.part7Button.transform = CGAffineTransform(translationX: 30, y: 0)
            }) 
            break
        default:
            break
        }
        
    }
    
    // MARK: - Button Action
    @IBAction func particeSelected(_ sender: AnyObject) {
        if selected != sender.tag {
            setPracticeAnimation(sender.tag)
        }
        selected = sender.tag
        DatabaseManager().loadTestData(Constants.databaseName, bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
            self.testData = datas as? TestModel
            Constants.audioName = self.testData!.audioName
            Constants.iamgeName = self.testData!.imageName
        }
        loadData(self.part)
    }

    @IBAction func paracticeStartSelected(_ sender: AnyObject) {
        if isSingle {
            let exerciseVC = ExerciseViewController(nibName: "ExerciseViewController", bundle: nil)
            self.navigationController?.pushViewController(exerciseVC, animated: true)
        }
        else {
            switch part {
            case 1:
                let part1 = Part1ViewController(nibName: "Part1ViewController", bundle: nil)
                part1.isNewTest = true
                self.navigationController?.pushViewController(part1, animated: true)
                break
            case 2:
                let part2 = Part2ViewController(nibName: "Part2ViewController", bundle: nil)
                self.navigationController?.pushViewController(part2, animated: true)
                break
            case 3:
                let part3 = Part3ViewController(nibName: "Part3ViewController", bundle: nil)
                self.navigationController?.pushViewController(part3, animated: true)
                break
            case 4:
                let part4 = Part4ViewController(nibName: "Part4ViewController", bundle: nil)
                self.navigationController?.pushViewController(part4, animated: true)
                break
            case 5:
                let part5 = Part5ViewController(nibName: "Part5ViewController", bundle: nil)
                self.navigationController?.pushViewController(part5, animated: true)
                break
            case 6:
                let part6 = Part6ViewController(nibName: "Part6ViewController", bundle: nil)
                self.navigationController?.pushViewController(part6, animated: true)
                break
            case 7:
                let part7 = Part7ViewController(nibName: "Part7ViewController", bundle: nil)
                self.navigationController?.pushViewController(part7, animated: true)
                break
            default:
                break
            }
        }

    }
    

    @IBAction func ExerciseSegmentSelected(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            isSingle = true
        }
        else {
            isSingle = false
        }
        
    }
    
    func loadData(_ part: Int) {
        self.startButton.isEnabled = false
        switch part {
        case 1:
            DatabaseManager().loadPart1Data(Constants.databaseName, bookID: Constants.bookID!, testID:  Constants.testID!) { (status, datas) in
                if status == true {
                    Constants.questionPar1List = datas as! Array<Part1Model>

                    self.startButton.isEnabled = true
                    self.startButton.backgroundColor = UIColor.colorFromHexString("68A200")
                }
                else {
                    self.startButton.isEnabled = false
                    self.startButton.backgroundColor = UIColor.lightGray
                }
            }
            break
        case 2:
            DatabaseManager().loadPart2Data("toeic_test", bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
                if status == true {
                    Constants.questionPar2List = datas as! Array<Part2Model>
                    self.startButton.isEnabled = true
                    self.startButton.backgroundColor = UIColor.colorFromHexString("68A200")
                }
                else {
                    self.startButton.isEnabled = false
                    self.startButton.backgroundColor = UIColor.lightGray
                }
            }
            break
        case 3:
            DatabaseManager().loadPart3Data("toeic_test", bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
                if status == true {
                    Constants.questionPar3List = datas as! Array<Part34Model>
                    self.startButton.isEnabled = true
                    self.startButton.backgroundColor = UIColor.colorFromHexString("68A200")
                }
                else {
                    self.startButton.isEnabled = false
                    self.startButton.backgroundColor = UIColor.lightGray
                }
            }
            break
        case 4:
            DatabaseManager().loadPart4Data("toeic_test", bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
                if status == true {
                    Constants.questionPar4List = datas as! Array<Part34Model>
                    self.startButton.isEnabled = true
                    self.startButton.backgroundColor = UIColor.colorFromHexString("68A200")
                }
                else {
                    self.startButton.isEnabled = false
                    self.startButton.backgroundColor = UIColor.lightGray
                }
            }
            break
        case 5:
            DatabaseManager().loadPart5Data("toeic_test", bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
                if status == true {
                    Constants.questionPar5List = datas as! Array<Part34Model>
                    self.startButton.isEnabled = true
                    self.startButton.backgroundColor = UIColor.colorFromHexString("68A200")
                }
                else {
                    self.startButton.isEnabled = false
                    self.startButton.backgroundColor = UIColor.lightGray
                }
            }
            break
        case 6:
            Constants.part6Index = 0
            DatabaseManager().loadPart6Data("toeic_test", bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
                if status == true {
                    Constants.questionPar6List = (datas as? Array<Part6Model>)!
                    self.startButton.isEnabled = true
                    self.startButton.backgroundColor = UIColor.colorFromHexString("68A200")
                }
                else {
                    self.startButton.isEnabled = false
                    self.startButton.backgroundColor = UIColor.lightGray
                }
            }
            break
        case 7:
            DatabaseManager().loadPart7Data("toeic_test", bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
                if status == true {
                    Constants.questionPar7List = datas as! Array<Part7Model>
                    self.startButton.isEnabled = true
                    self.startButton.backgroundColor = UIColor.colorFromHexString("68A200")
                }
                else {
                    self.startButton.isEnabled = false
                    self.startButton.backgroundColor = UIColor.lightGray
                }
            }
            break
        default:
            break
        }
    }
}





