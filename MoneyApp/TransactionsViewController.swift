//
//  TransactionsTableViewController.swift
//  MoneyApp
//
//  Created by Orackle on 01/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class TransactionsViewController: UITableViewController {
    
    var myWallet = Wallet()
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let transactionTest0 = Transaction(name: "Burger", subtitle: " ", amount: 55, category: .Food, date: currentDate)
        let transactionTest1 = Transaction(name: "Internet", subtitle: " ", amount: 115, category: .Internet, date: currentDate)
        let transactionTest2 = Transaction(name: "Electricity", subtitle: " ", amount: 125, category: .Utilities, date: currentDate)
        
        myWallet.allTransactions.append(contentsOf: [transactionTest0, transactionTest1, transactionTest2])
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        tableView.reloadData()
        
        dateFormatter.dateFormat = "MMM d"
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return getTotalDate()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myWallet.allTransactions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTransaction", for: indexPath)
        
        let item = myWallet.allTransactions[indexPath.row]
        configureLabels(for: cell, with: item)
       // tableView.reloadData()

        return cell
    }
    
    func configureLabels(for cell: UITableViewCell, with item: Transaction) {
        if let transactionCell = cell as? TransactionCell {
            transactionCell.categoryLabel.text = item.category.rawValue
            transactionCell.nameLabel.text = item.name
            transactionCell.amountLabel.text = String(item.amount)
            transactionCell.dateLabel.text = dateFormatter.string(from: currentDate)
            
        }
    }
    

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dateFormatter.string(from: currentDate)
    }
        
    
    
    func getTotalDate() -> Int{
        // choose the month and year you want to look
        var dateComponents = DateComponents()
        dateComponents.year = 2019
        dateComponents.month = 7
        
        let calendar = Calendar.current
        let datez = calendar.date(from: dateComponents)
        // change .month into .year to see the days available in the year
        let interval = calendar.dateInterval(of: .month, for: datez!)!
        
        let days = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        return days
    }

    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myWallet.allTransactions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
//    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//    }
    

   
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let destination = segue.destination as? TransactionDetailViewController {
                destination.delegate = self
                destination.wallet = myWallet
            }
        }
    }
    

}

extension TransactionsViewController: TransactionDetailViewControllerDelegate {
    func transactionDetailViewController(_ controller: TransactionDetailViewController) {
        return
    }
    
    func transactionDetailViewController(_ controller: TransactionDetailViewController, didFinishAdding item: Transaction) {
        navigationController?.popViewController(animated: true)
        let rowIndex = myWallet.allTransactions.count - 1
        let indexPath = IndexPath(row: rowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func transactionDetailViewController(_ controller: TransactionDetailViewController, didFinishEditing item: Transaction) {
        if let index = myWallet.allTransactions.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureLabels(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}
    
    

