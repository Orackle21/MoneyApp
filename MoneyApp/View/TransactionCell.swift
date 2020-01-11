//
//  TransactionTableViewCell.swift
//  MoneyApp
//
//  Created by Orackle on 09/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var categoryIcon: IconView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var iconImage: UIImageView!
    
    
    func configureCell(with transaction: Transaction) {
        
        categoryLabel.text = transaction.category?.name
        noteLabel.text = transaction.note
        amountLabel.text = (transaction.currency!.symbol ?? transaction.currency!.id) + " " + transaction.amount!.description
        Int(truncating: transaction.amount!) > 0 ? (amountLabel.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)) : (amountLabel.textColor = #colorLiteral(red: 0.9203510284, green: 0.1116499379, blue: 0.1756132543, alpha: 1))
        
        dateLabel.text = transaction.dateCreated!.description(with: Locale(identifier: "ru"))
        
        
        if let icon = categoryIcon {
            icon.drawIcon(skin: transaction.category?.skin)
            
        }
    }
    
}
