//
//  ItemCell.swift
//  EatBeforeExpiry
//
//  Created by Nurşah ARİ on 18.12.2023.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var expiryDate: PaddingLabel!
    @IBOutlet weak var category: PaddingLabel!

    var selectItemCallback: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static let identifier = "ItemCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ItemCell", bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    @IBAction func selectItem(_ sender: Any) {
//        self.selectItemCallback?()
//    }
    
}
