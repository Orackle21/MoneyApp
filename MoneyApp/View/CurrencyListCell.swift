//
//  CurrencyListCell.swift
//  MoneyApp
//
//  Created by Orackle on 10/07/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class CurrencyListCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
