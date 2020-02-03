//
//  CategoryReportViewController.swift
//  MoneyApp
//
//  Created by Orackle on 15.10.2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit
import CoreData

class CategoryReportViewController: UIViewController {

    
    var selectedDateInterval: DateInterval!
    var wallet: Wallet!
    var coreDataStack: CoreDataStack!
    var category: Category?
    var isExpense: Bool!
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Transaction> = getController()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTransactions()
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

extension CategoryReportViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController.sections?[section]
        return sectionInfo?.name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportsCell", for: indexPath)
        
        if let cell = cell as? ReportsCell {
            cell.periodNameLabel.text = category!.name
            cell.amountLabel.text = fetchedResultsController.object(at: indexPath).amount!.description
            
            if let icon = cell.iconView {
                icon.drawIcon(skin: category!.skin!)
                icon.setNeedsDisplay()
            }
        }
        
        
        
        return cell
    }
    
    
}

extension CategoryReportViewController {
    
    func getController() -> NSFetchedResultsController<Transaction> {
        // 1
        
        let startDate = NSNumber(value: selectedDateInterval.start.getSimpleDescr())
        let endDate = NSNumber(value: selectedDateInterval.end.getSimpleDescr())
        
        print (startDate)
        print (endDate)
        
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        let predicate = NSPredicate(format: "simpleDate >=  %@ AND simpleDate <  %@ AND wallet == %@ AND category == %@", startDate, endDate, wallet, category ?? "0")
        
        let amountPredicate: NSPredicate = {
            if isExpense {
                return NSPredicate(format: "amount <= 0")
            } else {
                return NSPredicate(format: "amount > 0")
            }
        }()
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, amountPredicate])
        
        fetchRequest.predicate = compoundPredicate
        
        let sort1 = NSSortDescriptor(key: #keyPath(Transaction.simpleDate), ascending: false)
        let sort2 = NSSortDescriptor(key: #keyPath(Transaction.dateCreated), ascending: false)
        fetchRequest.sortDescriptors = [sort1, sort2]
        
        // 2
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack!.managedContext,
            sectionNameKeyPath: #keyPath(Transaction.simpleDate),
            cacheName: nil)
        
        return fetchedResultsController
    }
    
       func fetchTransactions() {
           do {
            try fetchedResultsController.performFetch()
           } catch let error as NSError {
               print("Fetching error: \(error), \(error.userInfo)")
               
           }
       }
    
}
