//
//  ExplainPart4ViewController.swift
//  ToeicTest
//
//  Created by khactao on 4/24/17.
//
//

import UIKit

class ExplainPart4ViewController: BaseViewController {

    // MARK: - IBOutleft and variable
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var audioExplainView: UIView!
    var questionsArray: Array<Part34Model>?
    var explainPart4: Explain34Model?
    var audioView: AudioExplainView?
    
    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = String(format: "Question %i-%i", (questionsArray![0].sectionID!-1)*3+71, (questionsArray![0].sectionID!-1)*3+73)
        loadDataExplain(questionsArray!)
        super.createTranslateButton(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioView!.stopMusic()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTable()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Funcion
    func settingTable() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "PassageCell", bundle: nil), forCellReuseIdentifier: "passageCell")
        for i in 0..<3  {
            self.tableView.register(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: String(format: "questionCell%i",i))
        }
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 130
    }
    
    func  loadDataExplain(_ questions: Array<Part34Model>) {
        DatabaseManager().loadExplainPart4(Constants.databaseName, bookID: questions[0].bookID, testID: questions[0].testID, sectionID: questions[0].sectionID) { (state, datas) in
            self.explainPart4 = datas as? Explain34Model
            questions.forEach({ (questionData) in
                self.explainPart4!.questionArray.append(questionData)
            })
        }
        DatabaseManager().loadTestData(Constants.databaseName, bookID: questions[0].bookID, testID: questions[0].testID) { (status, datas) in
            if status {
                let testModel = datas as! TestModel
                self.explainPart4!.audioName = testModel.audioName+"4"
            }
        }
        audioView = Bundle.main.loadNibNamed("AudioExplainView", owner: self, options: nil)?.first as? AudioExplainView
        audioView!.audioPlayWithName(self.explainPart4!.audioName, startTime: (explainPart4?.startTime)!, endTime: (explainPart4?.endTime)!)
        audioView!.frame = CGRect(x: -1, y: 0, width: Constants.SCREEN_WIDTH+2, height: Constants.SCREEN_HEIGHT/5)
        self.audioExplainView.addSubview(audioView!)
    }
}

extension ExplainPart4ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
}

extension ExplainPart4ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "passageCell") as! PassageCell
            cell.initWith(String(format: "%i-%i. ", (questionsArray![0].sectionID!-1)*3+71, (questionsArray![0].sectionID!-1)*3+73)+(explainPart4?.title)!, passage: (explainPart4?.passage)!)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell0") as! QuestionCell
            cell.initWithData((explainPart4?.questionArray[0])!)
            cell.questionNumberLabel.text = String(format: "%i.", questionsArray![0].sectionID*3+67+indexPath.row)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell1") as! QuestionCell
            cell.initWithData((explainPart4?.questionArray[1])!)
            cell.questionNumberLabel.text = String(format: "%i.", questionsArray![0].sectionID*3+67+indexPath.row)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell2") as! QuestionCell
            cell.initWithData((explainPart4?.questionArray[2])!)
            cell.questionNumberLabel.text = String(format: "%i.", questionsArray![0].sectionID*3+67+indexPath.row)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell0") as! QuestionCell
            return cell
        }
    }

}
