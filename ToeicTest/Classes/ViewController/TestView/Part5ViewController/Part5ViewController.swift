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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        Constants.hours = 1
        Constants.minute = 15
        Constants.second = 0
        if Constants.status == .test {
            self.testToolBar?.timerLabel.text = Constants.formatTimer(Constants.second, minute: Constants.minute, hours: Constants.hours)
        }
        else if Constants.status == .review {
            checkSelected()
        }
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
        settingTableView()
        if Constants.status == .test {
            super.startTimer()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Timer
    override func showTimer() {
        if  Constants.status == .test &&  Constants.second == 0 && Constants.minute == 0 &&  Constants.hours == 0 {
            super.showTimer()
            nextSelected()
        }
        self.testToolBar?.timerLabel.text = Constants.formatTimer(Constants.second, minute: Constants.minute, hours: Constants.hours)
    }
    
    // MARK: - Setting Table View
    
    func settingTableView() {
        questionTableView.delegate = self
        questionTableView.dataSource = self
        self.questionTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 35))
        self.questionTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 35))
        questionTableView.rowHeight = UITableViewAutomaticDimension
        questionTableView.estimatedRowHeight = 100
        for i in 0..<Constants.questionPar5List.count {
            self.questionTableView.register(UINib.init(nibName:"Part3v4CellQuestion", bundle: nil), forCellReuseIdentifier: String(format: "part5Cell%i", i))
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.questionPar5List.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(format: "part5Cell%i", indexPath.row)) as! Part3v4CellQuestion
        let questionData = Constants.questionPar5List[indexPath.row]
        cell.questionNumber.text = String(format: "%i.", indexPath.row+101)
        cell.initwithData(questionData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }

    
    // MARK: - Button Selected
    func nextSelected() {
        if Constants.status == .test {
            Constants.questionPar5List.forEach { (questionData) in
                if questionData.answerSelected == questionData.answer && questionData.answerSelected != 0 {
                    Constants.numberReadingTrue = Constants.numberReadingTrue + 1
                }
            }
        }
        let part6 = Part6ViewController(nibName: "Part6ViewController", bundle: nil)
        self.navigationController?.pushViewController(part6, animated: true)
        
    }
    
    func backSelected() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func canceTest() {
        if Constants.status == .test {
            let alert = UIAlertController(title: "", message: Constants.LANGTEXT("TEST_NOTE_CANE"), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: Constants.LANGTEXT("COMMON_OK"), style: .default, handler: { (action) in
                let resultView = ResultViewController(nibName: "ResultViewController", bundle: nil)
                self.navigationController?.pushViewController(resultView, animated: true)
            }))
            alert.addAction(UIAlertAction(title: Constants.LANGTEXT("COMMON_CANCE"), style: .default, handler: { (action) in
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            Constants.status = .test
            let resultView = ResultViewController(nibName: "ResultViewController", bundle: nil)
            self.navigationController?.pushViewController(resultView, animated: true)
        }
    }
    
    func cancePractice() {
        let alert = UIAlertController(title: "", message: Constants.LANGTEXT("TEST_NOTE_CANE"), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: Constants.LANGTEXT("COMMON_OK"), style: .default, handler: { (action) in
            super.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: Constants.LANGTEXT("COMMON_CANCE"), style: .default, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func checkSelected() {
        if  Constants.status == .practice {
            Constants.status = .review
            bottomBarView?.numberTrueLabel.isHidden = false
            Constants.mp3Player?.stop()
            questionTableView.reloadData()
            var i = 0
            Constants.questionPar5List.forEach({ (data) in
                if data.answer == data.answerSelected {
                    i = i + 1
                }
            })
            topPracticeBar?.googleTranslateButton.isHidden = false
            botPracticeBar?.numberTrueLabel.text = String(format: "%@ %i/%i", Constants.LANGTEXT("PRACTICE_NUMBER_ANSWER"), i, Constants.questionPar5List.count)
            botPracticeBar?.checkButton.setTitle("Kết thúc", for: UIControlState())
            let percent = Constants.getPercent(i, total: Constants.questionPar5List.count)
            DatabaseManager().updateExpertience(Constants.databaseName, bookID: Constants.bookID!, testID: Constants.testID!, part: 5, percent: percent)
            botPracticeBar?.checkButton.setTitle(Constants.LANGTEXT("PRACTICE_END"), for: UIControlState())
            botPracticeBar?.checkButton.addTarget(self, action: #selector(cancePractice), for: .touchUpInside)
        }
        else if Constants.status == .review{
            var i = 0
            Constants.questionPar5List.forEach({ (data) in
                if data.answer == data.answerSelected {
                    i = i + 1
                }
            })
            bottomBarView?.numberTrueLabel.text = String(format:"%@ %i/%i",Constants.LANGTEXT("PRACTICE_NUMBER_ANSWER"), i, Constants.questionPar5List.count)
            bottomBarView?.numberTrueLabel.isHidden = false
        }
        else {
            backSelected()
        }

    }
    
    // MARK: Tool Bar
    
    func addToolBarTest() {
        testToolBar = Bundle.main.loadNibNamed("TestToolBarView", owner: self, options: nil)?.first as? TestToolBarView
        testToolBar?.frame = CGRect(x: 0, y: 0, width: toolBar.frame.size.width, height: toolBar.frame.size.height)
        testToolBar?.canceTestButton.addTarget(self, action: #selector(canceTest), for: .touchUpInside)
        testToolBar?.partName.text = "PART 5"
        toolBar.addSubview(testToolBar!)
        if Constants.status == .review {
            testToolBar?.timerLabel.text = "00: 00: 00"
        }
    }
    
    func addBottomBarTest() {
        bottomBarView = Bundle.main.loadNibNamed("BottomBarView", owner: self, options: nil)?.first as? BottomBarView
        bottomBarView?.nextButton.addTarget(self, action: #selector(nextSelected), for: .touchUpInside)
        bottomBarView?.backButton.addTarget(self, action: #selector(backSelected), for: .touchUpInside)
        if Constants.status == .test {
            bottomBarView?.backButton.isHidden = true
        }
        else if Constants.status == .review {
            bottomBarView?.backButton.isHidden = false
        }
        bottomBarView?.frame = CGRect(x: 0, y: 0, width: botToolBar.frame.size.width, height: botToolBar.frame.size.height)
        botToolBar.addSubview(bottomBarView!)
    }
    
    func addTopPracticeBar() {
        topPracticeBar = Bundle.main.loadNibNamed("TopBarView", owner: self, options: nil)?.first as? TopBarView
        topPracticeBar?.canceButton.addTarget(self, action: #selector(backSelected), for: .touchUpInside)
        topPracticeBar?.partLabel.text = "Practice Part 5"
        topPracticeBar?.frame = CGRect(x: 0, y: 0, width: toolBar.frame.size.width, height: toolBar.frame.size.height)
        toolBar.addSubview(topPracticeBar!)
    }
    
    func addBotPracticeBar() {
        botPracticeBar = Bundle.main.loadNibNamed("BotBarView", owner: self, options: nil)?.first as? BotBarView
        botPracticeBar?.frame = CGRect(x: 0, y: 0, width: botToolBar.frame.size.width, height: botToolBar.frame.size.height)
        botPracticeBar?.checkButton.addTarget(self, action: #selector(checkSelected), for: .touchUpInside)
        botToolBar.addSubview(botPracticeBar!)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y<0 {
            showTimeBar()
        }
        else {
            higeTimeBar()
        }
    }
    
    func showTimeBar() {
        UIView.animate(withDuration: 0.5, animations: {
            self.toolBar.transform = CGAffineTransform(translationX: 0, y: 0)
            self.botToolBar.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    func higeTimeBar() {
        UIView.animate(withDuration: 0.5, animations: {
            self.toolBar.transform = CGAffineTransform(translationX: 0, y: -35)
            self.botToolBar.transform = CGAffineTransform(translationX: 0, y: -35)
        })
    }
    
}
