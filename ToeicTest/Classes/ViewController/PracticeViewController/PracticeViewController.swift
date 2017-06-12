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
    @IBOutlet weak var bookTableView: UITableView!
    @IBOutlet weak var bookLabel: UILabel!
    @IBOutlet weak var testNumberLabel: UILabel!
    @IBOutlet weak var progress: YLProgressBar!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var dataLabel: BlinkLabel!
    
    var selected: Int = 0
    var part: Int = 1
    var listBook = Array<BookModel>()
    var testData:TestModel?
    var formSheetController: MZFormSheetPresentationViewController?
    
    // MARK: - Cycle life
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Constants.LANGTEXT("PRACTICE_TITLE")
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.colorFromHexString("2BA8E5")
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        part1Button.tag = 1
        part2Button.tag = 2
        part3Button.tag = 3
        part4Button.tag = 4
        part5Button.tag = 5
        part6Button.tag = 6
        part7Button.tag = 7
        bookTableView.delegate = self
        bookTableView.dataSource = self
        bookTableView.registerNib(UINib(nibName: "BookTableCell", bundle: nil), forCellReuseIdentifier: "cell")
        setLayer(startButton)
        Constants.status = .practice
        loadData(part)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        DatabaseManager().loadTestData(Constants.databaseName, bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
            self.testData = datas as? TestModel
            self.progressPartSelected(self.part, testModel: self.testData!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBook()
        self.ListTest_Selected(self.listBook[0], testID: 0)
        configProgeress()
        localizable()
        dataLabel.startBlinking()
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
    
    // MARK: - Funcion
    func configProgeress() {
        let tincolors: NSArray = [UIColor.colorFromHexString("66B3FF")]
        progress.progressTintColors       = tincolors as [AnyObject]
        progress.type                     = .Flat
        progress.indicatorTextDisplayMode = .FixedRight
        progress.indicatorTextLabel.textColor = UIColor.blueColor()
        progress.behavior                 = .Indeterminate
        progress.stripesOrientation       = .Vertical
        progress.layer.cornerRadius = 9
        progress.layer.masksToBounds = true
        progress.layer.borderWidth = 1
        progress.layer.borderColor = UIColor.lightGrayColor().CGColor
        selected = 1
        setPracticeAnimation(1)
    }
    
    func localizable() {
        bookLabel.text = Constants.LANGTEXT("COMMON_BOOK")
        experienceLabel.text = Constants.LANGTEXT("PRACTICE_EXPERIENCE")
        startButton.setTitle(Constants.LANGTEXT("COMMON_START"), forState: .Normal)
        dataLabel.text = Constants.LANGTEXT("PRACTICE_DATA_ERROR")
    }
    
    func setLayer(sender: AnyObject) {
        sender.layer.cornerRadius = sender.frame.size.height/2
        sender.layer.masksToBounds = true
    }
    
    func setPracticeAnimation(index: Int) {
        UIView.animateWithDuration(0.4) {
            self.part1Button.transform = CGAffineTransformMakeTranslation(0, 0)
            self.part2Button.transform = CGAffineTransformMakeTranslation(0, 0)
            self.part3Button.transform = CGAffineTransformMakeTranslation(0, 0)
            self.part4Button.transform = CGAffineTransformMakeTranslation(0, 0)
            self.part5Button.transform = CGAffineTransformMakeTranslation(0, 0)
            self.part6Button.transform = CGAffineTransformMakeTranslation(0, 0)
            self.part7Button.transform = CGAffineTransformMakeTranslation(0, 0)
        }
        switch index {
        case 1:
            UIView.animateWithDuration(0.4) {
                self.part = 1
                self.part1Button.transform = CGAffineTransformMakeTranslation(30, 0)
            }
            break
        case 2:
            UIView.animateWithDuration(0.4) {
                self.part = 2
                self.part2Button.transform = CGAffineTransformMakeTranslation(30, 0)
            }
            break
        case 3:
            UIView.animateWithDuration(0.4) {
                self.part = 3
                self.part3Button.transform = CGAffineTransformMakeTranslation(30, 0)
            }
            break
        case 4:
            UIView.animateWithDuration(0.4) {
                self.part = 4
                self.part4Button.transform = CGAffineTransformMakeTranslation(30, 0)
            }
            break
        case 5:
            UIView.animateWithDuration(0.4) {
                self.part = 5
                self.part5Button.transform = CGAffineTransformMakeTranslation(30, 0)
            }
            break
        case 6:
            UIView.animateWithDuration(0.4) {
                self.part = 6
                self.part6Button.transform = CGAffineTransformMakeTranslation(30, 0)
            }
            break
        case 7:
            UIView.animateWithDuration(0.4) {
                self.part = 7
                self.part7Button.transform = CGAffineTransformMakeTranslation(30, 0)
            }
            break
        default:
            break
        }
        progressPartSelected(self.part, testModel: self.testData!)
        
    }
    
    // MARK: - Button Action
    @IBAction func particeSelected(sender: AnyObject) {
        if selected != sender.tag {
            setPracticeAnimation(sender.tag)
        }
        selected = sender.tag
        DatabaseManager().loadTestData(Constants.databaseName, bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
            self.testData = datas as? TestModel
            Constants.audioName = self.testData!.audioName
            Constants.iamgeName = self.testData!.imageName
            self.progressPartSelected(self.part, testModel: self.testData!)
        }
        loadData(self.part)
    }

    @IBAction func paracticeStartSelected(sender: AnyObject) {
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
    
    func progressPartSelected(part: Int, testModel: TestModel) {
        var precent: CGFloat = 0.1
        switch part {
        case 1:
            if testModel.percent_part1 > 0 {
                precent = testModel.percent_part1!
            }
            break
        case 2:
            if testModel.percent_part2 > 0 {
                precent = testModel.percent_part2!
            }
            break
        case 3:
            if testModel.percent_part3 > 0 {
                precent = testModel.percent_part3!
            }
            break
        case 4:
            if testModel.percent_part4 > 0 {
                precent = testModel.percent_part4!
            }
            break
        case 5:
            if testModel.percent_part5 > 0 {
                precent = testModel.percent_part5!
            }
            break
        case 6:
            if testModel.percent_part6 > 0 {
                precent = testModel.percent_part6!
            }
            break
        case 7:
            if testModel.percent_part7 > 0 {
                precent = testModel.percent_part7!
            }
            break
        default:
            break
        }
        self.progress.setProgress(precent, animated: true)
    }
    
    func loadData(part: Int) {
        self.startButton.enabled = false
        switch part {
        case 1:
            DatabaseManager().loadPart1Data(Constants.databaseName, bookID: Constants.bookID!, testID:  Constants.testID!) { (status, datas) in
                if status == true {
                    Constants.questionPar1List = datas as! Array<Part1Model>
                    self.dataLabel.hidden = true
                    self.startButton.enabled = true
                    self.startButton.backgroundColor = UIColor.colorFromHexString("68A200")
                }
                else {
                    self.dataLabel.hidden = false
                    self.startButton.enabled = false
                    self.startButton.backgroundColor = UIColor.lightGrayColor()
                }
            }
            break
        case 2:
            DatabaseManager().loadPart2Data("toeic_test", bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
                if status == true {
                    Constants.questionPar2List = datas as! Array<Part2Model>
                    self.dataLabel.hidden = true
                    self.startButton.enabled = true
                    self.startButton.backgroundColor = UIColor.colorFromHexString("68A200")
                }
                else {
                    self.dataLabel.hidden = false
                    self.startButton.enabled = false
                    self.startButton.backgroundColor = UIColor.lightGrayColor()
                }
            }
            break
        case 3:
            DatabaseManager().loadPart3Data("toeic_test", bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
                if status == true {
                    Constants.questionPar3List = datas as! Array<Part34Model>
                    self.dataLabel.hidden = true
                    self.startButton.enabled = true
                    self.startButton.backgroundColor = UIColor.colorFromHexString("68A200")
                }
                else {
                    self.dataLabel.hidden = false
                    self.startButton.enabled = false
                    self.startButton.backgroundColor = UIColor.lightGrayColor()
                }
            }
            break
        case 4:
            DatabaseManager().loadPart4Data("toeic_test", bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
                if status == true {
                    Constants.questionPar4List = datas as! Array<Part34Model>
                    self.dataLabel.hidden = true
                    self.startButton.enabled = true
                    self.startButton.backgroundColor = UIColor.colorFromHexString("68A200")
                }
                else {
                    self.dataLabel.hidden = false
                    self.startButton.enabled = false
                    self.startButton.backgroundColor = UIColor.lightGrayColor()
                }
            }
            break
        case 5:
            DatabaseManager().loadPart5Data("toeic_test", bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
                if status == true {
                    Constants.questionPar5List = datas as! Array<Part34Model>
                    self.dataLabel.hidden = true
                    self.startButton.enabled = true
                    self.startButton.backgroundColor = UIColor.colorFromHexString("68A200")
                }
                else {
                    self.dataLabel.hidden = false
                    self.startButton.enabled = false
                    self.startButton.backgroundColor = UIColor.lightGrayColor()
                }
            }
            break
        case 6:
            Constants.part6Index = 0
            DatabaseManager().loadPart6Data("toeic_test", bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
                if status == true {
                    Constants.questionPar6List = (datas as? Array<Part6Model>)!
                    self.dataLabel.hidden = true
                    self.startButton.enabled = true
                    self.startButton.backgroundColor = UIColor.colorFromHexString("68A200")
                }
                else {
                    self.dataLabel.hidden = false
                    self.startButton.enabled = false
                    self.startButton.backgroundColor = UIColor.lightGrayColor()
                }
            }
            break
        case 7:
            DatabaseManager().loadPart7Data("toeic_test", bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
                if status == true {
                    Constants.questionPar7List = datas as! Array<Part7Model>
                    self.dataLabel.hidden = true
                    self.startButton.enabled = true
                    self.startButton.backgroundColor = UIColor.colorFromHexString("68A200")
                }
                else {
                    self.dataLabel.hidden = false
                    self.startButton.enabled = false
                    self.startButton.backgroundColor = UIColor.lightGrayColor()
                }
            }
            break
        default:
            break
        }
    }
}

// MARK: - TableView Datasource
extension PracticeViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listBook.count
    }
}

