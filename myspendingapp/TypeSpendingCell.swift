//
//  TypeSpendingCell.swift
//  myspendingapp
//
//  Created by GaryLai on 9/12/15.
//  Copyright © 2015 GaryLai. All rights reserved.
//

import UIKit

class TypeSpendingCell: UITableViewCell {

    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftTypeLabel: UILabel!
    @IBOutlet weak var leftValue: UILabel!
    @IBOutlet weak var rightTypeLabel: UILabel!
    @IBOutlet weak var rightValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
