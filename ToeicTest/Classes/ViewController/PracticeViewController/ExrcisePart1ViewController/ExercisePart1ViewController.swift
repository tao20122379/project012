//
//  ExercisePart1ViewController.swift
//  ToeicTest
//
//  Created by khactao on 8/30/17.
//
//

import UIKit
import YLProgressBar
import GoogleMobileAds

class ExercisePart1ViewController: UIViewController {
    //MARK: - IBOutleft and variable
    @IBOutlet weak var banderView: GADBannerView!
    @IBOutlet weak var progress: YLProgressBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    var part1Question: Part1Model?
    var imageName: String = ""
    var audioName: String = ""
    var mp3Player: MP3Player = MP3Player()
    var mp3True: MP3Player = MP3Player()
    var mp3False: MP3Player = MP3Player()
    var target: Int = 10
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
        loadDataPart1()
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
        tableView.register(UINib(nibName: "Part1QuestionCell", bundle: nil), forCellReuseIdentifier: "part1Cell")
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
    
    func loadDataPart1() {
        isSubmit = false
        var randomObject = DatabaseManager().randomPart1Data()
        var i = 0
        while !checkRandom(randomObject) {
            randomObject = DatabaseManager().randomPart1Data()
            i = i + 1
            if i > 10 {
                break
            }
        }
        part1Question = DatabaseManager().getQuestionDataPart1Random(randomObject)
        DatabaseManager().loadTestData(Constants.databaseName, bookID: (part1Question?.bookID)!, testID: (part1Question?.testID)!) { (status, datas) in
            if status {
                let testModel = datas as! TestModel
                self.imageName = testModel.imageName
                self.audioName = testModel.audioName+"1"
            }
        }
        randomSave.append(randomObject.id)
        mp3Player.audioPlayWithName(self.audioName, startTime: (part1Question?.timeStart)!, endTime: (part1Question?.timeEnd)!+1)
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
    
    @IBAction func nextSelected(_ sender: AnyObject) {
        nextButton.isEnabled = false
        nextButton.alpha = 0.5
        submitButton.isEnabled = true
        submitButton.alpha = 1
        mp3Player.stop()
        loadDataPart1()
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
    
    
    @IBAction func submitSelected(_ sender: AnyObject) {
        isSubmit = true
        nextButton.isEnabled = true
        nextButton.alpha = 1
        submitButton.isEnabled = false
        submitButton.alpha = 0.5
        tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    @IBAction func cancelSelected(_ sender: AnyObject) {
        let alert = UIAlertController(title: "", message: Constants.LANGTEXT("TEST_NOTE_CANE"), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: Constants.LANGTEXT("COMMON_OK"), style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: Constants.LANGTEXT("COMMON_CANCE"), style: .default, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - Tableview Datasource
extension ExercisePart1ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

//MARK: - TableView Delegate
extension ExercisePart1ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "part1Cell") as! Part1QuestionCell
        cell.delegate = self
        cell.questionNumber.text = String(format: "%i.", (part1Question?.questionID)!)
        if part1Question!.answerSelected == 0 {
            cell.refresh()
        }
        if isSubmit {
            cell.showReview()
        }
        cell.pictureQuestion?.image = UIImage(named: String(format: "%@%i", self.imageName, (part1Question?.questionID)!))
        cell.initWithData(part1Question!)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height+30
    }
}

//MARK: - Part1Delegate
extension ExercisePart1ViewController: Part1Question_Delegate {
    func explainQuestion(_ questionData: Part1Model) {
        let explainVC = ExplainPart1ViewController(nibName: "ExplainPart1ViewController", bundle: nil)
        explainVC.questionData = part1Question
        self.navigationController?.pushViewController(explainVC, animated: true)
    }
    
    func selectAnswer(_ state: Bool) {
        if state == true {
            mp3True.play()
            numberTrue = numberTrue + 1
            progress.setProgress(CGFloat(Float(numberTrue)/Float(target)), animated: true)
            if numberTrue == target {
                let alert = UIAlertController(title: "", message: String(format: "%@-%i/%i", Constants.LANGTEXT("TEST_NOTE_CANE"), numberTrue, numberTrue+numberFalse), preferredStyle: UIAlertControllerStyle.alert)
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
