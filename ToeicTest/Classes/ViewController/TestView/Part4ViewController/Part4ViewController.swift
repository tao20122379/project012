//
//  Part4ViewController.swift
//  ToeicTest
//
//  Created by khactao on 1/1/17.
//
//

import UIKit

class Part4ViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, FooterExplain_Delegate{
    
    // MARK: - IBOutleft and variable

    @IBOutlet weak var botToolBar: UIView!
    @IBOutlet weak var toolBar: UIView!
    @IBOutlet weak var questionTableView: UITableView!
    var testToolBar : TestToolBarView?
    var bottomBarView: BottomBarView?
    var topPracticeBar: TopBarView?
    var botPracticeBar: BotBarView?
    
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        BaseViewController.mp3Player?.stop()
    }
    
    
    // MARK: - Life cycle
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
        BaseViewController.mp3Player = MP3Player()
        BaseViewController.mp3Player?.initWithFileMp3(BaseViewController.audioName!+"4")
        if HomeViewController.status != .review {
            BaseViewController.mp3Player?.play()
            super.startTimer()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func endTest() {
        BaseViewController.mp3Player?.stop()
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
        for i in 0..<TestViewController.questionPar4List.count {
            self.questionTableView.registerNib(UINib.init(nibName:"Part3v4CellQuestion", bundle: nil), forCellReuseIdentifier: String(format: "part4Cell%i", i))
        }
        self.questionTableView.rowHeight = UITableViewAutomaticDimension
        self.questionTableView.estimatedRowHeight = 100
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: Constants.SCREEN_WIDTH, height: 150))
        let directionView = NSBundle.mainBundle().loadNibNamed("DirectionPart3View", owner: self, options: nil).first as! DerectionPart3View
        directionView.frame = CGRect(x: 0, y: 0, width: Constants.SCREEN_WIDTH, height: 150)
        directionView.titleLabel.text = "PART4"
        directionView.contentLabel.text = Constants.directionPart4
        view1.clipsToBounds = true
        view1.addSubview(directionView)
        questionTableView.tableHeaderView = view1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return TestViewController.questionPar4List.count/3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(format: "part4Cell%i", indexPath.section*3 + indexPath.row)) as! Part3v4CellQuestion
        let questionData = TestViewController.questionPar4List[indexPath.section*3 + indexPath.row]
        cell.questionNumber.text = String(format: "%i.", indexPath.section*3 + indexPath.row+71)
        cell.initwithData(questionData)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if HomeViewController.status == .review {
            return 40
        }
        return 0.0001
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if HomeViewController.status == .review {
            return 36
        }
        return 0.0001
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = NSBundle.mainBundle().loadNibNamed("FooterExplainView", owner: self, options: nil).first as! FooterExplainView
        footerView.delegate = self
        footerView.sectionID = section+1
        return footerView
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = NSBundle.mainBundle().loadNibNamed("HeaderView", owner: self, options: nil).first as! HeaderView
        headerView.questionNumber.text = String(format: "Question %i-%i", 70+section*3+1, 70+section*3+3)
        headerView.questionGroupInfor.text = ""
        return headerView
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
    
    // MARK: - Delegate funcion
    func explainSection(section: Int) {
        let explainPart4VC = ExplainPart4ViewController(nibName: "ExplainPart4ViewController", bundle: nil)
        explainPart4VC.section_ID = section
        self.navigationController?.pushViewController(explainPart4VC, animated: true)
    }
    
    // MARK: - Button Selected
    
  func nextSelected() {
        BaseViewController.mp3Player?.stop()
        if HomeViewController.status == .test {
            TestViewController.questionPar4List.forEach { (questionData) in
                if questionData.answerSelected == questionData.answer && questionData.answerSelected != 0 {
                    TestViewController.numberListenngTrue = TestViewController.numberListenngTrue + 1
                }
            }
        }
        let part5 = Part5ViewController(nibName: "Part5ViewController", bundle: nil)
        self.navigationController?.pushViewController(part5, animated: true)
        
    }
    func backSelected() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func checkSelected() {
        if  HomeViewController.status == .practice {
            HomeViewController.status = .review
            bottomBarView?.numberTrueLabel.hidden = false
            BaseViewController.mp3Player?.stop()
            questionTableView.reloadData()
            var i = 0
            TestViewController.questionPar4List.forEach({ (data) in
                if data.answer == data.answerSelected {
                    i = i + 1
                }
            })
            topPracticeBar?.googleTranslateButton.hidden = false
            botPracticeBar?.numberTrueLabel.text = String(format: "%i/%i", i, TestViewController.questionPar4List.count)
            botPracticeBar?.checkButton.setTitle("Kết thúc", forState: .Normal)
            let percent = Constants.getPercent(i, total: TestViewController.questionPar4List.count)
            DatabaseManager().updateExpertience(Constants.databaseName, bookID: BaseViewController.bookID!, testID: BaseViewController.testID!, part: 4, percent: percent)
            botPracticeBar?.checkButton.setTitle("Kết thúc", forState: .Normal)
            botPracticeBar?.checkButton.addTarget(self, action: #selector(backSelected), forControlEvents: .TouchUpInside)
        }
        else if HomeViewController.status == .review{
            var i = 0
            TestViewController.questionPar4List.forEach({ (data) in
                if data.answer == data.answerSelected {
                    i = i + 1
                }
            })
            bottomBarView?.numberTrueLabel.text = String(format: "%@ %i/%i",Constants.LANGTEXT("PRACTICE_NUMBER_ANSWER"), i, TestViewController.questionPar4List.count)
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
        testToolBar?.partName.text = "PART 4"
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
        topPracticeBar?.partLabel.text = "Practice Part 4"
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
