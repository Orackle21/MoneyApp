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
    @IBOutlet weak var walletBarCollection: UICollectionView!
    @IBOutlet weak var dateBarCollection: UICollectionView!
    
    private var actionSheet: UIAlertController?
    @IBAction func changeTimeRange(_ sender: Any) {
        prepareAlert()
        self.present(actionSheet!, animated: true, completion: nil)
    }
    
    var coreDataStack: CoreDataStack!
    lazy var fetchedResultsController: NSFetchedResultsController<Transaction> = getController()
    var keyPath = #keyPath(Transaction.day)
    var walletContainer: WalletContainer!
    var transactionsFetch: NSFetchRequest<Transaction>!


    private var wallets = [Wallet]()
    private var selectedWallet: Wallet?
    
    private lazy var dater = Dater()
    private lazy var selectedDateInterval = DateInterval()

   
    private var dateBarItems = [DateInterval]()
    
    
    // MARK: - Implement cell update through delegate 
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        recalculateCellSize()
        let indexPath = dateBarCollection.indexPathsForSelectedItems?.first
        dateBarCollection.scrollToItem(at: indexPath!, at: .right, animated: false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedWallet = walletContainer.getSelectedWallet()

       
       
        
        
        // dateBar preparation
        dater.setDaterRange(.months)
        configureDateBarData()
        selectedDateInterval = dateBarItems[0]
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
            
        }
        
        // styling
        tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        styleDateBar()
        setupAddButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedWallet = walletContainer.getSelectedWallet()
        
        wallets.removeAll()
        print(walletContainer.wallets!.count)
        for object in walletContainer.wallets! {
            wallets.append(object as! Wallet)
        }
        
        
        walletBarCollection.reloadData()
        if selectedWallet == nil {
            tableView.reloadData()
            tableView.setEmptyView(title: "You don't have any wallets", message: "Add some wallets, please")
        }
        else {
            tableView.restore()
        }
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    func getController() -> NSFetchedResultsController<Transaction> {
        // 1
        
        let startDate = selectedDateInterval.start as NSDate
        let endDate = selectedDateInterval.end as NSDate

        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        let predicate = NSPredicate(format: "date >=  %@ AND date <=  %@ AND wallet == %@", startDate, endDate, selectedWallet ?? "0")
        
        let compoundPredicate = NSCompoundPredicate()
        fetchRequest.predicate = predicate
        
        let sort1 = NSSortDescriptor(key: keyPath, ascending: false)
        let sort2 = NSSortDescriptor(key: #keyPath(Transaction.date), ascending: true)
        fetchRequest.sortDescriptors = [sort1, sort2]
        
        // 2
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: coreDataStack!.managedContext, sectionNameKeyPath: keyPath,
                                                                  cacheName: nil)
//        fetchedResultsController.delegate = self
        return fetchedResultsController
    }
    

    // Configures cell's labels for passed item
    private func configureTransactions(for cell: UITableViewCell, with transaction: Transaction) {
        if let cell = cell as? TransactionCell {
            cell.categoryLabel.text = transaction.category?.name
            cell.nameLabel.text = transaction.note
            cell.amountLabel.text = (transaction.currency!.symbol ?? transaction.currency!.id) + " " + transaction.amount!.description
            cell.dateLabel.text = dater.dateFormatter.string(from: transaction.date!)
            Int(truncating: transaction.amount!) > 0 ? (cell.amountLabel.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)) : (cell.amountLabel.textColor = #colorLiteral(red: 0.9203510284, green: 0.1116499379, blue: 0.1756132543, alpha: 1))
            
            if let icon = cell.categoryIcon as? IconView {
                icon.drawIcon(skin: transaction.category!.skin!)
                icon.setNeedsDisplay()
            }
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
                        
                        guard let wallet = selectedWallet else {
                            return
                        }
                        
                        destination.transactionToEdit = fetchedResultsController.object(at: indexPath)
                            destination.wallet = wallet
                            destination.title = "Edit Transaction"
                        destination.coreDataStack = coreDataStack
                        
                        
                    }
                }
            }
        }
    }
    
    @IBAction func unwindBack(_ unwindSegue: UIStoryboardSegue) {
        if let walletList = unwindSegue.source as? WalletListViewController {
            if let wallet = walletList.walletContainer?.getSelectedWallet() {
                selectedWallet = wallet
                tableView.reloadData()
            }
            
            //FIXME: Get selected wallet
        }
    }
    
}


//MARK: - TableView Delegate and DataSource methods

extension TransactionsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        let count = fetchedResultsController.sections?.count

        // Shows a message if there are no sections
        if count == 0 {
            tableView.setEmptyView(title: "You don't have any transactions", message: "Add some transactions, please")
        }
        else {
            tableView.restore()
        }
        
        return count ?? 0
    }
    
    // Sets header title for section using "sectionDateFormatter"
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController.sections?[section]
        return sectionInfo?.name
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
            configureTransactions(for: cell, with: fetchedResultsController.object(at: indexPath))
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // FIXME: Implement deletion
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
        
        if collectionView == self.dateBarCollection {
            selectedDateInterval = dateBarItems[indexPath.row]
        } else {
            walletContainer.setSelectedWallet(wallet: wallets[indexPath.row])
            coreDataStack.saveContext()
            selectedWallet = walletContainer.getSelectedWallet()
            self.tableView.reloadData()
            walletBarCollection.reloadData()
        }
    }
}

