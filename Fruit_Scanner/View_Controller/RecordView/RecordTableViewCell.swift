//
//  RecordTableViewCell.swift
//  Fruit_Scanner
//
//  Created by kin ming ching on 14/4/2022.
//

import UIKit

class RecordTableViewCell: UITableViewCell {
    @IBOutlet weak var RecordImageView: UIImageView!
    @IBOutlet weak var RecordFruitNameLBL: UILabel!
    @IBOutlet weak var RecordDateLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
