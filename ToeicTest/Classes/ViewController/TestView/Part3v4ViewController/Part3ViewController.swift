
import UIKit

class Part3ViewController: BaseViewController {
    
    // MARK: - IBOutleft and variable

    @IBOutlet weak var botToolBar: UIView!
    @IBOutlet weak var toolBar: UIView!
    @IBOutlet weak var questionTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    var listHeader: Array = Array<HeaderView>()
    var testToolBar : TestToolBarView?
    var bottomBarView: BottomBarView?
    var topPracticeBar: TopBarView?
    var botPracticeBar: BotBarView?

    
    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if Constants.status == .test {
            self.testToolBar?.timerLabel.text = Constants.formatTimer(Constants.second, minute: Constants.minute, hours: Constants.hours)
        }
        else if Constants.status == .review {
            checkSelected()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Constants.mp3Player?.stop()
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
        if Constants.status != .review {
            Constants.mp3Player? = MP3Player()
            Constants.mp3Player?.initWithFileMp3(Constants.audioName!+"3")
            super.startTimer()
            Constants.mp3Player?.play()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func endTest() {
        Constants.mp3Player?.stop()
    }
    
    // MARK: - Timer
    override func showTimer() {
        if  Constants.status == .test && Constants.second == 0 && Constants.minute == 0 &&  Constants.hours == 0 {
            super.showTimer()
            nextSelected()
        }
        self.testToolBar?.timerLabel.text = Constants.formatTimer(Constants.second, minute: Constants.minute, hours: Constants.hours)
    }
    
    // MARK: - Setting Table View
    func settingTableView() {
        let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as! HeaderView
        self.questionTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 35))
        listHeader.append(headerView)
        questionTableView.delegate = self
        questionTableView.dataSource = self
        questionTableView.rowHeight = UITableViewAutomaticDimension
        questionTableView.estimatedRowHeight = 100
    
        for i in 0..<Constants.questionPar3List.count {
            self.questionTableView.register(UINib.init(nibName:"Part3v4CellQuestion", bundle: nil), forCellReuseIdentifier: String(format: "part3Cell%i", i))
        }
        let directionView = Bundle.main.loadNibNamed("DirectionPart3View", owner: self, options: nil)?.first as! DerectionPart3View

        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: Constants.SCREEN_WIDTH, height: 150))
        directionView.frame = CGRect(x: 0, y: 0, width: Constants.SCREEN_WIDTH, height: 150)
        directionView.titleLabel.text = "PART3"
        directionView.contentLabel.text = Constants.directionPart3
        view1.clipsToBounds = true
        view1.addSubview(directionView)
        questionTableView.tableHeaderView = view1
        
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
    
    // MARK: - Button Selected
    func nextSelected() {
        Constants.mp3Player?.stop()
        if Constants.status == .test {
            Constants.questionPar3List.forEach { (questionData) in
                if questionData.answerSelected == questionData.answer && questionData.answerSelected != 0{
                    Constants.numberListenngTrue = Constants.numberListenngTrue + 1
                }
            }
        }
        let part4 = Part4ViewController(nibName: "Part4ViewController", bundle: nil)
        self.navigationController?.pushViewController(part4, animated: true)
        
    }
    
    func backSelected() {
        self.navigationController?.popViewController(animated: true)
    }

    func checkSelected() {
        if  Constants.status == .practice {
            Constants.status = .review
            bottomBarView?.numberTrueLabel.isHidden = false
            Constants.mp3Player?.stop()
            questionTableView.reloadData()
            var i = 0
            Constants.questionPar3List.forEach({ (data) in
                if data.answer == data.answerSelected {
                    i = i + 1
                }
            })
            topPracticeBar?.googleTranslateButton.isHidden = false
            botPracticeBar?.numberTrueLabel.text = String(format: "%@ %i/%i", Constants.LANGTEXT("PRACTICE_NUMBER_ANSWER"), i, Constants.questionPar3List.count)
        
            let percent = Constants.getPercent(i, total: Constants.questionPar3List.count)
            DatabaseManager().updateExpertience(Constants.databaseName, bookID: Constants.bookID!, testID: Constants.testID!, part: 3, percent: percent)
            botPracticeBar?.checkButton.setTitle(Constants.LANGTEXT("PRACTICE_END"), for: UIControlState())
            botPracticeBar?.checkButton.addTarget(self, action: #selector(cancePractice), for: .touchUpInside)
        }
        else if Constants.status == .review{
            var i = 0
            Constants.questionPar3List.forEach({ (data) in
                if data.answer == data.answerSelected {
                    i = i + 1
                }
            })
            bottomBarView?.numberTrueLabel.text = String(format: "%@ %i/%i",Constants.LANGTEXT("PRACTICE_NUMBER_ANSWER"), i, Constants.questionPar3List.count)
            bottomBarView?.numberTrueLabel.isHidden = false
        }
        else {
            backSelected()
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
    

    
    // MARK: Tool Bar
    func addToolBarTest() {
        testToolBar = Bundle.main.loadNibNamed("TestToolBarView", owner: self, options: nil)?.first as? TestToolBarView
        testToolBar?.frame = CGRect(x: 0, y: 0, width: toolBar.frame.size.width, height: toolBar.frame.size.height)
        testToolBar?.canceTestButton.addTarget(self, action: #selector(canceTest), for: .touchUpInside)
        testToolBar?.partName.text = "PART 3"
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
        topPracticeBar?.partLabel.text = "Practice Part 3"
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

extension Part3ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.questionPar3List.count/3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}

extension Part3ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let questionData = Constants.questionPar3List[indexPath.section*3 + indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(format: "part3Cell%i", indexPath.section*3+indexPath.row)) as! Part3v4CellQuestion
        cell.questionNumber.text = String(format: "%i.", indexPath.section*3+indexPath.row+41)
        cell.initwithData(questionData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if Constants.status == .review {
            return 40
        }
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if Constants.status == .review {
            return 36
        }
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = Bundle.main.loadNibNamed("FooterExplainView", owner: self, options: nil)?.first as! FooterExplainView
        footerView.delegate = self
        footerView.sectionID = section+1
        return footerView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as! HeaderView
        headerView.questionNumber.text = String(format: "Question %i-%i", 40+section*3+1, 40+section*3+3)
        headerView.questionGroupInfor.text = ""
        return headerView
    }
}

extension Part3ViewController: FooterExplain_Delegate {
    func explainSection(_ section: Int) {
        var questions: Array<Part34Model> = Array<Part34Model>()
        for i in 0..<3 {
            let question = Constants.questionPar3List[(section-1)*3+i]
            question.number = 40+(section-1)*3+i+1
            questions.append(question)
        }
        let explainPart3VC = Explain3ViewController(nibName: "Explain3ViewController", bundle: nil)
        explainPart3VC.questionsArray = questions
        self.navigationController?.pushViewController(explainPart3VC, animated: true)
    }
}
