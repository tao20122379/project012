//
//  Part6ViewController.swift
//  ToeicTest
//
//  Created by khactao on 12/31/16.
//
//

import UIKit

class Part6ViewController: BaseViewController {
    
    // MARK: - IBOutleft and variable
    @IBOutlet weak var botToolBar: UIView!
    @IBOutlet weak var toolBar: UIView!
    @IBOutlet weak var questionTableView: UITableView!
    var testToolBar : TestToolBarView?
    var bottomBarView: BottomBarView?
    var topPracticeBar: TopBarView?
    var botPracticeBar: BotBarView?
    var listHeaderView = Array<HeaderView>()
    var part6Index: Int = 0
    
    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        settingTableView()
        
        if Constants.status == .test {
            self.testToolBar?.timerLabel.text = Constants.formatTimer(Constants.second, minute: Constants.minute, hours: Constants.hours)
        }
        else if Constants.status == .review ||  Constants.status == .reviewPractice {
            checkSelected()
            bottomBarView?.backButton.isHidden = false
            self.questionTableView.reloadData()
        }
        botPracticeBar?.checkButton.setTitle(Constants.LANGTEXT("PRACTICE_CHECK"), for: UIControlState())
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        switch Constants.status {
        case .test:
            super.startTimer()
            addToolBarTest()
            addBottomBarTest()
            break
        case .practice:
            if Constants.part6Index >= 3 {
                addTopPracticeBar()
                addBotPracticeBar()
            }
            else {
                addTopPracticeBar()
                addBottomBarTest()
            }
            break
        case .review:
                addToolBarTest()
                addBottomBarTest()
            break
        case .reviewPractice:
            addTopPracticeBar()
            if Constants.part6Index >= 3 {
                NSLog("test")
                self.addBotPracticeBar()
                checkSelected()
                botPracticeBar?.backButton.isHidden = false
            }
            else {
                self.addBottomBarTest()
            }
            break
        default:
            break
        }
        
        botPracticeBar?.backButton.addTarget(self, action: #selector(backSelected), for: .touchUpInside)
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
        self.questionTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 35))
        self.questionTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 35))
        questionTableView.rowHeight = UITableViewAutomaticDimension
        questionTableView.estimatedRowHeight = 250
        questionTableView.delegate = self
        questionTableView.dataSource = self
        self.questionTableView.register(UINib.init(nibName:"Part6Cell", bundle: nil), forCellReuseIdentifier: String(format: "part6Cell%i", part6Index))
    }
    
    // MARK: - Funcion
    func checkSelected() {
        if  Constants.status == .practice {
            Constants.status = .reviewPractice
            botPracticeBar?.backButton.isHidden = false
            bottomBarView?.backButton.isHidden = false
            bottomBarView?.numberTrueLabel.isHidden = false
            questionTableView.reloadData()
            Constants.mp3Player?.stop()
            var i = 0
            var numberQuestion = 0
            Constants.questionPar6List.forEach({ (data) in
                data.questionArray.forEach({ (questionData) in
                    numberQuestion = numberQuestion + 1
                    if questionData.answerSelected == questionData.answer {
                        i = i + 1
                    }
                })
            })
            topPracticeBar?.googleTranslateButton.isHidden = false
            botPracticeBar?.numberTrueLabel.text = String(format: " %@ %i/%i", Constants.LANGTEXT("PRACTICE_NUMBER_ANSWER"), i, numberQuestion)
            botPracticeBar?.checkButton.setTitle(Constants.LANGTEXT("PRACTICE_END"),for: UIControlState())
            let percent = Constants.getPercent(i, total: numberQuestion)
            DatabaseManager().updateExpertience(Constants.databaseName, bookID: Constants.bookID!, testID: Constants.testID!, part: 6, percent: percent)
            botPracticeBar?.checkButton.addTarget(self, action: #selector(cancePractice), for: .touchUpInside)
        }
        else if Constants.status == .reviewPractice || Constants.status == .review{
            var i = 0
            var numberQuestion = 0
            Constants.questionPar6List.forEach({ (data) in
                data.questionArray.forEach({ (questionData) in
                    numberQuestion = numberQuestion + 1
                    if questionData.answerSelected == questionData.answer {
                        i = i + 1
                    }
                })
            })
            bottomBarView?.numberTrueLabel.text = String(format: "%@ %i/%i",Constants.LANGTEXT("PRACTICE_NUMBER_ANSWER"), i, numberQuestion)
            bottomBarView?.numberTrueLabel.isHidden = false
        }
        else {
            backSelected()
        }

    }
    
    // MARK: - Button ACtion
    func nextSelected() {
        if Constants.status == .test {
            Constants.questionPar6List.forEach { (questonPart6Data) in
                questonPart6Data.questionArray.forEach({ (questionData) in
                    if questionData.answerSelected == questionData.answer && questionData.answerSelected != 0 {
                        Constants.numberReadingTrue = Constants.numberReadingTrue + 1
                    }
                })
            }
        }
        if Constants.part6Index < 3 {
            Constants.part6Index = Constants.part6Index + 1
            let part6 = Part6ViewController(nibName: "Part6ViewController", bundle: nil)
            self.navigationController?.pushViewController(part6, animated: true)
        }
        else {
            let part7 = Part7ViewController(nibName: "Part7ViewController", bundle: nil)
            self.navigationController?.pushViewController(part7, animated: true)
        }
    }
    
    func backSelected() {
        Constants.part6Index = Constants.part6Index - 1
        self.navigationController?.popViewController(animated: true)
    }
    
    func cancePractice() {
        let viewcontroller = super.navigationController?.viewControllers[1]
        super.navigationController?.popToViewController(viewcontroller!, animated: true)
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
    
    // MARK: Tool Bar
    func addToolBarTest() {
        testToolBar = Bundle.main.loadNibNamed("TestToolBarView", owner: self, options: nil)?.first as? TestToolBarView
        testToolBar?.frame = CGRect(x: 0, y: 0, width: toolBar.frame.size.width, height: toolBar.frame.size.height)
        testToolBar?.canceTestButton.addTarget(self, action: #selector(canceTest), for: .touchUpInside)
        testToolBar?.partName.text = "PART 6"
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
        topPracticeBar?.canceButton.addTarget(self, action: #selector(cancePractice), for: .touchUpInside)
        topPracticeBar?.partLabel.text = "Practice Part 6"
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

// MARK: - TableView Datasoure
extension Part6ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

// MARK: - TableView Delegate
extension Part6ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let part6Model = Constants.questionPar6List[Constants.part6Index]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(format: "part6Cell%i", part6Index)) as! Part6Cell
        cell.titleLabel.text = String(format: "Question %i-%i : %@", 141 + Constants.part6Index*3, 141 + Constants.part6Index*3 + 2, part6Model.title)
        cell.question1Label.text = String(format: "%i.", 141 + Constants.part6Index*3)
        cell.question2Label.text = String(format: "%i.", 141 + Constants.part6Index*3 + 1)
        cell.question3Label.text = String(format: "%i.", 141 + Constants.part6Index*3 + 2)
        cell.initWithData(part6Model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    


}
