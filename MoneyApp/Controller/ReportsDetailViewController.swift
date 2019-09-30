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
    
    @IBOutlet weak var chartContainer: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
    }
    
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
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return transactionsGroupedByCategories.keys.count

        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier: String
        
        if indexPath.section == 0 {
            cellIdentifier = "detailReportCell"
        }
        else {
            cellIdentifier = "reportsCell"

        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if let cell = cell as? ReportsDetailCell {
            cell.incomeIcon.backgroundColor = UIColor.systemGreen
            cell.expenseIcon.backgroundColor = UIColor.systemRed
            
        }
        
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

extension ReportsDetailViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 55.0
//    }
//
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 22.0
    }
}
