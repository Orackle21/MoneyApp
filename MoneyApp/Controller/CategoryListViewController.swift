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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let predicate = NSPredicate(format: "wallet == %@", wallet)
        fetchRequest.includesSubentities = false
        fetchRequest.predicate = predicate

        do {
            categories = try coreDataStack.managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
        }
        print(categories.count)
        categories.sort(by: {
            $0.transactions!.count > $1.transactions!.count
        } )
        
        tableView.tableFooterView = UIView()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    func recategorizeTransactions (in wallet: Wallet, from: Category, to: Category) {
        //FIXME: Fix this
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories[section].subCategories?.count ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let subCategories = categories[indexPath.section]
        let subCategory = subCategories.subCategories![indexPath.row] as! Category
                    
            cell.textLabel?.text = subCategory.name
        
        return cell
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedCategory = categories[indexPath.row].subCategories![indexPath.row] as? Category
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
            prepareAlert(for: indexPath)
            self.present(actionSheet!, animated: true, completion: nil)

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    // Sets header title for section using "sectionDateFormatter"
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return categories[section].name
    }



    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
      //  wallet.categoryList.moveCategory(from: fromIndexPath.row, to: to.row)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categoryDetailSegue" {
            if let destination = segue.destination as? CategoryDetailViewController {
                destination.wallet = wallet!
                destination.coreDataStack = coreDataStack
            }
        }
    }


}
