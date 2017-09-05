//
//  GrammarViewController.swift
//  ToeicTest
//
//  Created by khactao on 4/29/17.
//
//

import UIKit

class GrammarViewController: BaseViewController {

    // MARK: - IBOutlet and variable
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    var grammas = Array<GrammarSection>()

    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.LANGTEXT("GRAMMAR_TITLE")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.colorFromHexString("2BA8E5")
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        loadData()
        settingTable()
    }
    
    override func viewDidLayoutSubviews() {
        self.textView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Funcion
    func settingTable() {
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.register(UINib(nibName: "GrammarMenuCell", bundle: nil), forCellReuseIdentifier: "menuCell")
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
}

extension GrammarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! GrammarMenuCell
        let grammarModel =  self.grammas[indexPath.section].listModel[indexPath.row]
        cell.settitle(grammarModel.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let grammarModel =  self.grammas[indexPath.section].listModel[indexPath.row]
        textView.text = grammarModel.content
        textView.scrollRangeToVisible(NSRange(location: 0, length: 10))
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("GrammarHeaderView", owner: self, options: nil)?.first as! GrammarHeaderView
        let sectionModel: GrammarSection = self.grammas[section]
        header.titleLabel.text = sectionModel.title
        return header
    }
}

extension GrammarViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.grammas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionModel: GrammarSection = self.grammas[section]
        return sectionModel.listModel.count
    }

}
