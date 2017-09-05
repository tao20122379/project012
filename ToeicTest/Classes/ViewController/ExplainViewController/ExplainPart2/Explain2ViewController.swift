//
//  Explain2ViewController.swift
//  ToeicTest
//
//  Created by khactao on 3/30/17.
//
//

import UIKit

class Explain2ViewController: BaseViewController {

    // MARK: - IBOutleft and variable
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var audioExplainView: UIView!
    var questionData: Part2Model?
    var explainPart2: Explain2Model?
    var audioView: AudioExplainView?
    
    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = String(format: "Question %i", questionData!.questionID+10)
        super.createTranslateButton(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioView!.stopMusic()
    }
    
    override func viewDidLoad() {
        loadDataExplain(self.questionData!)
        super.viewDidLoad()
        settingTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Funcion
    func loadDataExplain(_ questionData: Part2Model) {
        audioView = Bundle.main.loadNibNamed("AudioExplainView", owner: self, options: nil)?.first as? AudioExplainView
        audioView!.frame = CGRect(x: -1, y: 0, width: Constants.SCREEN_WIDTH+2, height: Constants.SCREEN_HEIGHT/5)
        self.audioExplainView.addSubview(audioView!)
        DatabaseManager().loadExplainPart2(Constants.databaseName, bookID: questionData.bookID, testID: questionData.testID!, questionID: (questionData.questionID)!) { (state, datas) in
            if state == true {
                self.explainPart2 = datas as? Explain2Model
                self.explainPart2?.question.answer = self.questionData?.answer
                self.explainPart2?.question.number = self.questionData?.number
            }
        }
        DatabaseManager().loadTestData(Constants.databaseName, bookID: questionData.bookID, testID: questionData.testID) { (status, datas) in
            if status {
                let testModel = datas as! TestModel
                self.explainPart2?.audioName = testModel.audioName+"2"
            }
        }
        audioView!.audioPlayWithName((self.explainPart2?.audioName)!, startTime: questionData.timeStart!, endTime: questionData.timeEnd!)
    }
    
    func settingTable() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "questionCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 130
    }
    
  
}

// MARK: - TableView Datasource
extension Explain2ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

// MARK: - TableView Delegate
extension Explain2ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as! QuestionCell
        cell.questionNumberLabel.text = String(format: "%i.", (questionData?.questionID)!+10)
        cell.initWithData((explainPart2?.question)!)
        return cell
    }

}
