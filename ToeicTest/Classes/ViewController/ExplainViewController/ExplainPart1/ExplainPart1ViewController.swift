//
//  ExplainPart1ViewController.swift
//  ToeicTest
//
//  Created by khactao on 3/29/17.
//
//

import UIKit

class ExplainPart1ViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - IBOutleft and variable
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var audioExplainView: UIView!
    
    var questionData: Part1Model?
    var explainPart1: Explain1Model?
    var audioView: AudioExplainView?
    var numberQuestion: Int?

    // MARK: - Life cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = String(format: "Question %i", questionData!.number)
        loadData()
        audioView = NSBundle.mainBundle().loadNibNamed("AudioExplainView", owner: self, options: nil).first as? AudioExplainView
        audioView!.audioPlayWithName(Constants.audioName!+"1", startTime: (explainPart1?.startTime)!, endTime: (explainPart1?.endTime)!)
        audioView!.frame = CGRect(x: -1, y: 0, width: Constants.SCREEN_WIDTH+2, height: Constants.SCREEN_HEIGHT/5)
        self.audioExplainView.addSubview(audioView!)
        super.createTranslateButton(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
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
        DatabaseManager().loadExplainPart1(Constants.databaseName, bookID: Constants.bookID!, testID: Constants.testID!, questionID: (questionData?.questionID)!) { (state, datas) in
                self.explainPart1 = datas as? Explain1Model
                self.explainPart1?.question.answer = self.questionData?.answer
                self.explainPart1?.question.number = self.questionData?.number
        }
    
    }
    
    
    
    func settingTable() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "imageCell")
        self.tableView.registerNib(UINib(nibName: "PassageCell", bundle: nil), forCellReuseIdentifier: "passageCell")
        self.tableView.registerNib(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "questionCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 130
        self.tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return Constants.SCREEN_HEIGHT*4/5 - 40
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("imageCell") as! ImageCell
            cell.part1Image.image = UIImage(named: (explainPart1?.imageName)!)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("questionCell") as! QuestionCell
            cell.initWithData((explainPart1?.question)!)
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("questionCell") as! QuestionCell
            return cell
        }
    }

}
