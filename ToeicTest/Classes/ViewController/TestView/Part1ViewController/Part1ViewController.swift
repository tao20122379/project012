//
//  Part1ViewController.swift
//  ToeicTest
//
//  Created by khactao on 12/30/16.
//
//

import UIKit
import AVFoundation
import MZFormSheetPresentationController

class Part1ViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, Part1Question_Delegate {
    
    // MARK: - IBOutleft and variable
    static let shareTest = Part1ViewController()
    @IBOutlet weak var timerString: UILabel!
    @IBOutlet weak var questionTableView: UITableView!
    @IBOutlet weak var toolBar: UIView!
    @IBOutlet weak var botToolBar: UIView!
    var testToolBar : TestToolBarView?
    var bottomBarView: BottomBarView?
    var topPracticeBar: TopBarView?
    var botPracticeBar: BotBarView?
    var formSheetController: MZFormSheetPresentationViewController?
    var directionView: DirectionPart1View?
    var isNewTest: Bool = false
    
    // MARK: - Life cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Constants.part6Index = 0
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if Constants.status == .test {
            self.testToolBar?.timerLabel.text = "00 : 45 : 00"
        }
        self.loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Constants.status == .practice {
            addTopPracticeBar()
            addBotPracticeBar()
        }
        else {
            addToolBarTest()
            addBottomBarTest()
        }
        self.settingTableView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        Constants.mp3Player?.stop()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showTimeBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Timer
    override func showTimer() {
        if  Constants.status == .test && Constants.second == 0 && Constants.minute == 0 &&  Constants.hours == 0 {
            super.showTimer()
            nextSelected()
        }
        self.testToolBar?.timerLabel.text = Constants.formatTimer(Constants.second, minute: Constants.minute, hours: Constants.hours)
    }
    override func endTest() {
        Constants.mp3Player?.stop()
    }
    
