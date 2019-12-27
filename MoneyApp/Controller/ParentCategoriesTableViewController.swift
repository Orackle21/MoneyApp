//
//  ParentCategoriesTableViewController.swift
//  MoneyApp
//
//  Created by Orackle on 22/08/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit
import CoreData

class ParentCategoriesTableViewController: UITableViewController {

    
    var coreDataStack: CoreDataStack!
    var wallet: Wallet!
    
    var categories = [Category]()
    var selectedCategory: Category?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let wallet = wallet else { return }
        
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let predicate = NSPredicate(format: "wallet == %@", wallet)
        fetchRequest.includesSubentities = false
        fetchRequest.predicate = predicate
        
        do {
            categories = try coreDataStack.managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
        }
        categories.sort(by: {
            $0.transactions!.count > $1.transactions!.count
        } )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return categories.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
          let cell = tableView.dequeueReusableCell(withIdentifier:  "parentCategoryCell", for: indexPath)
            cell.textLabel?.text = "X - No Parent Category"
             return cell
        } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "parentCategoryCell", for: indexPath)

            cell.textLabel?.text = categories[indexPath.row].name
             return cell
        }

       
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 {
            selectedCategory = nil
        } else {
            selectedCategory = categories[indexPath.row]
        }
        return indexPath
    }
    
}
