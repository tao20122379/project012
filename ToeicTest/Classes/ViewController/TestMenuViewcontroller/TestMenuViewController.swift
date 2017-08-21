//
//  TestMenuViewController.swift
//  ToeicTest
//
//  Created by khactao on 2/28/17.
//
//

import UIKit
import MZFormSheetPresentationController
import GoogleMobileAds

class TestMenuViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, ListTest_Delegate{
    
    // MARK: - IBOuleft and variable
    @IBOutlet weak var bookCollectionView: UICollectionView!
    var formSheetController: MZFormSheetPresentationViewController?
    var books = Array<BookModel>()
    @IBOutlet weak var banderView: GADBannerView!

    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        bookCollectionView.delegate = self
        bookCollectionView.dataSource = self
        bookCollectionView.registerNib(UINib(nibName: "BookCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "bookCell")
        let request = GADRequest()
        //request.testDevices = [kGADSimulatorID]
        banderView.adUnitID = "ca-app-pub-8928391130390155/4875730823"
        banderView.rootViewController = self
        banderView.loadRequest(request)

    }
    
       
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Constants.LANGTEXT("COMMON_BOOK")
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.colorFromHexString("2BA8E5")
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.setNavigationBarHidden(false, animated: true)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Collection
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let book = books[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("bookCell", forIndexPath: indexPath) as! BookCollectionViewCell
        cell.bookNameLabel.text = book.name
        cell.bookImageView.image = UIImage(named: book.bookImage!)
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: Constants.SCREEN_WIDTH/7-8, height: Constants.SCREEN_WIDTH*5/21-5);
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //MZFormSheetPresentationController.appearance().shouldApplyBackgroundBlurEffect = true
        let bookModel = books[indexPath.row]
        let listTestVC = ListTestViewController(nibName: "ListTestViewController", bundle: nil)
        listTestVC.bookData = bookModel
        Constants.bookID = bookModel.id
        listTestVC.delegate = self
        let navigationController = UINavigationController(rootViewController: listTestVC)
        navigationController.navigationBar.barTintColor = UIColor.blueColor()
        formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController!.presentationController!.landscapeTopInset = Constants.SCREEN_HEIGHT*1/6
        formSheetController!.presentationController?.contentViewSize = CGSizeMake(Constants.SCREEN_WIDTH*3/4, Constants.SCREEN_HEIGHT*3/4)
        formSheetController!.allowDismissByPanningPresentedView = true
        formSheetController!.presentationController!.shouldDismissOnBackgroundViewTap = true
        formSheetController!.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.Bounce
        self.presentViewController(formSheetController!, animated: true, completion: nil)
    }
    
    // MARK: - function
    func loadData() {
        DatabaseManager().loadBookData("toeic_test") { (state, datas) in
            if state == true {
                self.books = (datas as? Array<BookModel>)!
            }
        }
    }
    
    // MARK: - Delegate
    func ListTest_Selected(book: BookModel, testID: Int) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let testVC = TestViewController(nibName: "TestViewController", bundle: nil)
        testVC.bookName = book.name
        Constants.bookData = book
        Constants.testID = testID + 1
        self.navigationController?.pushViewController(testVC, animated: true)
    }



}
