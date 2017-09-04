//
//  ExercisePart2ViewController.swift
//  ToeicTest
//
//  Created by khactao on 8/30/17.
//
//

import UIKit
import YLProgressBar
import GoogleMobileAds

class ExercisePart2ViewController: UIViewController {

    //MARK: - IBOutleft and variable
    @IBOutlet weak var banderView: GADBannerView!
    @IBOutlet weak var progress: YLProgressBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    var part2Question: Part2Model?
    var part2Explain: Explain2Model?
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
        loadDataPart2()
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
        tableView.register(UINib(nibName: "ExercisePart2Cell", bundle: nil), forCellReuseIdentifier: "part2Cell")
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
    

    func loadDataPart2() {
        isSubmit = false
        var randomObject = DatabaseManager().randomPart2Data()
        var i = 0
        while !checkRandom(randomObject) {
            randomObject = DatabaseManager().randomPart2Data()
            i = i + 1
            if i > 20 {
                break
            }
        }
        part2Question = DatabaseManager().getQuestionDataPart2Random(randomObject)
        DatabaseManager().loadTestData(Constants.databaseName, bookID: (part2Question?.bookID)!, testID: (part2Question?.testID)!) { (status, datas) in
            if status {
                let testModel = datas as! TestModel
                self.audioName = testModel.audioName+"2"
            }
        }
        DatabaseManager().loadExplainPart2(Constants.databaseName, bookID: (part2Question?.bookID)!, testID: (part2Question?.testID!)!, questionID: (part2Question?.questionID)!) { (state, datas) in
            part2Explain = datas as? Explain2Model
            part2Explain?.question.answer = part2Question?.answer
            part2Explain?.question.number = part2Question?.number
        }
        randomSave.append(randomObject.id)
        mp3Player.audioPlayWithName(self.audioName, startTime: (part2Question?.timeStart)!, endTime: (part2Question?.timeEnd)!+1)
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
        loadDataPart2()
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
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    @IBAction func cancelSelected(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - Tableview Datasource
extension ExercisePart2ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1

    }
}

//MARK: - TableView Delegate
extension ExercisePart2ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "part2Cell") as! ExercisePart2Cell
        cell.delegate = self
        cell.questionData = part2Question
        cell.initwithExplainData(part2Explain!)
        if part2Question!.answerSelected == 0 {
            cell.refresh()
        }
        if isSubmit == true {
            cell.showReview()
        }
        return cell
    }
}

//MARK: - Part1Delegate
extension ExercisePart2ViewController: Part2Exercise_Delegate {
    func explainQuestion(_ questionData: Part2Model) {
        let explainVC = Explain2ViewController(nibName: "Explain2ViewController", bundle: nil)
        explainVC.questionData = part2Question
        self.navigationController?.pushViewController(explainVC, animated: true)
    }
    
    func selectAnswer(_ state: Bool) {
        if state == true {
            mp3True.play()
            numberTrue = numberTrue + 1
            progress.setProgress(CGFloat(Float(numberTrue)/Float(target)), animated: true)
            if numberTrue == target {
                let alert = UIAlertController(title: "", message: String(format: "%@ %i/%i", Constants.LANGTEXT("EXERCISE_NOTE_FINISH"), numberTrue, numberTrue+numberFalse), preferredStyle: UIAlertControllerStyle.alert)
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
