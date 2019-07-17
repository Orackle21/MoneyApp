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
     private let reuseIdentifier = ""
    @IBOutlet weak var walletBarCollection: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        tableView.tableFooterView = UIView()

        dateFormatter.dateFormat = "MMM d"
        sectionDateFormatter.dateFormat = "MMMM d"
        
        WalletList.shared.addNewWallet(name: "wallet"
            , balance: 500, currency: CurrencyList.shared.everyCurrencyList[1])
        selectedWallet =  WalletList.shared.listOfAllWallets[0]
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        walletBarCollection.reloadData()
        selectedWallet = WalletList.shared.getSelectedWallet()
        if selectedWallet == nil {
            tableView.reloadData()
            tableView.setEmptyView(title: "You don't have any wallets", message: "Add some wallets, please")
            walletNameLabel.text = " "
        }
        
        else {
            tableView.restore()
         //   walletNameLabel.text = selectedWallet?.name
            tableView.reloadData()
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let wallet = selectedWallet else {
            return 0
        }
        // Shows a message if there are no sections
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
    
    
    
    // Sets header title for section using "sectionDateFormatter"
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
            
            selectedWallet!.removeTransaction(by: dateBySection, with: indexPath.row)
            
            // Get number of rows for section after deleting the transaction. If said section has "0" rows - delete section completely and remove Date from transactionDates
            // Else just delete the row
            
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
        if let cell = cell as? TransactionCell {
            cell.categoryLabel.text = item.category.name
            cell.nameLabel.text = item.name
            
            if item.amount > 0 {
               cell.amountLabel.text = item.currency.currencyCode! + " " + String(item.amount)
                cell.amountLabel.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            } else {
                cell.amountLabel.text = item.currency.currencyCode! + " " + String(item.amount)
                cell.amountLabel.textColor = #colorLiteral(red: 0.9203510284, green: 0.1116499379, blue: 0.1756132543, alpha: 1)
            }
            
            cell.dateLabel.text = dateFormatter.string(from: item.date)
            
            
            if let icon = cell.categoryIcon as? IconView {
                icon.setGradeintForCategory(category: item.category)
                icon.setNeedsDisplay()
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
    }
    
    func transactionDetailViewController(_ controller: TransactionDetailViewController, didFinishEditing item: Transaction) {
        navigationController?.popViewController(animated: true)
        tableView.reloadData()
    }
}

extension TransactionsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedWallet = WalletList.shared.listOfAllWallets[indexPath.row]
        self.tableView.reloadData()
    }
}

extension TransactionsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WalletList.shared.listOfAllWallets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "walletBarCollectionCell", for: indexPath)
        
        
        if let cell = cell as? WalletBarViewCell {
            cell.walletName.text = WalletList.shared.listOfAllWallets[indexPath.row].name
        }
        return cell
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


