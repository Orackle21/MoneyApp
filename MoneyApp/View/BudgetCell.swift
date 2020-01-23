//
//  BudgetCell.swift
//  MoneyApp
//
//  Created by Orackle on 23.01.2020.
//  Copyright © 2020 Orackle. All rights reserved.
//

import UIKit
import GTProgressBar

class BudgetCell: UITableViewCell {

    @IBOutlet weak var categoryIcon: IconView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var spentLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var progressBar: GTProgressBar!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell (with budget: Budget) {
        categoryIcon.drawIcon(skin: budget.category?.skin)
        categoryName.text = budget.category?.name
        amountLabel.text = budget.amount?.description
        
        progressBar.progress = 0.5
    }
}