extension TransactionsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.dateBarCollection {
            return dateBarItems.count
        } else {
            print( wallets.count)
            return wallets.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.dateBarCollection {
            let monthString = dater.dateFormatter.string(from: dateBarItems[indexPath.row].start)
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath)
            if let cell = cell as? DateBarCell {
                cell.monthName.text = monthString
                //                cell.layer.addBorder(edge: .left, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3961633133), thickness: 1.0)
                //                cell.layer.addBorder(edge: .right, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3961633133), thickness: 1.0)
            }
            return cell
        }
            
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "walletBarCollectionCell", for: indexPath)
            
            if let cell = cell as? WalletBarViewCell {
                cell.walletName.text = wallets[indexPath.row].name
                let item = wallets[indexPath.row]
                configureWalletBarItems(for: cell, with: item)
            }
            return cell
        }
    }
}

extension TransactionsViewController:  UICollectionViewDelegateFlowLayout
{
    
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //
    //        if collectionView == self.dateBarCollection {
    //            let width = collectionView.frame.width
    //            return CGSize(width: cellWidth, height: 34.0)
    //        } else {
    //        return CGSize(width: 125, height: collectionView.frame.height)
    //        }
    //    }
}

extension TransactionsViewController {
    
    @objc private func addTransaction() {
        performSegue(withIdentifier: "detailSegue", sender: (Any).self)
    }
    
    private func setupAddButton() {
        var centerButton: UIButton
        centerButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        
        centerButton.backgroundColor = #colorLiteral(red: 0.5739042749, green: 0.4383537778, blue: 1, alpha: 1)
        centerButton.layer.cornerRadius = 15
        
        
        let icon = UIImage(named: "addButton")
        centerButton.setImage(icon?.maskWithColor(color: UIColor.white), for: .normal)
        centerButton.imageView?.contentMode = .scaleAspectFill
        view.addSubview(centerButton)
        centerButton.addTarget(self, action: #selector(self.addTransaction), for: .touchUpInside)
        
        
        let barButton = UIBarButtonItem(customView: centerButton)
        navigationItem.rightBarButtonItem = barButton
        view.layoutIfNeeded()
    }
    
    
    
}

extension TransactionsViewController {
    
    private func configureDateBarData() {
        dateBarItems = dater.getTimeIntervals()
    }
    
    private func recalculateCellSize() {
        
        var divider: CGFloat  {
            switch dateBarItems.count {
            case 1: return 1.0
            case 2: return 2.0
            default: return 3.0
            }
        }

        let layout = dateBarCollection.collectionViewLayout as! UICollectionViewFlowLayout
        var cellWidth: CGFloat { return (view.frame.size.width - 30.0) / divider }
        layout.itemSize = CGSize(width: cellWidth, height: 34.0)
    }
    
    
    
    private func styleDateBar() {
        let blurEffect = UIBlurEffect(style: .prominent)
        let blurView = UIVisualEffectView(effect: blurEffect)
        dateBarCollection.backgroundView = blurView
        dateBarCollection.layer.cornerRadius = 20.0
        dateBarCollection.layer.borderWidth = 1.0
        dateBarCollection.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1526915668)
        dateBarCollection.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .right)
        
        
    }
    
    private func configureWalletBarItems (for cell: WalletBarViewCell, with item: Wallet) {
        let color = UIColor(named: item.skin?.color ?? " ")
        item.isSelected ? (cell.backgroundColor = color) : (cell.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
    }
    
    
    
    private func upDater(_ timeRange: DaterRange) {
        dater.setDaterRange(timeRange)
        configureDateBarData()
        recalculateCellSize()
        selectedDateInterval = dateBarItems[0]
        tableView.reloadData()
        dateBarCollection.reloadData()
        dateBarCollection.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .right)
    }
    
    private func prepareAlert() {
        actionSheet = UIAlertController(title: "Select Time Range", message: "Filter transactions by selected date", preferredStyle: .actionSheet)
        actionSheet!.addAction(UIAlertAction(
            title: "Day",
            style: .default,
            handler: { _ in
                self.upDater(.days)
        }))
        actionSheet!.addAction(UIAlertAction(
            title: "Week",
            style: .default,
            handler: { _ in
                self.upDater(.weeks)
        }))
        actionSheet!.addAction(UIAlertAction(
            title: "Month",
            style: .default,
            handler: { _ in
                self.upDater(.months)
        }))
        actionSheet!.addAction(UIAlertAction(
            title: "Year",
            style: .default,
            handler: { _ in
                self.upDater(.year)
        }))
        
        actionSheet!.addAction(UIAlertAction(
            title: "All Time",
            style: .default,
            handler: { _ in
                self.upDater(.all)
        }))
        actionSheet!.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        ))
        
        
    }

}


