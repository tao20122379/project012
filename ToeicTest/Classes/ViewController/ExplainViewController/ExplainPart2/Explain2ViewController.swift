//
//  Explain2ViewController.swift
//  ToeicTest
//
//  Created by khactao on 3/30/17.
//
//

import UIKit

class Explain2ViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - IBOutleft and variable
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var audioExplainView: UIView!
    var questionData: Part2Model?
    var explainPart2: Explain2Model?
    var audioView: AudioExplainView?
    
    // MARK: - Life cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = String(format: "Question %i", questionData!.number)
        loadData()
        audioView = NSBundle.mainBundle().loadNibNamed("AudioExplainView", owner: self, options: nil).first as? AudioExplainView
        audioView!.audioPlayWithName(Constants.audioName!+"2", startTime: (explainPart2?.startTime)!, endTime: (explainPart2?.endTime)!)
        audioView!.frame = CGRect(x: -1, y: 0, width: Constants.SCREEN_WIDTH+2, height: Constants.SCREEN_HEIGHT/5)
        self.audioExplainView.addSubview(audioView!)
        super.createTranslateButton(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSLog("test")
        audioView!.stopMusic()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Funcion
    
    func loadData() {
        DatabaseManager().loadExplainPart2(Constants.databaseName, bookID: Constants.bookID!, testID: Constants.testID!, questionID: (questionData?.questionID)!) { (state, datas) in
            self.explainPart2 = datas as? Explain2Model
            self.explainPart2?.question.answer = self.questionData?.answer
            self.explainPart2?.question.number = self.questionData?.number
        }
    }
    
    func settingTable() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "questionCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 130
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("questionCell") as! QuestionCell
        cell.initWithData((explainPart2?.question)!)
        return cell
    }

}
