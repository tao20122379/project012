//
//  Part5ViewController.swift
//  ToeicTest
//
//  Created by khactao on 1/1/17.
//
//

import UIKit

class Part5ViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutleft and variable
    
    @IBOutlet weak var botToolBar: UIView!
    @IBOutlet weak var toolBar: UIView!
    @IBOutlet weak var questionTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    var testToolBar : TestToolBarView?
    var bottomBarView: BottomBarView?
    var topPracticeBar: TopBarView?
    var botPracticeBar: BotBarView?
    
    // MARK: - Life cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        BaseViewController.hours = 1
        BaseViewController.minute = 15
        BaseViewController.second = 0
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
        settingTableView()
        if HomeViewController.status == .test {
            super.startTimer()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Timer
    override func showTimer() {
        if  HomeViewController.status == .test &&  BaseViewController.second == 0 && BaseViewController.minute == 0 &&  BaseViewController.hours == 0 {
            super.showTimer()
            nextSelected()
        }
        self.testToolBar?.timerLabel.text = Constants.formatTimer(BaseViewController.second, minute: BaseViewController.minute, hours: BaseViewController.hours)
    }
    
    // MARK: - Setting Table View
    
    func settingTableView() {
        questionTableView.delegate = self
        questionTableView.dataSource = self
        questionTableView.rowHeight = UITableViewAutomaticDimension
        questionTableView.estimatedRowHeight = 100
        for i in 0..<TestViewController.questionPar5List.count {
            self.questionTableView.registerNib(UINib.init(nibName:"Part3v4CellQuestion", bundle: nil), forCellReuseIdentifier: String(format: "part5Cell%i", i))
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TestViewController.questionPar5List.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(format: "part5Cell%i", indexPath.row)) as! Part3v4CellQuestion
        let questionData = TestViewController.questionPar5List[indexPath.row]
        cell.questionNumber.text = String(format: "%i.", indexPath.row+101)
        cell.initwithData(questionData)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }

    
    // MARK: - Button Selected
    func nextSelected() {
        if HomeViewController.status == .test {
            TestViewController.questionPar5List.forEach { (questionData) in
                if questionData.answerSelected == questionData.answer && questionData.answerSelected != 0 {
                    TestViewController.numberReadingTrue = TestViewController.numberReadingTrue + 1
                }
            }
        }
        let part6 = Part6ViewController(nibName: "Part6ViewController", bundle: nil)
        self.navigationController?.pushViewController(part6, animated: true)
        
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
            BaseViewController.mp3Player?.stop()
            questionTableView.reloadData()
            var i = 0
            TestViewController.questionPar5List.forEach({ (data) in
                if data.answer == data.answerSelected {
                    i = i + 1
                }
            })
            topPracticeBar?.googleTranslateButton.hidden = false
            botPracticeBar?.numberTrueLabel.text = String(format: "%i/%i", i, TestViewController.questionPar5List.count)
            botPracticeBar?.checkButton.setTitle("Kết thúc", forState: .Normal)
            let percent = Constants.getPercent(i, total: TestViewController.questionPar5List.count)
            DatabaseManager().updateExpertience(Constants.databaseName, bookID: BaseViewController.bookID!, testID: BaseViewController.testID!, part: 5, percent: percent)
            botPracticeBar?.checkButton.setTitle("Kết thúc", forState: .Normal)
            botPracticeBar?.checkButton.addTarget(self, action: #selector(backSelected), forControlEvents: .TouchUpInside)
        }
        else if HomeViewController.status == .review{
            var i = 0
            TestViewController.questionPar5List.forEach({ (data) in
                if data.answer == data.answerSelected {
                    i = i + 1
                }
            })
            bottomBarView?.numberTrueLabel.text = String(format:"%@ %i/%i",Constants.LANGTEXT("PRACTICE_NUMBER_ANSWER"), i, TestViewController.questionPar5List.count)
            bottomBarView?.numberTrueLabel.hidden = false
        }
        else {
            backSelected()
        }

    }
    
    // MARK: Tool Bar
    
    func addToolBarTest() {
        testToolBar = NSBundle.mainBundle().loadNibNamed("TestToolBarView", owner: self, options: nil).first as? TestToolBarView
        testToolBar?.frame = CGRect(x: 0, y: 0, width: toolBar.frame.size.width, height: toolBar.frame.size.height)
        testToolBar?.canceTestButton.addTarget(self, action: #selector(canceTest), forControlEvents: .TouchUpInside)
        testToolBar?.partName.text = "PART 5"
        toolBar.addSubview(testToolBar!)
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
        topPracticeBar?.partLabel.text = "Practice Part 5"
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
            self.questionTableView.transform = CGAffineTransformMakeTranslation(0, 0)
        })
    }
    
    func higeTimeBar() {
        UIView.animateWithDuration(0.5, animations: {
            self.toolBar.transform = CGAffineTransformMakeTranslation(0, -35)
            self.botToolBar.transform = CGAffineTransformMakeTranslation(0, -35)
            self.questionTableView.transform = CGAffineTransformMakeTranslation(0, -35)
        })
    }
    
}
