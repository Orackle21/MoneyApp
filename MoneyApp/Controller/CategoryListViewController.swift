//
//  CategoryChooserViewController.swift
//  MoneyApp
//
//  Created by Orackle on 26/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit
import CoreData

class CategoryListViewController: UITableViewController {

    var coreDataStack: CoreDataStack!
    
    var selectedCategory: Category?
    var wallet: Wallet!
    var actionSheet: UIAlertController?
    var categories = [Category]()
    private var isExpense: Bool {
        switch expenseSwitch.selectedSegmentIndex {
        case 0: return true
        case 1: return false
        default:
            return true
        }
    }
    
    @IBOutlet weak var expenseSwitch: UISegmentedControl!
    
    @IBAction func switchExpense(_ sender: Any) {
        fetchAndReload()
    }
    
    
    func fetchAndReload() {
        fetchCategories()
        addSubCategories()
        tableView.reloadData()
    }
    

    func prepareAlert(for indexPath: IndexPath) {
        actionSheet = UIAlertController(title: "Delete Category?", message: "Do you really want to delete this category?", preferredStyle: .actionSheet)
        actionSheet!.addAction(UIAlertAction(
            title: "Delete Category And Associated Transactions",
            style: .destructive,
            handler: { _ in
               // FIXME: Remove category from controller
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }))

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        fetchCategories()
        addSubCategories()
    }
    
   
    private func addSubCategories() {
        for category in categories {
            let subcategories = category.subCategories?.array as! [Category]
            let index = categories.firstIndex(of: category)
            if !subcategories.isEmpty, let index = index {
                categories.insert(contentsOf: subcategories, at: index + 1)
            }
        }
    }
    
    
    private func fetchCategories() {
        guard let wallet = wallet else { return }
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        print(isExpense)
        let predicate = NSPredicate(format: "wallet == %@ AND isExpense == %@", wallet, NSNumber(value: isExpense))
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
    
    func recategorizeTransactions (in wallet: Wallet, from: Category, to: Category) {
        //FIXME: Fix this
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categories.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier: String
        
        let category = categories[indexPath.row]
        
        if category is SubCategory {
            cellIdentifier = "subCategoryCell"
        } else {
            cellIdentifier = "categoryCell"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if let cell = cell as? SubCategoryCell {
            cell.customize(skin: category.skin!, name: category.name!)
        }
        
        if let cell = cell as? CategoryCell {
            cell.customize(skin: category.skin!, name: category.name!)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
 
        selectedCategory = categories[indexPath.row]
        return indexPath
    }


    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let category = categories[indexPath.row]
        if category.isDeletable {
            return UITableViewCell.EditingStyle.delete
        }
        return UITableViewCell.EditingStyle.none
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let category = categories[indexPath.row]
            categories.remove(at: indexPath.row)
            coreDataStack.managedContext.delete(category)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            coreDataStack.saveContext()
//            prepareAlert(for: indexPath)
//            self.present(actionSheet!, animated: true, completion: nil)

        }
    }

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categoryDetailSegue" {
            if let destination = segue.destination as? CategoryDetailViewController {
                destination.wallet = wallet
                destination.coreDataStack = coreDataStack
                destination.delegate = self
            }
        }
    }
}


extension CategoryListViewController: CategoryDetailViewControllerDelegate {
    func didCreateNewCategory() {
        fetchAndReload()
    }
}
