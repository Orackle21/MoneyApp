//
//  TransactionsTableViewController.swift
//  MoneyApp
//
//  Created by Orackle on 01/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit
import CoreData

class TransactionsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var walletBar: UICollectionView!
    @IBOutlet weak var dateBar: UICollectionView!
    
    private var actionSheet: UIAlertController?
    @IBAction func changeTimeRange(_ sender: Any) {
        prepareAlert()
        self.present(actionSheet!, animated: true, completion: nil)
    }
    
    var coreDataStack: CoreDataStack!
    lazy var fetchedResultsController: NSFetchedResultsController<Transaction> = getController()
    private var keyPath = #keyPath(Transaction.simpleDate)

    
    var walletContainer: WalletContainer!
    private var wallets = [Wallet]()
    private lazy var selectedWallet: Wallet? = {
        return walletContainer.getSelectedWallet()
    }()
    
    private lazy var dater = Dater()
    private lazy var dateBarItems = dater.calculateDateIntervals()
    private lazy var selectedDateInterval = dateBarItems[0]

    
    
    // FIXME: - Implement cell update through delegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // dateBar preparation
        configureDateBarData()
        selectedDateInterval = dateBarItems[0]
        
        fetchTransactions()
        
        // TableView styling
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UIDevice.current.screenType == .iPhones_5_5s_5c_SE || UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            dateBar.scrollToItem(at: IndexPath(row: 0, section: 0), at: .right, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
           
       // selectedWallet = walletContainer.getSelectedWallet()
        wallets = walletContainer.wallets!.array as! [Wallet]
        walletBar.reloadData()
       
        if selectedWallet == nil {
            tableView.reloadData()
            tableView.setEmptyView(title: "You don't have any wallets", message: "Add some wallets, please")
        }
        else {
            tableView.restore()
        }
    }
    
    
   
    

// MARK: - SEGUE CHOOSER
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let navigationController = segue.destination as? UINavigationController {
                if let destination = navigationController.viewControllers.first as? TransactionDetailViewController {
                    destination.wallet = selectedWallet
                    destination.coreDataStack = coreDataStack
                }
            }
        }
        
        if segue.identifier == "allWalletsSegue" {
            if let destination = segue.destination as? WalletListViewController {
                destination.coreDataStack = coreDataStack!
                destination.walletContainer = walletContainer
            }
        }
        
        if segue.identifier == "editItemSegue" {
            if let navigationController = segue.destination as? UINavigationController {
                if let destination = navigationController.viewControllers.first as? TransactionDetailViewController  {
                    if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                        
                        destination.coreDataStack = coreDataStack
                        destination.wallet = selectedWallet
                        destination.transactionToEdit = fetchedResultsController.object(at: indexPath)
                        destination.title = "Edit Transaction"
                        tableView.deselectRow(at: indexPath, animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func unwindBack(_ unwindSegue: UIStoryboardSegue) {
        if let walletList = unwindSegue.source as? WalletListViewController {
            if let wallet = walletList.walletContainer?.getSelectedWallet() {
                selectedWallet = wallet
                walletBar.reloadData()
                setControllerAndFetch()
            }
            
        }
    }
    
}


//MARK: - TableView Delegate and DataSource methods

extension TransactionsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        let count = fetchedResultsController.sections?.count

        guard selectedWallet != nil else { return 0 }
        if count == 0 {
            tableView.setEmptyView(title: "No transactions for this time period", message: "Add some transactions, please")
        }
        else {
            tableView.restore()
        }
        
        return count ?? 0
    }
    
    
    // FIXME: - use dater to automate this stuff
    // Sets header title for section using "sectionDateFormatter"
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController.sections?[section]
        var headerString = sectionInfo?.name
    
        if let dateString = headerString {
            let dateFormatter = DateFormatter()
            
            switch dater.daterRange {
            case .all: dateFormatter.dateFormat = "yyyy"
            case .year: dateFormatter.dateFormat = "MM"
            default: dateFormatter.dateFormat = "yyyyMMdd"
            }
            
            dateFormatter.locale = Locale.current
            let date = dateFormatter.date(from:dateString)!
            
            headerString = dater.sectionHeaderDateFormatter.string(from: date)
        }

        return headerString
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTransaction", for: indexPath)
        
        if let cell = cell as? TransactionCell {
            
            cell.configureCell(with: fetchedResultsController.object(at: indexPath))
        }

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let transaction = fetchedResultsController.object(at: indexPath)
            selectedWallet!.amount! = selectedWallet!.amount! - transaction.amount!
            coreDataStack.managedContext.delete(transaction)
            coreDataStack.saveContext()
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        // Takes care of toggling the button's title.
        super.setEditing(!isEditing, animated: true)
        // Toggle table view editing.
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
}

extension TransactionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        if #available(iOS 13.0, *) {
            headerView.contentView.backgroundColor = UIColor.systemGroupedBackground
        } else {
            headerView.contentView.backgroundColor = UIColor.white
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 49
    }
    
    
}


// MARK: - WalletBar CollectionView Delegate and DataSource methods


extension TransactionsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.dateBar {
            
