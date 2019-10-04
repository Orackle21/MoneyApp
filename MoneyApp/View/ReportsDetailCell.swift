//
//  ReportsChartCell.swift
//  MoneyApp
//
//  Created by Orackle on 29/09/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit
import Charts
class ReportsDetailCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var incomeIcon: IconView!
    @IBOutlet weak var expenseIcon: IconView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
