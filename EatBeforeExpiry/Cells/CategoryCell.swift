//
//  CategoryCell.swift
//  EatBeforeExpiry
//
//  Created by Nurşah ARİ on 16.12.2023.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var categoryImg: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static let identifier = "CategoryCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CategoryCell", bundle: nil)
    }
}
