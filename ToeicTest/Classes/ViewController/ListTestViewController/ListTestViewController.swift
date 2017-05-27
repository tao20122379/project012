//
//  ListTestViewController.swift
//  ToeicTest
//
//  Created by khactao on 3/27/17.
//
//

import UIKit

protocol ListTest_Delegate {
    func ListTest_Selected(book: BookModel, testID: Int)
}

class ListTestViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - IBOuleft and variable
    @IBOutlet weak var bookLabel: UILabel!
    @IBOutlet weak var listTestCollectionView: UICollectionView!
    var delegate: ListTest_Delegate?
    var bookData: BookModel?
    
    // MARK: - life cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        bookLabel.text = (bookData?.name)!
        self.navigationController?.navigationBarHidden = true
        BaseViewController.hours = 0
        BaseViewController.second = 0
        BaseViewController.minute = 45
        
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
        listTestCollectionView.registerNib(UINib(nibName: "ListTestCell", bundle: nil), forCellWithReuseIdentifier: "listTestCell")
    }

    // MARK: - CollectionView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (bookData?.testNumber)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("listTestCell", forIndexPath: indexPath) as! ListTestCell
        cell.testName.text = String(format: "Test%i", indexPath.row+1)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: Constants.SCREEN_WIDTH/9, height: Constants.SCREEN_WIDTH/9);
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.ListTest_Selected(self.bookData!, testID: indexPath.row)
    }

}