    // MARK: - TableView
    func settingTableView() {
        self.questionTableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.questionTableView.estimatedSectionHeaderHeight = 530
        self.questionTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 35))
        self.questionTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 35))
        for i in 0..<Constants.questionPar1List.count {
            self.questionTableView.registerNib(UINib.init(nibName:"Part1QuestionCell", bundle: nil), forCellReuseIdentifier: String(format: "part1Cell%i", i))
        }
        questionTableView.delegate = self
        questionTableView.dataSource = self
        questionTableView.rowHeight = Constants.SCREEN_WIDTH*6/11
        directionView = (NSBundle.mainBundle().loadNibNamed("DirectionPart1View", owner: self, options: nil).first as! DirectionPart1View)
        directionView!.exampleLabel.text = Constants.bookData?.direction1
        directionView!.exampleImage.image = UIImage(named: (Constants.bookData?.imageName)!+"0")

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.questionPar1List.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(format: "part1Cell%i", indexPath.row)) as! Part1QuestionCell
        let questionData = Constants.questionPar1List[indexPath.row]
        questionData.number = indexPath.row + 1
        cell.delegate = self
        cell.questionNumber.text = String(format: "%i.", indexPath.row + 1)
        cell.pictureQuestion.image = UIImage(named: String(format: "%@%i", Constants.iamgeName!, indexPath.row + 1))
        if questionData.answerSelected == 0 {
           cell.refresh()
        }
        cell.initWithData(questionData)
        cell.numberQuestion = indexPath.row
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return directionView
    }
    
    // MARK: - function
    func loadData() {
        Constants.mp3Player = MP3Player()
        Constants.mp3Player?.initWithFileMp3(Constants.audioName!+"1")
        Constants.minute = 45
        Constants.second = 0
        if Constants.status != .review {
            Constants.mp3Player?.play()
            super.startTimer()
        }
        else {
            checkSelected()
        }
        self.questionTableView.reloadData()
        if isNewTest {
            self.questionTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: false)
        }
        isNewTest = false
    }
    
    func explainQuestion(questionData: Part1Model) {
        let explainVC = ExplainPart1ViewController(nibName: "ExplainPart1ViewController", bundle: nil)
        explainVC.questionData = questionData
        self.navigationController?.pushViewController(explainVC, animated: true)
    }

    
    // MARK: - Button Selected
    
    func nextSelected() {
        Constants.mp3Player?.stop()
        super.stopTimer()
        if Constants.status == .test {
            bottomBarView?.numberTrueLabel.hidden = true
            Constants.questionPar1List.forEach { (questionData) in
                if questionData.answerSelected == questionData.answer && questionData.answerSelected != 0 {
                    Constants.numberListenngTrue = Constants.numberListenngTrue + 1
                }
            }
        }
        let part2 = Part2ViewController(nibName: "Part2ViewController", bundle: nil)
        self.navigationController?.pushViewController(part2, animated: true)
    }
    
    func backSelected() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func canceTest() {
        if Constants.status == .test {
            let alert = UIAlertController(title: "", message: Constants.LANGTEXT("TEST_NOTE_CANE"), preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: Constants.LANGTEXT("COMMON_OK"), style: .Default, handler: { (action) in
                let resultView = ResultViewController(nibName: "ResultViewController", bundle: nil)
                self.navigationController?.pushViewController(resultView, animated: true)
            }))
            alert.addAction(UIAlertAction(title: Constants.LANGTEXT("COMMON_CANCE"), style: .Default, handler: { (action) in
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            Constants.status = .test
            let resultView = ResultViewController(nibName: "ResultViewController", bundle: nil)
            self.navigationController?.pushViewController(resultView, animated: true)
        }
    }
    
    func cancePractice() {
        let viewcontroller = super.navigationController?.viewControllers[1]
        super.navigationController?.popToViewController(viewcontroller!, animated: true)
    }
    
    func checkSelected() {
        if  Constants.status == .practice {
            Constants.status = .review
            Constants.mp3Player?.stop()
            questionTableView.reloadData()
            var i = 0
            Constants.questionPar1List.forEach({ (part1Data) in
                if part1Data.answer == part1Data.answerSelected {
                    i = i + 1
                }
            })
            topPracticeBar?.googleTranslateButton.hidden = false
            botPracticeBar?.numberTrueLabel.text = String(format: "%@ %i/%i", Constants.LANGTEXT("PRACTICE_NUMBER_ANSWER"), i, Constants.questionPar1List.count)
            bottomBarView?.numberTrueLabel.hidden = false
            let percent = Constants.getPercent(i, total: Constants.questionPar1List.count)
            DatabaseManager().updateExpertience(Constants.databaseName, bookID: Constants.bookID!, testID: Constants.testID!, part: 1, percent: percent)
            botPracticeBar?.checkButton.setTitle(Constants.LANGTEXT("PRACTICE_END"), forState: .Normal)
            botPracticeBar?.checkButton.addTarget(self, action: #selector(backSelected), forControlEvents: .TouchUpInside)
        }
        else if Constants.status == .review{
            var i = 0
            Constants.questionPar1List.forEach({ (part1Data) in
                if part1Data.answer == part1Data.answerSelected {
                    i = i + 1
                }
            })
            bottomBarView?.numberTrueLabel.text = String(format: "%@ %i/%i", Constants.LANGTEXT("PRACTICE_NUMBER_ANSWER"), i, Constants.questionPar1List.count)
            bottomBarView?.numberTrueLabel.hidden = false
        }
    }
    
    // MARK: Tool Bar
    
    func addToolBarTest() {
        testToolBar = NSBundle.mainBundle().loadNibNamed("TestToolBarView", owner: self, options: nil).first as? TestToolBarView
        testToolBar?.frame = CGRect(x: 0, y: 0, width: toolBar.frame.size.width, height: toolBar.frame.size.height)
        testToolBar?.canceTestButton.addTarget(self, action: #selector(canceTest), forControlEvents: .TouchUpInside)
        testToolBar?.partName.text = "PART 1"
        toolBar.addSubview(testToolBar!)
        if Constants.status == .review {
            testToolBar?.timerLabel.text = "00: 00: 00"
           
        }
    }
    
    func addBottomBarTest() {
        bottomBarView = NSBundle.mainBundle().loadNibNamed("BottomBarView", owner: self, options: nil).first as? BottomBarView
        bottomBarView?.nextButton.addTarget(self, action: #selector(nextSelected), forControlEvents: .TouchUpInside)
        bottomBarView?.backButton.addTarget(self, action: #selector(backSelected), forControlEvents: .TouchUpInside)
        if Constants.status == .test {
            bottomBarView?.backButton.hidden = true
        }
        else if Constants.status == .review {
            bottomBarView?.backButton.hidden = false
        }
        bottomBarView?.frame = CGRect(x: 0, y: 0, width: botToolBar.frame.size.width, height: botToolBar.frame.size.height)
        botToolBar.addSubview(bottomBarView!)
    }
    
    func addTopPracticeBar() {
        topPracticeBar = NSBundle.mainBundle().loadNibNamed("TopBarView", owner: self, options: nil).first as? TopBarView
        topPracticeBar?.canceButton.addTarget(self, action: #selector(cancePractice), forControlEvents: .TouchUpInside)
        topPracticeBar?.partLabel.text = "Practice Part 1"
        topPracticeBar?.frame = CGRect(x: 0, y: 0, width: toolBar.frame.size.width, height: toolBar.frame.size.height)
        toolBar.addSubview(topPracticeBar!)
    }
    
    func addBotPracticeBar() {
        botPracticeBar = NSBundle.mainBundle().loadNibNamed("BotBarView", owner: self, options: nil).first as? BotBarView
        botPracticeBar?.frame = CGRect(x: 0, y: 0, width: botToolBar.frame.size.width, height: botToolBar.frame.size.height)
        botPracticeBar?.checkButton.addTarget(self, action: #selector(checkSelected), forControlEvents: .TouchUpInside)
        botToolBar.addSubview(botPracticeBar!)
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y<0 {
            showTimeBar()
        }
        else {
            higeTimeBar()
        }
    }
    
    func showTimeBar() {
        UIView.animateWithDuration(0.5, animations: {
            self.toolBar.transform = CGAffineTransformMakeTranslation(0, 0)
            self.botToolBar.transform = CGAffineTransformMakeTranslation(0, 0)
        })
    }
    
    func higeTimeBar() {
        UIView.animateWithDuration(0.5, animations: {
            self.toolBar.transform = CGAffineTransformMakeTranslation(0, -35)
            self.botToolBar.transform = CGAffineTransformMakeTranslation(0, -35)
        })
    }
    
}
