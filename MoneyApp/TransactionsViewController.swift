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
    let dateFormatter = DateFormatter()
    let sectionDateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        //tableView.allowsMultipleSelectionDuringEditing = true
        
        dateFormatter.dateFormat = "MMM d"
        sectionDateFormatter.dateFormat = "MMMM d"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return myWallet.allTransactionsGrouped.keys.count
    }
    
    // Gets appropriate date by sectionIndex
    func getDateBySectionNumber (_ sectionIndex: Int) -> Date {
        return myWallet.transactionDates[sectionIndex]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumberOfRows(for: section)
    }
    
    // Returns number of rows for section. Returns "0" if section is empty.
    func getNumberOfRows (for section: Int) -> Int {
        if section > myWallet.transactionDates.count - 1 {
            return 0
        }
        else {
            let date = getDateBySectionNumber(section)
            let numberOfTransactionsByDate = myWallet.allTransactionsGrouped[date]?.count
            return numberOfTransactionsByDate ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTransaction", for: indexPath)
        
        let date = getDateBySectionNumber(indexPath.section)
        if let transactionsByDate = myWallet.allTransactionsGrouped[date] {
            let item = transactionsByDate[indexPath.row]
            configureLabels(for: cell, with: item)
        }
        return cell
    }
    
    
    
    // Sets header title for section using "sectionStringFormatter"
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionDate = getDateBySectionNumber(section)
        return sectionDateFormatter.string(from: sectionDate)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            self.tableView.beginUpdates()
            
            let dateBySection = myWallet.transactionDates[indexPath.section]
            
// Remove transaction by "dateBySection" with index
            
            self.myWallet.removeTransaction(by: dateBySection, with: indexPath.row)
            
// Get number of rows for section after deleting the transaction. If said section has "0" rows - delete section completely and remove Date from transactionDates to sync model and view.
// Else just delete the row from tableView
            
            let numberOfRows = getNumberOfRows(for: indexPath.section)
            if numberOfRows == 0 {
                myWallet.transactionDates.remove(at: myWallet.transactionDates.firstIndex(of: dateBySection)!)
                tableView.deleteSections([indexPath.section], with: .fade)
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            self.tableView.endUpdates()
         
        }
    }
    
    
    
    //    // Override to support rearranging the table view.
    //    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    //
    //    }
    
    // Configures cell's labels for passed item
    func configureLabels(for cell: UITableViewCell, with item: Transaction) {
        if let transactionCell = cell as? TransactionCell {
            transactionCell.categoryLabel.text = item.category.rawValue
            transactionCell.nameLabel.text = item.name
            transactionCell.amountLabel.text = String(item.amount)
            transactionCell.dateLabel.text = dateFormatter.string(from: item.date)
        }
    }
    
    // Chooses appropriate segue when user taps buttons or cells
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let destination = segue.destination as? TransactionDetailViewController {
                destination.delegate = self
                destination.wallet = myWallet
            }
        }
        
        if segue.identifier == "editItemSegue" {
            if let destination = segue.destination as? TransactionDetailViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    
                    let date = getDateBySectionNumber(indexPath.section)
                    let index = indexPath.row
                    if let arrayByDate = myWallet.allTransactionsGrouped[date] {
                        destination.transactionToEdit = arrayByDate[index]
                        destination.wallet = myWallet
                        destination.title = "Edit Transaction"
                        destination.delegate = self
                    }
                    
                    
                }
                
                
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
        tableView.reloadData()
        
        //        let itemDate = item.date
        //        if  let sectionByDate = myWallet.transactionDates.firstIndex(of: itemDate) {
        //            let indexPath = IndexPath(row: 0, section: sectionByDate)
        //            let indexPaths = [indexPath]
        //
        //            tableView.insertRows(at: indexPaths, with: .automatic)
        //        } else {
        //            myWallet.transactionDates.append(itemDate)
        //            myWallet.transactionDates.sort()
        //            if  let sectionByDate = myWallet.transactionDates.firstIndex(of: itemDate) {
        //                tableView.insertSections([sectionByDate], with: .automatic)
        //                let indexPath = IndexPath(row: 0, section: sectionByDate)
        //                let indexPaths = [indexPath]
        //
        //                tableView.insertRows(at: indexPaths, with: .automatic)
        //            }
        //        }
        
    }
    
    func transactionDetailViewController(_ controller: TransactionDetailViewController, didFinishEditing item: Transaction) {
        navigationController?.popViewController(animated: true)
        tableView.reloadData()
    }
}



