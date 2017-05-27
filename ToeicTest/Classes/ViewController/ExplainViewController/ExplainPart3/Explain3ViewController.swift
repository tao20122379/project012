//
//  Explain3ViewController.swift
//  ToeicTest
//
//  Created by khactao on 3/30/17.
//
//

import UIKit

class Explain3ViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - IBOutleft and variable
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var audioExplainView: UIView!
    var section_ID: Int?
    var explainPart3: Explain34Model?
    var audioView: AudioExplainView?
    
    // MARK: - Life cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = String(format: "Question %i-%i", (section_ID!-1)*3+41, (section_ID!-1)*3+43)
        loadData()
        audioView = NSBundle.mainBundle().loadNibNamed("AudioExplainView", owner: self, options: nil).first as? AudioExplainView
        audioView!.audioPlayWithName(BaseViewController.audioName!+"3", startTime: (explainPart3?.startTime)!, endTime: (explainPart3?.endTime)!)
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
        DatabaseManager().loadExplainPart3(Constants.databaseName, bookID: BaseViewController.bookID!, testID: BaseViewController.testID!, sectionID: section_ID!) { (state, datas) in
            self.explainPart3 = datas as? Explain34Model
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
            cell.initWith(String(format: "%i-%i. ", (section_ID!-1)*3+41, (section_ID!-1)*3+43)+"refer to the following conversation.", passage: (explainPart3?.passage)!)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("questionCell0") as! QuestionCell
            cell.initWithData((explainPart3?.questionArray[0])!)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("questionCell1") as! QuestionCell
            cell.initWithData((explainPart3?.questionArray[1])!)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("questionCell2") as! QuestionCell
            cell.initWithData((explainPart3?.questionArray[2])!)
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("questionCell0") as! QuestionCell
            return cell
        }
    }
}
