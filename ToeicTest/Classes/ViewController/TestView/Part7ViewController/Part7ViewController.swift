//
//  Part7ViewController.swift
//  ToeicTest
//
//  Created by khactao on 1/1/17.
//
//

import UIKit

class Part7ViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    // MARK: - IBOutleft and variable

    @IBOutlet weak var botToolBar: UIView!
    @IBOutlet weak var toolBar: UIView?
    @IBOutlet weak var questionTableView: UITableView!
    var listHeaderView: Array = Array<UIView>()
    var testToolBar : TestToolBarView?
    var bottomBarView: BottomBarView?
    var topPracticeBar: TopBarView?
    var botPracticeBar: BotBarView?
    
    // MARK: - Life cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if HomeViewController.status == .test {
            self.testToolBar?.timerLabel.text = Constants.formatTimer(BaseViewController.second, minute: BaseViewController.minute, hours: BaseViewController.hours)
        }
        else if HomeViewController.status == .review {
            checkSelected()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if HomeViewController.status == .practice {
            addTopPracticeBar()
            addBotPracticeBar()
        }
        else {
            addToolBarTest()
            addBottomBarTest()
        }
        questionTableView.delegate = self
        questionTableView.dataSource = self
        let section = TestViewController.questionPar7List.count
        for i in 0..<section {
            let numberQuestion = (TestViewController.questionPar7List[i].questionArray).count
            for j in 0..<numberQuestion {
                      self.questionTableView.registerNib(UINib.init(nibName:"Part3v4CellQuestion", bundle: nil), forCellReuseIdentifier: String(format: "part7Cell%i%i", i, j))
            }
  
        }
        settingTableView()
        if HomeViewController.status == .test {
            super.startTimer()
        }
        TestViewController.questionPar7List.forEach { (questionData) in
            if questionData.passseage2 == nil || questionData.passseage2 == "" {
                let headerView = NSBundle.mainBundle().loadNibNamed("Part7Header2View", owner: self, options: nil).first as! Part7Header2View
                headerView.numberQuestionLabel.text = questionData.numberQuestionString
                headerView.titleHeaderLabel.text = questionData.title
                headerView.passage1TextView.text = questionData.passseage1
                listHeaderView.append(headerView)
            }
            else {
                let headerView = NSBundle.mainBundle().loadNibNamed("Part7HeaderView", owner: self, options: nil).first as! Part7HeaderView
                headerView.numberQuestionLabel.text = questionData.numberQuestionString
                headerView.titleLabel.text = questionData.title
                headerView.passage1TextView.text = questionData.passseage1
                headerView.passage2Textview.text = questionData.passseage2
                listHeaderView.append(headerView)
            }
       
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Timer
    override func showTimer() {
        self.testToolBar?.timerLabel.text = Constants.formatTimer(BaseViewController.second, minute: BaseViewController.minute, hours: BaseViewController.hours)
    }
    
    // MARK: - Setting Table View
    func settingTableView() {
        self.questionTableView.rowHeight = UITableViewAutomaticDimension
        self.questionTableView.estimatedRowHeight = 180
        self.questionTableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.questionTableView.estimatedSectionHeaderHeight  = 400
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return TestViewController.questionPar7List.count
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = TestViewController.questionPar7List[section]
        return sectionData.questionArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let questionData = TestViewController.questionPar7List[indexPath.section]
        let cell = tableView.dequeueReusableCellWithIdentifier(String(format: "part7Cell%i%i", indexPath.section, indexPath.row)) as! Part3v4CellQuestion
        cell.questionNumber.text = String(format: "%i.", (questionData.questionArray[indexPath.row]).number)
        cell.initwithData(questionData.questionArray[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if HomeViewController.status == .review {
            (listHeaderView[section]).userInteractionEnabled = true
        }
        return listHeaderView[section]
    }
    
    // MARK: - Button Selected
    func nextSelected() {
        if HomeViewController.status == .test {
            TestViewController.questionPar7List.forEach { (questonPart7Data) in
                questonPart7Data.questionArray.forEach({ (questionData) in
                    if questionData.answerSelected == questionData.answer && questionData.answerSelected != 0 {
                        TestViewController.numberReadingTrue = TestViewController.numberReadingTrue + 1
                    }
                })
            }
        }
        let resultView = ResultViewController(nibName: "ResultViewController", bundle: nil)
        self.navigationController?.pushViewController(resultView, animated: true)
    }
    func backSelected() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func canceTest() {
        if HomeViewController.status == .test {
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
            HomeViewController.status = .test
            let resultView = ResultViewController(nibName: "ResultViewController", bundle: nil)
            self.navigationController?.pushViewController(resultView, animated: true)
        }
    }
    
    func checkSelected() {
        if  HomeViewController.status == .practice {
            HomeViewController.status = .review
            bottomBarView?.numberTrueLabel.hidden = false
            questionTableView.reloadData()
            BaseViewController.mp3Player?.stop()
            var i = 0
            var numberQuestion = 0
            TestViewController.questionPar7List.forEach({ (data) in
                data.questionArray.forEach({ (questionData) in
                    numberQuestion = numberQuestion + 1
                    if questionData.answerSelected == questionData.answer {
                        i = i + 1
                    }
                })
            })
            topPracticeBar?.googleTranslateButton.hidden = false
            botPracticeBar?.numberTrueLabel.text = String(format: "%i/%i", i, numberQuestion)
            botPracticeBar?.checkButton.setTitle("Kết thúc", forState: .Normal)
            
        }
        else if HomeViewController.status == .review{
            var i = 0
            var numberQuestion = 0
            TestViewController.questionPar7List.forEach({ (data) in
                data.questionArray.forEach({ (questionData) in
                    numberQuestion = numberQuestion + 1
                    if questionData.answerSelected == questionData.answer {
                        i = i + 1
                    }
                })
            })
            bottomBarView?.numberTrueLabel.text = String(format: "%@ %i/%i",Constants.LANGTEXT("PRACTICE_NUMBER_ANSWER"), i, numberQuestion)
            bottomBarView?.numberTrueLabel.hidden = false
            let percent = Constants.getPercent(i, total: numberQuestion)
            DatabaseManager().updateExpertience(Constants.databaseName, bookID: BaseViewController.bookID!, testID: BaseViewController.testID!, part: 7, percent: percent)
            botPracticeBar?.checkButton.setTitle("Kết thúc", forState: .Normal)
            botPracticeBar?.checkButton.addTarget(self, action: #selector(backSelected), forControlEvents: .TouchUpInside)
        }
        else {
            backSelected()
        }

    }
    
    // MARK: Tool Bar
    func addToolBarTest() {
        testToolBar = NSBundle.mainBundle().loadNibNamed("TestToolBarView", owner: self, options: nil).first as? TestToolBarView
        testToolBar?.frame = CGRect(x: 0, y: 0, width: toolBar!.frame.size.width, height: toolBar!.frame.size.height)
        testToolBar?.canceTestButton.addTarget(self, action: #selector(canceTest), forControlEvents: .TouchUpInside)
        testToolBar?.partName.text = "PART 7"
        toolBar!.addSubview(testToolBar!)
        if HomeViewController.status == .review {
            testToolBar?.timerLabel.text = "00: 00: 00"
        }
    }
    
    func addBottomBarTest() {
        bottomBarView = NSBundle.mainBundle().loadNibNamed("BottomBarView", owner: self, options: nil).first as? BottomBarView
        bottomBarView?.nextButton.addTarget(self, action: #selector(nextSelected), forControlEvents: .TouchUpInside)
        bottomBarView?.backButton.addTarget(self, action: #selector(backSelected), forControlEvents: .TouchUpInside)
        if HomeViewController.status == .test {
            bottomBarView?.backButton.hidden = true
        }
        else if HomeViewController.status == .review {
            bottomBarView?.backButton.hidden = false
        }
        bottomBarView?.frame = CGRect(x: 0, y: 0, width: botToolBar.frame.size.width, height: botToolBar.frame.size.height)
        botToolBar.addSubview(bottomBarView!)
    }
    
    func addTopPracticeBar() {
        topPracticeBar = NSBundle.mainBundle().loadNibNamed("TopBarView", owner: self, options: nil).first as? TopBarView
        topPracticeBar?.canceButton.addTarget(self, action: #selector(backSelected), forControlEvents: .TouchUpInside)
        topPracticeBar?.partLabel.text = "Practice Part 7"
        topPracticeBar?.frame = CGRect(x: 0, y: 0, width: toolBar!.frame.size.width, height: toolBar!.frame.size.height)
        toolBar!.addSubview(topPracticeBar!)
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
            self.toolBar!.transform = CGAffineTransformMakeTranslation(0, 0)
            self.botToolBar!.transform = CGAffineTransformMakeTranslation(0, 0)
            self.questionTableView.transform = CGAffineTransformMakeTranslation(0, 0)
        })
    }
    
    func higeTimeBar() {
        UIView.animateWithDuration(0.5, animations: {
            self.toolBar!.transform = CGAffineTransformMakeTranslation(0, -35)
            self.botToolBar!.transform = CGAffineTransformMakeTranslation(0, -35)
            self.questionTableView.transform = CGAffineTransformMakeTranslation(0, -35)
        })
    }
}
