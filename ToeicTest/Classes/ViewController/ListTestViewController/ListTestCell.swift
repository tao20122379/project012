//
//  ListTestCell.swift
//  ToeicTest
//
//  Created by khactao on 3/27/17.
//
//
import UIKit

class ListTestCell: UICollectionViewCell {
    
    // MARK: - IBOutleft
    @IBOutlet weak var testName: UILabel!
    @IBOutlet weak var testImage: UIImageView!

    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        testImage.layer.cornerRadius = Constants.SCREEN_WIDTH/18
        testImage.layer.borderWidth = 0.5
        testImage.layer.borderColor = UIColor.lightGray.cgColor
        testImage.layer.masksToBounds = true
    }
    
}