            selectedDateInterval = dateBarItems[indexPath.row]
            setControllerAndFetch()
            
        } else {
            
            let wallet = wallets[indexPath.row]
            walletContainer.setSelectedWallet(wallet: wallet)
            coreDataStack.saveContext()
            selectedWallet = walletContainer.getSelectedWallet()
            
            let cell = walletBar.cellForItem(at: indexPath)
            if let cell = cell as? WalletBarCell {
                cell.configureWalletBarItems(with: wallet)
            }
            walletBar.reloadData()
            setControllerAndFetch()
        }
    }
    
    
}

extension TransactionsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.dateBar {
            return dateBarItems.count
        } else {
            return wallets.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.dateBar {
            let monthString = dater.dateFormatter.string(from: dateBarItems[indexPath.row].start)
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath)
            if let cell = cell as? DateBarCell {
                cell.monthName.text = monthString
            }
            return cell
        }
            
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "walletBarCollectionCell", for: indexPath)
            
            if let cell = cell as? WalletBarCell {
                let wallet = wallets[indexPath.row]
                cell.walletName.text = wallet.name
                cell.configureWalletBarItems(with: wallet)
            }
            return cell
        }
    }
}

extension TransactionsViewController:  UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == walletBar {
            return CGSize(width: 120.0, height: 65.0)
        }
            
        else {
            var divider: CGFloat  {
                switch dateBarItems.count {
                case 1: return 1.0
                case 2: return 2.0
                default: return 3.0
                }
            }
            
            var cellWidth: CGFloat { return (view.frame.size.width - 38.0) / divider }
            let size = CGSize(width: cellWidth, height: 34.0)
            return size
        }
        
    }
}

// MARK: - CoreData Methods and Delegates

extension  TransactionsViewController {
    
    func getController() -> NSFetchedResultsController<Transaction> {
        // 1
        
        let startDate = NSNumber(value: selectedDateInterval.start.getSimpleDescr())
        let endDate = NSNumber(value: selectedDateInterval.end.getSimpleDescr())
        
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        let predicate = NSPredicate(format: "simpleDate >=  %@ AND simpleDate <  %@ AND wallet == %@", startDate, endDate, selectedWallet ?? "0")

        
        fetchRequest.predicate = predicate
        let sort1 = NSSortDescriptor(key: keyPath, ascending: false)
        let sort2 = NSSortDescriptor(key: #keyPath(Transaction.dateCreated), ascending: false)
        fetchRequest.sortDescriptors = [sort1, sort2]
        
        // 2
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack!.managedContext,
            sectionNameKeyPath: keyPath,
            cacheName: nil)
        
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }
    
       func fetchTransactions() {
           do {
               try fetchedResultsController.performFetch()
           } catch let error as NSError {
               print("Fetching error: \(error), \(error.userInfo)")
               
           }
       }
       
    func setControllerAndFetch() {
        
        fetchedResultsController = getController()
        fetchTransactions()
        tableView.reloadData()
//           controllerDidChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
       }
}

extension TransactionsViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
        
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,                   didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert: tableView.insertRows(at: [newIndexPath!], with:
            .automatic)
            
        case .delete: tableView.deleteRows(at: [indexPath!], with: .left)
        case .update: let cell = tableView.cellForRow(at: indexPath!) as! TransactionCell
            cell.configureCell(with: fetchedResultsController.object(at: indexPath!))
        case .move: tableView.deleteRows(at: [indexPath!], with: .automatic)
        tableView.insertRows(at: [newIndexPath!], with: .automatic)
        @unknown default:
            print("Unexpected NSFetchedResultsChangeType")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
            case .insert: tableView.insertSections(indexSet, with: .top)
            case .delete: tableView.deleteSections(indexSet, with: .fade)
            default: break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates() }
    
}

// DateBar functions and methods

extension TransactionsViewController {
    
    private func configureDateBarData() {
        dateBarItems = dater.calculateDateIntervals()
        dateBar.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
    }
    
    
    private func upDater(_ timeRange: DaterRange) {
        dater.daterRange = timeRange
        configureDateBarData()
        selectedDateInterval = dateBarItems[0]
        dateBar.reloadData()
        dateBar.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        setControllerAndFetch()
    }
    
    private func prepareAlert() {
        actionSheet = UIAlertController(title: "Select Time Range", message: "Filter transactions by selected date", preferredStyle: .actionSheet)
        actionSheet!.addAction(UIAlertAction(
            title: "Day",
            style: .default,
            handler: { _ in
             
                self.keyPath = #keyPath(Transaction.simpleDate)
                   self.upDater(.days)
        }))
        actionSheet!.addAction(UIAlertAction(
            title: "Week",
            style: .default,
            handler: { _ in
                
                self.keyPath = #keyPath(Transaction.simpleDate)
                self.upDater(.weeks)
        }))
        actionSheet!.addAction(UIAlertAction(
            title: "Month",
            style: .default,
            handler: { _ in
              
                self.keyPath = #keyPath(Transaction.simpleDate)
                  self.upDater(.months)
        }))
        actionSheet!.addAction(UIAlertAction(
            title: "Year",
            style: .default,
            handler: { _ in
               
                self.keyPath = #keyPath(Transaction.month)
                 self.upDater(.year)

        }))
        
        actionSheet!.addAction(UIAlertAction(
            title: "All Time",
            style: .default,
            handler: { _ in
                
                self.keyPath = #keyPath(Transaction.year)
                self.upDater(.all)
        }))
        actionSheet!.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        ))
        
        
    }

}


