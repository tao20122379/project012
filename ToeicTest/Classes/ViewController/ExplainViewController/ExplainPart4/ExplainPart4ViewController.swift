//
//  ExplainPart4ViewController.swift
//  ToeicTest
//
//  Created by khactao on 4/24/17.
//
//

import UIKit

class ExplainPart4ViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource  {

    // MARK: - IBOutleft and variable
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var audioExplainView: UIView!
    var section_ID: Int?
    var explainPart4: Explain34Model?
    var audioView: AudioExplainView?
    
    // MARK: - Life cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = String(format: "Question %i-%i", (section_ID!-1)*3+71, (section_ID!-1)*3+73)
        loadData()
        audioView = NSBundle.mainBundle().loadNibNamed("AudioExplainView", owner: self, options: nil).first as? AudioExplainView
        audioView!.audioPlayWithName(Constants.audioName!+"4", startTime: (explainPart4?.startTime)!, endTime: (explainPart4?.endTime)!)
        audioView!.frame = CGRect(x: -1, y: 0, width: Constants.SCREEN_WIDTH+2, height: Constants.SCREEN_HEIGHT/5)
        self.audioExplainView.addSubview(audioView!)
        super.createTranslateButton(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        audioView!.stopMusic()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTable()
        
    }
    
    func loadData() {
        DatabaseManager().loadExplainPart4(Constants.databaseName, bookID: Constants.bookID!, testID: Constants.testID!, sectionID: section_ID!) { (state, datas) in
            self.explainPart4 = datas as? Explain34Model
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Funcion
    func settingTable() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "PassageCell", bundle: nil), forCellReuseIdentifier: "passageCell")
        for i in 0..<3  {
            self.tableView.registerNib(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: String(format: "questionCell%i",i))
        }
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 130
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("passageCell") as! PassageCell
            cell.initWith(String(format: "%i-%i. ", (section_ID!-1)*3+71, (section_ID!-1)*3+73)+(explainPart4?.title)!, passage: (explainPart4?.passage)!)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("questionCell0") as! QuestionCell
            cell.initWithData((explainPart4?.questionArray[0])!)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("questionCell1") as! QuestionCell
            cell.initWithData((explainPart4?.questionArray[1])!)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("questionCell2") as! QuestionCell
            cell.initWithData((explainPart4?.questionArray[2])!)
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("questionCell0") as! QuestionCell
            return cell
        }
    }

}
