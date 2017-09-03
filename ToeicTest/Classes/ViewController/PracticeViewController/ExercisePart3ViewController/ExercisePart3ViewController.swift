//
//  ExercisePart3ViewController.swift
//  ToeicTest
//
//  Created by khactao on 8/30/17.
//
//

import UIKit
import YLProgressBar
import GoogleMobileAds

class ExercisePart3ViewController: UIViewController {
    
    //MARK: - IBOutleft and variable
    @IBOutlet weak var banderView: GADBannerView!
    @IBOutlet weak var progress: YLProgressBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    var part3Section: Part34SectionModel?
    var audioName: String = ""
    var mp3Player: MP3Player = MP3Player()
    var mp3True: MP3Player = MP3Player()
    var mp3False: MP3Player = MP3Player()
    var target: Int = 30
    var numberTrue: Int = 0
    var numberFalse: Int = 0
    var randomSave: Array<Int> = Array<Int>()
    var isSubmit: Bool = false

    //MARK: - Cycle life
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mp3Player.stop()
    }
    
    override func viewDidLoad() {
        setData()
        loadDataPart3()
        configProgeress()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Funcion
    func setData() {
        nextButton.isEnabled = false
        mp3True.initWithFileMp3("true")
        mp3False.initWithFileMp3("fail")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: "Part3v4CellQuestion", bundle: nil), forCellReuseIdentifier: "part3Cell0")
        tableView.register(UINib(nibName: "Part3v4CellQuestion", bundle: nil), forCellReuseIdentifier: "part3Cell1")
        tableView.register(UINib(nibName: "Part3v4CellQuestion", bundle: nil), forCellReuseIdentifier: "part3Cell2")
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        banderView.adUnitID = "ca-app-pub-8928391130390155/4875730823"
        banderView.rootViewController = self
        banderView.load(request)
    }
    
    func configProgeress() {
        let tincolors: NSArray = [UIColor.colorFromHexString("00D800")]
        progress.progressTintColors       = tincolors as [AnyObject]
        progress.type                     = .rounded
        progress.indicatorTextDisplayMode = .none
        progress.indicatorTextLabel.textColor = UIColor.blue
        progress.behavior                 = .indeterminate
        progress.stripesOrientation       = .vertical
        progress.layer.cornerRadius = 9
        progress.layer.masksToBounds = true
        progress.layer.borderWidth = 1.5
        progress.layer.borderColor = UIColor.white.cgColor
    }
    
    func loadDataPart3() {
        isSubmit = false
        var randomObject = DatabaseManager().randomPart34Data()
        var i = 0
        while !checkRandom(randomObject) {
            randomObject = DatabaseManager().randomPart2Data()
            i = i + 1
            if i > 20 {
                break
            }
        }
        part3Section = DatabaseManager().getQuestionDataPart3Random(randomObject)
        DatabaseManager().loadTestData(Constants.databaseName, bookID: (part3Section?.bookID)!, testID: (part3Section?.testID)!) { (status, datas) in
            if status {
                let testModel = datas as! TestModel
                self.audioName = testModel.audioName+"2"
            }
        }
        randomSave.append(randomObject.id)
        mp3Player.audioPlayWithName(self.audioName, startTime: (part3Section?.timeStart)!, endTime: (part3Section?.timeEnd)!+1)
    }
    
    func checkRandom(_ randomObject: RandomModel) -> Bool {
        var check: Bool = true
        let count = randomSave.count
        for i in 0..<count {
            if randomSave[i] == randomObject.id {
                check = false
                break
            }
        }
        return check
    }
    
    @IBAction func nextSelected(_ sender: UIButton) {
        sender.isEnabled = false
        sender.alpha = 0.5
        submitButton.isEnabled = true
        submitButton.alpha = 1
        mp3Player.stop()
        loadDataPart3()
        UIView.animate(withDuration: 0.4, animations: {
            self.tableView.alpha = 0
        }, completion: { (status) in
            self.mp3True.stop()
            self.mp3False.stop()
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        })
        UIView.animate(withDuration: 0.4, animations: {
            self.tableView.alpha = 1
        }, completion: { (status) in
        })
    }
    
    @IBAction func submitSelected(_ sender: UIButton) {
        isSubmit = true
        nextButton.isEnabled = true
        nextButton.alpha = 1
        submitButton.isEnabled = false
        submitButton.alpha = 0.5
        tableView.reloadData()
    }
    
    @IBAction func cancelSelected(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - Tableview Datasource
extension ExercisePart3ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}

//MARK: - TableView Delegate
extension ExercisePart3ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(format: "part3Cell%i", indexPath.row)) as! Part3v4CellQuestion
//        cell.delegate = self
//        cell.questionData = part2Question
//        cell.initwithExplainData(part2Explain!)
//        if part2Question!.answerSelected == 0 {
//            cell.refresh()
//        }
//        if isSubmit == true {
//            cell.showReview()
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as! HeaderView
        headerView.delegate = self
        //headerView.questionNumber.text = String(format: "Question %i-%i", 40+section*3+1, 40+section*3+3)
        headerView.questionGroupInfor.text = "test"
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
}

//MARK: - Part1Delegate
extension ExercisePart3ViewController: Part2Exercise_Delegate {
    func explainQuestion(_ questionData: Part2Model) {
        let explainVC = Explain2ViewController(nibName: "Explain2ViewController", bundle: nil)
        self.navigationController?.pushViewController(explainVC, animated: true)
    }
    
    func selectAnswer(_ state: Bool) {
        if state == true {
            mp3True.play()
            numberTrue = numberTrue + 1
            progress.setProgress(CGFloat(Float(numberTrue)/Float(target)), animated: true)
            if numberTrue == target {
                let alert = UIAlertController(title: "", message: String(format: "%@-%i/%i", Constants.LANGTEXT("EXERCISE_NOTE_FINISH"), numberTrue, numberTrue+numberFalse), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: Constants.LANGTEXT("COMMON_OK"), style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            mp3False.play()
            numberFalse = numberFalse + 1
        }
    }
}

extension ExercisePart3ViewController: HeaderView_Delegate {
    func explainSection() {
        
    }
}