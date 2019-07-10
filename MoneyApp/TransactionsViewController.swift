//
//  TransactionsTableViewController.swift
//  MoneyApp
//
//  Created by Orackle on 01/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class TransactionsViewController: UITableViewController {
    
    var selectedWallet: Wallet?
    let dateFormatter = DateFormatter()
    let sectionDateFormatter = DateFormatter()
    @IBOutlet weak var walletNameLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        tableView.tableFooterView = UIView()
//        tableView.estimatedRowHeight = 0
//        tableView.estimatedSectionFooterHeight = 0
//        tableView.estimatedSectionHeaderHeight = 0
      
        selectedWallet = WalletList.list.getSelectedWallet()
        dateFormatter.dateFormat = "MMM d"
        sectionDateFormatter.dateFormat = "MMMM d"
        //tableView.beginUpdates()
      //  tableView.endUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectedWallet = WalletList.list.getSelectedWallet()
        
        if selectedWallet == nil {
            tableView.reloadData()
            tableView.setEmptyView(title: "You don't have any wallets", message: "Add some wallets, please")
            walletNameLabel.text = " "
        }
        
        else {
            tableView.restore()
            walletNameLabel.text = selectedWallet?.name
            tableView.reloadData()
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let wallet = selectedWallet else {
            return 0
        }
        // Shows a message if there a no sections
        if wallet.allTransactionsGrouped.keys.count == 0 {
            tableView.setEmptyView(title: "You don't have any transactions", message: "Add some transactions, please")
        } else {
            tableView.restore()
        }
        
        return wallet.allTransactionsGrouped.keys.count
    }
    
    // Gets appropriate date by sectionIndex
    func getDateBySectionNumber (_ sectionIndex: Int) -> Date {
        return selectedWallet!.transactionDates[sectionIndex]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumberOfRows(for: section)
    }
    
    // Returns number of rows for section. Returns "0" if section is empty. Returns "0" if there are no wallets.
    func getNumberOfRows (for section: Int) -> Int {
        guard let wallet = selectedWallet else {
            return 0
        }
        if section > wallet.transactionDates.count - 1 {
            return 0
        }
        else {
            let date = getDateBySectionNumber(section)
            let numberOfTransactionsByDate = wallet.allTransactionsGrouped[date]?.count
            return numberOfTransactionsByDate ?? 0
        }
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 49
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTransaction", for: indexPath)
        
        let date = getDateBySectionNumber(indexPath.section)
        guard let wallet = selectedWallet else {
            return cell
        }
        if let cell = cell as? TransactionCell {
            if let transactionsByDate = wallet.allTransactionsGrouped[date] {
                let item = transactionsByDate[indexPath.row]
                configureLabels(for: cell, with: item)
            }
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
            
            tableView.beginUpdates()
            
            guard let wallet = selectedWallet else {
                return
            }
            
            let dateBySection = wallet.transactionDates[indexPath.section]
            
            // Remove transaction by "dateBySection" with index
            
            self.selectedWallet!.removeTransaction(by: dateBySection, with: indexPath.row)
            
            // Get number of rows for section after deleting the transaction. If said section has "0" rows - delete section completely and remove Date from transactionDates to sync model and view.
            // Else just delete the row from tableView
            
            let numberOfRows = getNumberOfRows(for: indexPath.section)
            if numberOfRows == 0 {
                selectedWallet!.transactionDates.remove(at: selectedWallet!.transactionDates.firstIndex(of: dateBySection)!)
                tableView.deleteSections([indexPath.section], with: .fade)
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            tableView.endUpdates()
            
        }
    }
    
    
    
    //    // Override to support rearranging the table view.
    //    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    //
    //    }
    
    
    // Configures cell's labels for passed item
    func configureLabels(for cell: UITableViewCell, with item: Transaction) {
        if let transactionCell = cell as? TransactionCell {
            transactionCell.categoryLabel.text = item.category.name
            transactionCell.nameLabel.text = item.name
            transactionCell.amountLabel.text = String(item.amount)
            transactionCell.dateLabel.text = dateFormatter.string(from: item.date)
            
            if let icon = transactionCell.categoryIcon as? IconView {
                icon.setGradeintForCategory(category: item.category)
            }
           
        }
    }
    
    // Chooses appropriate segue when user taps buttons or cells
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let destination = segue.destination as? TransactionDetailViewController {
                destination.delegate = self
                destination.wallet = selectedWallet
            }
        }
        
        if segue.identifier == "editItemSegue" {
            if let destination = segue.destination as? TransactionDetailViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    
                    let date = getDateBySectionNumber(indexPath.section)
                    let index = indexPath.row
                    guard let wallet = selectedWallet else {
                        return
                    }
                    if let arrayByDate = wallet.allTransactionsGrouped[date] {
                        destination.transactionToEdit = arrayByDate[index]
                        destination.wallet = selectedWallet
                        destination.title = "Edit Transaction"
                        destination.delegate = self
                    }
                }
            }
        }
    }
    
    @IBAction func unwindBack(_ unwindSegue: UIStoryboardSegue) {
        if let walletList = unwindSegue.source as? WalletListViewController {
            if let wallet = walletList.selectedWallet {
                selectedWallet = wallet
                walletNameLabel.text = selectedWallet?.name
                tableView.reloadData()
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

extension UITableView {
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}