// MARK: - TableView Delegate
extension PracticeViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! BookTableCell
        cell.initWithData(listBook[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let bookModel = listBook[indexPath.row]
        Constants.bookID = bookModel.id
        let listTestVC = ListTestViewController(nibName: "ListTestViewController", bundle: nil)
        listTestVC.bookData = bookModel
        Constants.bookID = bookModel.id
        listTestVC.delegate = self
        let navigationController = UINavigationController(rootViewController: listTestVC)
        navigationController.navigationBar.barTintColor = UIColor.blueColor()
        formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController!.presentationController!.landscapeTopInset = Constants.SCREEN_HEIGHT*1/6
        formSheetController!.presentationController?.contentViewSize = CGSizeMake(Constants.SCREEN_WIDTH*3/4, Constants.SCREEN_HEIGHT*3/4)
        formSheetController!.allowDismissByPanningPresentedView = true
        formSheetController!.presentationController!.shouldDismissOnBackgroundViewTap = true
        formSheetController!.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.Bounce
        self.presentViewController(formSheetController!, animated: true, completion: nil)
    }
}

// MARK: - List Test Delegate
extension PracticeViewController: ListTest_Delegate {
    func ListTest_Selected(book: BookModel, testID: Int) {
        self.dismissViewControllerAnimated(true, completion: nil)
        Constants.bookData = book
        Constants.testID = testID+1
        DatabaseManager().loadTestData(Constants.databaseName, bookID: Constants.bookID!, testID: Constants.testID!) { (status, datas) in
            self.testData = datas as? TestModel
            Constants.audioName = self.testData!.audioName
            Constants.iamgeName = self.testData!.imageName
            self.progressPartSelected(self.part, testModel: self.testData!)
        }
        loadData(self.part)
        bookNameLabel.text = book.name
        testNumberLabel.text = String(format:"Test %i", testID+1)
    }
}
