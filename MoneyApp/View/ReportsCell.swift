//
//  ReportsCell.swift
//  MoneyApp
//
//  Created by Orackle on 26/09/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class ReportsCell: UITableViewCell {
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var periodNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
