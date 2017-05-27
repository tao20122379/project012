//
//  ScoreToeicViewController.swift
//  ToeicTest
//
//  Created by khactao on 4/24/17.
//
//

import UIKit

class ScoreToeicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var scoreTableView: UITableView!
    var listScoreData = Array<ScoreModel>()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        scoreTableView.delegate = self
        scoreTableView.dataSource = self
        scoreTableView.rowHeight = 25
        scoreTableView.registerNib(UINib(nibName: "ScoreTableCell", bundle: nil), forCellReuseIdentifier: "scoreTableCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadData() {
        DatabaseManager().loadScoreData(Constants.databaseName) { (staus, datas) in
            if staus {
                self.listScoreData = datas as! Array<ScoreModel>
            }
        }
    
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listScoreData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("scoreTableCell") as! ScoreTableCell
        cell.initWith(listScoreData[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = NSBundle.mainBundle().loadNibNamed("ScoreHeaderView", owner: self, options: nil).first as! ScoreHeaderView
        return header
    }

}
