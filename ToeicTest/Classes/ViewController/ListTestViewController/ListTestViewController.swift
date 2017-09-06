//
//  ListTestViewController.swift
//  ToeicTest
//
//  Created by khactao on 3/27/17.
//
//

import UIKit

protocol ListTest_Delegate {
    func ListTest_Selected(_ book: BookModel, testID: Int)
}

class ListTestViewController: BaseViewController {
    
    // MARK: - IBOuleft and variable
    @IBOutlet weak var bookLabel: UILabel!
    @IBOutlet weak var listTestCollectionView: UICollectionView!
    var delegate: ListTest_Delegate?
    var bookData: BookModel?
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bookLabel.text = (bookData?.name)!
        self.navigationController?.isNavigationBarHidden = true
        Constants.hours = 0
        Constants.second = 0
        Constants.minute = 45
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - function
    func customCollectionView() {
        listTestCollectionView.delegate = self
        listTestCollectionView.dataSource = self
        listTestCollectionView.register(UINib(nibName: "ListTestCell", bundle: nil), forCellWithReuseIdentifier: "listTestCell")
    }
  }

// MARK: - Collectionview datasource
extension ListTestViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (bookData?.testNumber)!
    }
}

// MARK: - Collectionview delegate
extension ListTestViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listTestCell", for: indexPath) as! ListTestCell
        cell.testName.text = String(format: "Test%i", indexPath.row+1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if (bookData?.testNumber)! < 5 {
            let totalCellWidth =  Int(Constants.SCREEN_WIDTH/9) * (bookData?.testNumber)!
            let totalSpacingWidth = 20 * ((bookData?.testNumber)! - 1)
            
            let leftInset = (Constants.SCREEN_WIDTH*3/4 - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            let rightInset = leftInset
            
            return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
        }
        else {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.SCREEN_WIDTH/9, height: Constants.SCREEN_WIDTH/9);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.ListTest_Selected(self.bookData!, testID: indexPath.row)
    }
}
