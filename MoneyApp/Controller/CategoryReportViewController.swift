//
//  CategoryReportViewController.swift
//  MoneyApp
//
//  Created by Orackle on 15.10.2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class CategoryReportViewController: UIViewController {

    var category: Category?
    var transactions: [Transaction]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CategoryReportViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let transactions = transactions else {
            return 0
        }
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportsCell", for: indexPath)
        
        if let cell = cell as? ReportsCell {
            cell.periodNameLabel.text = category!.name
            cell.amountLabel.text = transactions![indexPath.row].amount.description
            
            if let icon = cell.iconView as? IconView {
                icon.setGradeintForCategory(category: category!)
                icon.setNeedsDisplay()
            }
        }
        
        
        
        return cell
    }
    
    
}
