//
//  Part6ViewController.swift
//  ToeicTest
//
//  Created by khactao on 12/31/16.
//
//

import UIKit

class Part6ViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutleft and variable
    

    @IBOutlet weak var botToolBar: UIView!
    @IBOutlet weak var toolBar: UIView!
    @IBOutlet weak var questionTableView: UITableView!
    var testToolBar : TestToolBarView?
    var bottomBarView: BottomBarView?
    var topPracticeBar: TopBarView?
    var botPracticeBar: BotBarView?
    var listHeaderView = Array<HeaderView>()
    
    // MARK: - Life cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        settingTableView()
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

        if HomeViewController.status == .test{
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
        questionTableView.rowHeight = UITableViewAutomaticDimension
        questionTableView.estimatedRowHeight = 250
        questionTableView.delegate = self
        questionTableView.dataSource = self
        let section = TestViewController.questionPar6List.count
        for i in 0..<section {
            let row = (TestViewController.questionPar6List[i]).questionArray.count
            for j in 0..<row {
                self.questionTableView.registerNib(UINib.init(nibName:"Part6CellQuestion", bundle: nil), forCellReuseIdentifier: String(format: "part6Cell%i%i", i, j))
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return TestViewController.questionPar6List.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = TestViewController.questionPar6List[section]
        return sectionData.questionArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(format: "part6Cell%i%i", indexPath.section, indexPath.row)) as! Part6CellQuestion
        NSLog(String(format: "part6Cell%i%i", indexPath.section, indexPath.row))
        let part6Data = TestViewController.questionPar6List[indexPath.section]
        cell.questionNumber.text = String(format: "%i.", indexPath.section*3 + indexPath.row + 141)
        if indexPath.row == 0 {
            cell.borderTop.hidden = false
        }
        else if indexPath.row == 3 {
            cell.borderBottom.hidden = false
            
        }
        cell.initWithData(part6Data.questionArray[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = NSBundle.mainBundle().loadNibNamed("HeaderView", owner: self, options: nil).first as! HeaderView
        let part6Data = TestViewController.questionPar6List[section]
        headerView.questionNumber.text = String(format: "Question %i-%i", section*3 + 141, section*3 + 143)
        headerView.questionGroupInfor.text = part6Data.title
        return headerView
    }
    
    func checkSelected() {
        if  HomeViewController.status == .practice {
            HomeViewController.status = .review
            bottomBarView?.numberTrueLabel.hidden = false
            questionTableView.reloadData()
            BaseViewController.mp3Player?.stop()
            var i = 0
            var numberQuestion = 0
            TestViewController.questionPar6List.forEach({ (data) in
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
            let percent = Constants.getPercent(i, total: numberQuestion)
            DatabaseManager().updateExpertience(Constants.databaseName, bookID: BaseViewController.bookID!, testID: BaseViewController.testID!, part: 6, percent: percent)
            botPracticeBar?.checkButton.setTitle("Kết thúc", forState: .Normal)
            botPracticeBar?.checkButton.addTarget(self, action: #selector(backSelected), forControlEvents: .TouchUpInside)
        }
        else if HomeViewController.status == .review{
            var i = 0
            var numberQuestion = 0
            TestViewController.questionPar6List.forEach({ (data) in
                data.questionArray.forEach({ (questionData) in
                    numberQuestion = numberQuestion + 1
                    if questionData.answerSelected == questionData.answer {
                        i = i + 1
                    }
                })
            })
            bottomBarView?.numberTrueLabel.text = String(format: "%@ %i/%i",Constants.LANGTEXT("PRACTICE_NUMBER_ANSWER"), i, numberQuestion)
            bottomBarView?.numberTrueLabel.hidden = false
        }
        else {
            backSelected()
        }

    }
    
    // MARK: - Button Selected
    func nextSelected() {
        if HomeViewController.status == .test {
            TestViewController.questionPar6List.forEach { (questonPart6Data) in
                questonPart6Data.questionArray.forEach({ (questionData) in
                    if questionData.answerSelected == questionData.answer && questionData.answerSelected != 0 {
                        TestViewController.numberReadingTrue = TestViewController.numberReadingTrue + 1
                    }
                })
            }
        }
        let part7 = Part7ViewController(nibName: "Part7ViewController", bundle: nil)
        self.navigationController?.pushViewController(part7, animated: true)
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
    
    // MARK: Tool Bar
    func addToolBarTest() {
        testToolBar = NSBundle.mainBundle().loadNibNamed("TestToolBarView", owner: self, options: nil).first as? TestToolBarView
        testToolBar?.frame = CGRect(x: 0, y: 0, width: toolBar.frame.size.width, height: toolBar.frame.size.height)
        testToolBar?.canceTestButton.addTarget(self, action: #selector(canceTest), forControlEvents: .TouchUpInside)
        testToolBar?.partName.text = "PART 6"
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
        topPracticeBar?.partLabel.text = "Practice Part 6"
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
