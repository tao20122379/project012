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
    override func viewWillAppear(_ animated: Bool) {
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Constants.mp3Player?.stop()
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
            self.questionTableView.register(UINib.init(nibName:"Part1QuestionCell", bundle: nil), forCellReuseIdentifier: String(format: "part1Cell%i", i))
        }
        questionTableView.delegate = self
        questionTableView.dataSource = self
        questionTableView.rowHeight = Constants.SCREEN_WIDTH*6/11
        directionView = (Bundle.main.loadNibNamed("DirectionPart1View", owner: self, options: nil)?.first as! DirectionPart1View)
        directionView!.exampleLabel.text = Constants.bookData?.direction1
        directionView!.exampleImage.image = UIImage(named: (Constants.bookData?.imageName)!+"0")

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.questionPar1List.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(format: "part1Cell%i", indexPath.row)) as! Part1QuestionCell
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
            self.questionTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
        isNewTest = false
    }
    
    func explainQuestion(_ questionData: Part1Model) {
        let explainVC = ExplainPart1ViewController(nibName: "ExplainPart1ViewController", bundle: nil)
        explainVC.questionData = questionData
        self.navigationController?.pushViewController(explainVC, animated: true)
    }

    
    // MARK: - Button Selected
    
    func nextSelected() {
        Constants.mp3Player?.stop()
        super.stopTimer()
        if Constants.status == .test {
            bottomBarView?.numberTrueLabel.isHidden = true
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
            Constants.mp3Player?.stop()
            questionTableView.reloadData()
            var i = 0
            Constants.questionPar1List.forEach({ (part1Data) in
                if part1Data.answer == part1Data.answerSelected {
                    i = i + 1
                }
            })
            topPracticeBar?.googleTranslateButton.isHidden = false
            botPracticeBar?.numberTrueLabel.text = String(format: "%@ %i/%i", Constants.LANGTEXT("PRACTICE_NUMBER_ANSWER"), i, Constants.questionPar1List.count)
            bottomBarView?.numberTrueLabel.isHidden = false
            let percent = Constants.getPercent(i, total: Constants.questionPar1List.count)
            DatabaseManager().updateExpertience(Constants.databaseName, bookID: Constants.bookID!, testID: Constants.testID!, part: 1, percent: percent)
            botPracticeBar?.checkButton.setTitle(Constants.LANGTEXT("PRACTICE_END"), for: UIControlState())
            botPracticeBar?.checkButton.addTarget(self, action: #selector(cancePractice), for: .touchUpInside)
        }
        else if Constants.status == .review{
            var i = 0
            Constants.questionPar1List.forEach({ (part1Data) in
                if part1Data.answer == part1Data.answerSelected {
                    i = i + 1
                }
            })
            bottomBarView?.numberTrueLabel.text = String(format: "%@ %i/%i", Constants.LANGTEXT("PRACTICE_NUMBER_ANSWER"), i, Constants.questionPar1List.count)
            bottomBarView?.numberTrueLabel.isHidden = false
        }
    }
    
    // MARK: Tool Bar
    
    func addToolBarTest() {
        testToolBar = Bundle.main.loadNibNamed("TestToolBarView", owner: self, options: nil)?.first as? TestToolBarView
        testToolBar?.frame = CGRect(x: 0, y: 0, width: toolBar.frame.size.width, height: toolBar.frame.size.height)
        testToolBar?.canceTestButton.addTarget(self, action: #selector(canceTest), for: .touchUpInside)
        testToolBar?.partName.text = "PART 1"
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
        topPracticeBar?.partLabel.text = "Practice Part 1"
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
    
    func selectAnswer(_ state: Bool) {
        
    }
    
}
