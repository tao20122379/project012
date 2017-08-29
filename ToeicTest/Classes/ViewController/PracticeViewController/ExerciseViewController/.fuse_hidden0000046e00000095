//
//  ExerciseViewController.swift
//  ToeicTest
//
//  Created by khactao on 8/27/17.
//
//

import UIKit
import YLProgressBar
enum PartSelect {
    case part1
    case part2
    case part3
    case part4
}

class ExerciseViewController: UIViewController {

    //MARK: - IBOutleft and variable
    @IBOutlet weak var audioView: UIView!
    var audioViewLoad: UIView?
    @IBOutlet weak var progress: YLProgressBar!
    @IBOutlet weak var tableView: UITableView!
    var partSelect: PartSelect = .part1
    
    //MARK: - Cycle life
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        audioViewLoad = NSBundle.mainBundle().loadNibNamed("AudioExplainView", owner: self, options: nil).first as? AudioExplainView
        audioViewLoad!.frame = CGRect(x: 0, y: 0, width: audioView.frame.size.width, height: audioView.frame.size.height)
        audioViewLoad?.layer.borderWidth = 0
        audioView.addSubview(audioViewLoad!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configProgeress()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "Part1QuestionCell", bundle: nil), forCellReuseIdentifier: "imageCell")
        tableView.registerNib(UINib(nibName: "PassageCell", bundle: nil), forCellReuseIdentifier: "passageCell")
        tableView.registerNib(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "questionCell")
        tableView.registerNib(UINib(nibName: "Part3v4CellQuestion", bundle: nil), forCellReuseIdentifier: "questionCell1")
        tableView.registerNib(UINib(nibName: "Part3v4CellQuestion", bundle: nil), forCellReuseIdentifier: "questionCell2")
        tableView.registerNib(UINib(nibName: "Part3v4CellQuestion", bundle: nil), forCellReuseIdentifier: "questionCell3")
        loadDataPart1()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadDataPart1() {
        DatabaseManager().loadPart1Data("toeic_test", bookID:1, testID: 1) { (status, datas) in
            if status == true {
                Constants.questionPar1List = datas as! Array<Part1Model>
            }
        }
    }
    
    func configProgeress() {
        let tincolors: NSArray = [UIColor.colorFromHexString("00D800")]
        progress.progressTintColors       = tincolors as [AnyObject]
        progress.type                     = .Flat
        progress.indicatorTextDisplayMode = .None
        progress.indicatorTextLabel.textColor = UIColor.blueColor()
        progress.behavior                 = .Indeterminate
        progress.stripesOrientation       = .Vertical
        progress.layer.cornerRadius = 9
        progress.layer.masksToBounds = true
        progress.layer.borderWidth = 1.5
        progress.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    @IBAction func nextSelected(sender: AnyObject) {
        tableView.reloadData()
    }
    
}

//MARK: - Tableview Datasource
extension ExerciseViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch partSelect {
        case .part1:
            return 2
        case .part2:
            return 1
        case .part3:
            return 4
        case .part4:
            return 4
        }
    }
}

//MARK: - TableView Delegate
extension ExerciseViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        switch partSelect {
        case .part1:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("imageCell") as! Part1QuestionCell
                let questionData = Constants.questionPar1List[indexPath.row]
                questionData.number = indexPath.row + 1
                cell.isExercise = true
                cell.delegate = self
                cell.questionNumber.text = ""
  
                if questionData.answerSelected == 0 {
                    cell.refresh()
                }
                cell.initWithData(questionData)
                cell.numberQuestion = indexPath.row
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier("questionCell") as! QuestionCell
                return cell
            }

        case .part2:
            let cell = tableView.dequeueReusableCellWithIdentifier("questionCell1")
            return cell!
        case .part3:
            if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCellWithIdentifier("passageCell")
                return cell!
            }
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier(String(format: "questionCell%i", indexPath.row + 1))
                return cell!
            }
        case .part4:
            if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCellWithIdentifier("passageCell")
                return cell!
            }
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier(String(format: "questionCell%i", indexPath.row + 1))
                return cell!
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if partSelect == .part1 && indexPath.row == 0 {
            return Constants.SCREEN_WIDTH*6/11
        }
        return UITableViewAutomaticDimension
    }
}

extension ExerciseViewController: Part1Question_Delegate {
    func explainQuestion(questionData: Part1Model) {
        let explainVC = ExplainPart1ViewController(nibName: "ExplainPart1ViewController", bundle: nil)
        explainVC.questionData = questionData
        self.navigationController?.pushViewController(explainVC, animated: true)
    }
}
