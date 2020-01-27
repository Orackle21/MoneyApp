//
//  BudgetViewController.swift
//  MoneyApp
//
//  Created by Orackle on 05/09/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit
import CoreData

class BudgetViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Budget> = getController()

    var coreDataStack: CoreDataStack!
    var walletContainer: WalletContainer!
    
    private var selectedWallet: Wallet?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        selectedWallet = walletContainer.getSelectedWallet()
        fetchBudgets()
       
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        if selectedWallet == walletContainer.getSelectedWallet() {
            return
        } else {
            selectedWallet = walletContainer.getSelectedWallet()
            setControllerAndFetch()
        }
        if selectedWallet == nil {
            addButton.isEnabled = false
        } else {
            addButton.isEnabled = true
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "budgetDetail" {
            if let navigationController = segue.destination as? UINavigationController {
                if let destination = navigationController.viewControllers.first as? BudgetDetailViewController {
                    destination.coreDataStack = coreDataStack
                    destination.wallet = selectedWallet
                    
                }
            }
        }
    }
}

// MARK: - TableView DataSource and Delegate methods


extension BudgetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        let count = fetchedResultsController.sections?.count
        guard selectedWallet != nil else { return 0 }
        return count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "budgetCell", for: indexPath)
        
        if let cell = cell as? BudgetCell {
            let budget = fetchedResultsController.object(at: indexPath)
            cell.configureCell(with: budget, spent: budget.getAmountSpent(coreDataStack: coreDataStack))
        }
        
        
        return cell
    }
}

extension BudgetViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 146
    }
}



// MARK: - FetchedResultsController declaration and methods

extension  BudgetViewController {
    
    func getController() -> NSFetchedResultsController<Budget> {
        // 1
        
        let fetchRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
        let predicate = NSPredicate(format: "wallet == %@",  selectedWallet ?? "0")
        fetchRequest.predicate = predicate
        
        let sort = NSSortDescriptor(key: #keyPath(Budget.dateCreated), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        // 2
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack!.managedContext,
            sectionNameKeyPath: #keyPath(Budget.dateCreated), 
            cacheName: nil)
        
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }
    
       func fetchBudgets() {
           do {
               try fetchedResultsController.performFetch()
           } catch let error as NSError {
               print("Fetching error: \(error), \(error.userInfo)")
               
           }
       }
       
    func setControllerAndFetch() {
        
        fetchedResultsController = getController()
        fetchBudgets()
        tableView.reloadData()
       }
}

extension BudgetViewController: NSFetchedResultsControllerDelegate {
    
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
        case .update: let cell = tableView.cellForRow(at: indexPath!) as! BudgetCell
        cell.configureCell(with: fetchedResultsController.object(at: indexPath!), spent: fetchedResultsController.object(at: indexPath!).getAmountSpent(coreDataStack: coreDataStack))
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
