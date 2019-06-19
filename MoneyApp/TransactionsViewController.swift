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
    let sectionDateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        tableView.reloadData()
        
        dateFormatter.dateFormat = "MMM d"
        sectionDateFormatter.dateFormat = "MMMM d"
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return myWallet.allTransactionGrouped.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionDates = [Date] (myWallet.allTransactionGrouped.keys)
        let numberOfRowsInTheSectionByDate = myWallet.allTransactionGrouped[sectionDates[section]]?.count
        return numberOfRowsInTheSectionByDate!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTransaction", for: indexPath)
        var sectionDates = [Date] (myWallet.allTransactionGrouped.keys)
        let arrayInTheSectionByDate = myWallet.allTransactionGrouped[sectionDates[indexPath.section]]
        
        let item = arrayInTheSectionByDate![indexPath.row]
        configureLabels(for: cell, with: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       
        let sectionDates = [Date] (myWallet.allTransactionGrouped.keys)
        let dateStringHeader = sectionDates[section]
        return sectionDateFormatter.string(from: dateStringHeader)
        
    }
    
    func configureLabels(for cell: UITableViewCell, with item: Transaction) {
        if let transactionCell = cell as? TransactionCell {
            transactionCell.categoryLabel.text = item.category.rawValue
            transactionCell.nameLabel.text = item.name
            transactionCell.amountLabel.text = String(item.amount)
            transactionCell.dateLabel.text = dateFormatter.string(from: item.date)
            
        }
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
    func transactionDetailViewControllerDidCancel(_ controller: TransactionDetailViewController) {
        navigationController?.popViewController(animated: true)
        return
    }
    
    func transactionDetailViewController(_ controller: TransactionDetailViewController, didFinishAdding item: Transaction) {
        navigationController?.popViewController(animated: true)
//        let rowIndex = myWallet.allTransactions.count - 1
//        let indexPath = IndexPath(row: rowIndex, section: 0)
//        let indexPaths = [indexPath]
//        tableView.insertRows(at: indexPaths, with: .automatic)
        tableView.reloadData()
    }
    
    func transactionDetailViewController(_ controller: TransactionDetailViewController, didFinishEditing item: Transaction) {
//        if let index = myWallet.allTransactions.firstIndex(of: item) {
//            let indexPath = IndexPath(row: index, section: 0)
//            if let cell = tableView.cellForRow(at: indexPath) {
//                configureLabels(for: cell, with: item)
//            }
//        }
//        navigationController?.popViewController(animated: true)
    }
}
    
    

