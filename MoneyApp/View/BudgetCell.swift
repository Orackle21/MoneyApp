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
    }


    func configureCell (with budget: Budget, spent: NSDecimalNumber) {
        
        let amount = budget.amount ?? 0
        let spent = spent
        var left = amount - spent
        
        if left < 0 {
            left = 0
        }
        
        let currencySymbol = budget.wallet?.currency?.symbol ?? budget.wallet?.currency?.id
        
        categoryIcon.drawIcon(skin: budget.category?.skin)
        categoryName.text = budget.category?.name
        amountLabel.text = currencySymbol! + " " + budget.amount!.description
        
        spentLabel.text =  "Spent: " + currencySymbol! + " " + spent.description
        leftLabel.text = "Left: " + currencySymbol! + " " + left.description
        
        
        progressBar.progress = CGFloat(truncating: spent / amount)
    }
}
