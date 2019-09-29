//
//  ReportsChartCell.swift
//  MoneyApp
//
//  Created by Orackle on 29/09/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit
import Charts
class ReportsChartCell: UITableViewCell {

    @IBOutlet weak var lineChartView: LineChartView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
