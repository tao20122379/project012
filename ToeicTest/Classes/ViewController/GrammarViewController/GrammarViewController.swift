//
//  GrammarViewController.swift
//  ToeicTest
//
//  Created by khactao on 4/29/17.
//
//

import UIKit

class GrammarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - IBOutleft and variable
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    var grammas = Array<GrammarSection>()

    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.LANGTEXT("GRAMMAR_TITLE")
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.colorFromHexString("2BA8E5")
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        loadData()
        settingTable()
    }
    
    override func viewDidLayoutSubviews() {
        self.textView.setContentOffset(CGPointZero, animated: false)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Funcion
    func settingTable() {
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.registerNib(UINib(nibName: "GrammarMenuCell", bundle: nil), forCellReuseIdentifier: "menuCell")
        menuTableView.rowHeight = UITableViewAutomaticDimension
        menuTableView.estimatedRowHeight = 40
        menuTableView.sectionHeaderHeight = UITableViewAutomaticDimension
        menuTableView.estimatedSectionHeaderHeight = 40
        textView.scrollRangeToVisible(NSRange(location: 0, length: 10))
    }

    func loadData() {
        DatabaseManager().loadGrammarSection(Constants.databaseName) { (status, datas) in
            if status {
                self.grammas = datas as!  Array<GrammarSection>
            }
        }
        let grammarModel =  self.grammas[0].listModel[0]
        textView.text = grammarModel.content
        textView.scrollRangeToVisible(NSRange(location: 0, length: 10))
    }
    
    // MARK: - TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.grammas.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionModel: GrammarSection = self.grammas[section]
        return sectionModel.listModel.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell") as! GrammarMenuCell
        let grammarModel =  self.grammas[indexPath.section].listModel[indexPath.row]
        cell.settitle(grammarModel.title)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let grammarModel =  self.grammas[indexPath.section].listModel[indexPath.row]
        textView.text = grammarModel.content
        textView.scrollRangeToVisible(NSRange(location: 0, length: 10))
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = NSBundle.mainBundle().loadNibNamed("GrammarHeaderView", owner: self, options: nil).first as! GrammarHeaderView
        let sectionModel: GrammarSection = self.grammas[section]
        header.titleLabel.text = sectionModel.title
        return header
    }


}
