//
//  BookCollectionViewCell.swift
//  ToeicTest
//
//  Created by khactao on 2/28/17.
//
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutleft and variable
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookNameLabel: UILabel!
    
    // MARK: - Cyccle life
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bookImageView.layer.masksToBounds = true
        self.bookImageView.layer.borderWidth = 1
        self.bookImageView.layer.borderColor = UIColor.lightGray.cgColor
    }
}
