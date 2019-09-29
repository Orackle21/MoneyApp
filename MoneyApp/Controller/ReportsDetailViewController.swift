//
//  ReportsDetailViewController.swift
//  MoneyApp
//
//  Created by Orackle on 28/09/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class ReportsDetailViewController: UIViewController {

    var stateController: StateController!
    var selectedTimeRange: Date!
    var transactionsGroupedByCategories = [Category: [Transaction]]()
    lazy var categories = Array(transactionsGroupedByCategories.keys)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let wallet = stateController.getSelectedWallet() else {
            return
        }
        let dateInterval = stateController.dater.getTimeIntervalFor(date: selectedTimeRange)
        let transactionDates = wallet.getTransactionsBy(dateInterval: dateInterval)
        var transactions = [Transaction]()
        for date in transactionDates {
            guard let transactionsByDate = wallet.allTransactionsGrouped[date] else { return }
            for transaction in transactionsByDate {
                transactions.append(transaction)
            }
        }
        transactionsGroupedByCategories = Dictionary(grouping: transactions, by: {
            $0.category!
        })
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


extension ReportsDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transactionsGroupedByCategories.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportsCell", for: indexPath)
        
            if let cell = cell as? ReportsCell {
                cell.periodNameLabel.text = categories[indexPath.row].name
                
                if let icon = cell.iconView as? IconView {
                    icon.setGradeintForCategory(category: categories[indexPath.row])
                    icon.setNeedsDisplay()
                }
                
        }
        return cell
    }
    
    
}
