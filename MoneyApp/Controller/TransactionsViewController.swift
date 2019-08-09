//
//  TransactionsTableViewController.swift
//  MoneyApp
//
//  Created by Orackle on 01/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit

class TransactionsViewController: UITableViewController {
    
    var selectedWallet: Wallet? {
        didSet {
            transactionDates = selectedWallet!.transactionDates
        }
    }
    let dateFormatter = DateFormatter()
    let sectionDateFormatter = DateFormatter()
    var stateController: StateController!
    var transactionDates = [Date]()
    @IBOutlet weak var walletBarCollection: UICollectionView!
    
    @IBAction func setDateInterval(_ sender: UIBarButtonItem) {

        guard let wallet = selectedWallet else {
            return
        }
        var startDate = wallet.getRandomDate()
        var endDate = wallet.getRandomDate()
        
        if endDate < startDate {
            let new = endDate
            endDate = startDate
            startDate = new
        }
       
        let dateInterval = DateInterval(start: startDate, end: endDate)
          print(dateInterval)
        transactionDates = wallet.getTransactionBy(dateInterval: dateInterval)
        print(transactionDates.count)
        tableView.reloadData()
    }
    
    
    @IBAction func resetDateInterval(_ sender: UIBarButtonItem) {
        transactionDates = selectedWallet!.transactionDates
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        tableView.tableFooterView = UIView()
        walletBarCollection.remembersLastFocusedIndexPath = true
        dateFormatter.dateFormat = "MMM d"
        sectionDateFormatter.dateFormat = "MMMM d"
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedWallet = stateController.getSelectedWallet()
        walletBarCollection.reloadData()
        
        if selectedWallet == nil {
            tableView.reloadData()
            tableView.setEmptyView(title: "You don't have any wallets", message: "Add some wallets, please")
        }
        else {
            tableView.restore()
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
        } else if transactionDates.count == 0 {
            tableView.setEmptyView(title: "You don't have any transactions for this date", message: "📅")
        }
        else {
            tableView.restore()
        }
        return transactionDates.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.backgroundView?.backgroundColor = #colorLiteral(red: 0.9375644922, green: 0.9369382262, blue: 0.9586723447, alpha: 1)
//        let blurEffect = UIBlurEffect(style: .extraLight)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        headerView.backgroundView = blurView
    }
    
   
    
    // Gets appropriate date by sectionIndex
    func getDateBySectionNumber (_ sectionIndex: Int) -> Date {
        return transactionDates[sectionIndex]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumberOfRows(for: section)
    }
    
    // Returns number of rows for section.
    // Returns "0" if the section is empty.
    // Returns "0" if there are no wallets.
    
    func getNumberOfRows (for section: Int) -> Int {
        guard let wallet = selectedWallet else {
            return 0
        }
        if section > transactionDates.count - 1 {
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
            
            let dateBySection = transactionDates[indexPath.section]
            
            // Remove transaction by "dateBySection" with index
            
            wallet.removeTransaction(by: dateBySection, with: indexPath.row)
            
            // Get number of rows for section after deleting the transaction. If said section has "0" rows - delete section completely and remove Date from transactionDates
            // Else just delete the row
            
            let numberOfRows = getNumberOfRows(for: indexPath.section)
            if numberOfRows == 0 {
                wallet.transactionDates.remove(at: wallet.transactionDates.firstIndex(of: dateBySection)!)
                transactionDates.remove(at: transactionDates.firstIndex(of: dateBySection)!)
                tableView.deleteSections([indexPath.section], with: .fade)
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            tableView.endUpdates()
            
        }
    }
    
    
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
    
    func configureWalletBarItems (for cell: WalletBarViewCell, with item: Wallet) {
        
        if item.isSelected {
            cell.backgroundColor = item.color
        } else {
            cell.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        
    }
///////////////////////////////////////////////////////////////////
// Chooses appropriate segue when user taps buttons or cells
///////////////////////////////////////////////////////////////////
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let destination = segue.destination as? TransactionDetailViewController {
                destination.wallet = selectedWallet
            }
        }
        
        if segue.identifier == "allWalletsSegue" {
            if let destination = segue.destination as? WalletListViewController {
                destination.stateController = stateController
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
                        destination.wallet = wallet
                        destination.title = "Edit Transaction"
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


///////////////////////////////////////////////////////////////////
// WalletBar CollectionView Delegate and DataSource methods
/////////////////////////////////////////////////////////////////
extension TransactionsViewController: UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        stateController.setSelectedWallet(index: indexPath.row)
        selectedWallet = stateController.getSelectedWallet()
        self.tableView.reloadData()
        walletBarCollection.reloadData()
    }
}

extension TransactionsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stateController.listOfAllWallets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "walletBarCollectionCell", for: indexPath)
        
        
        if let cell = cell as? WalletBarViewCell {
            cell.walletName.text = stateController.listOfAllWallets[indexPath.row].name
            let item = stateController.listOfAllWallets[indexPath.row]
            configureWalletBarItems(for: cell, with: item)
        }
        return cell
    }
}


///////////////////////////////////////////////////////////////////
// Handling empty wallet and empty transaction list
///////////////////////////////////////////////////////////////////

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


