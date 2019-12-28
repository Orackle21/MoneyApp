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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // tableView.tableFooterView = UIView()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        let nibName = UINib(nibName: "CategoryHeader", bundle: nil)
        self.tableView.register(nibName, forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
        fetchCategories()
    }
    
    func fetchCategories() {
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
 
        selectedCategory = categories[indexPath.section].subCategories![indexPath.row] as? Category
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

        }
    }


    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView" ) as! HeaderView
        headerView.nameLabel.text = categories[section].name
        headerView.iconView.drawIcon(skin: categories[section].skin)
        headerView.iconView.setNeedsDisplay()
        
        // Set backround color for a grouped type of tableview
        
        let backgroundView = UIView(frame: headerView.bounds)
        if #available(iOS 13.0, *) {
            backgroundView.backgroundColor = UIColor.tertiarySystemBackground
        } else {
             backgroundView.backgroundColor = UIColor.white
        }
        headerView.backgroundView = backgroundView
        
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(headerTapped(_:))
        )
        headerView.tag = section
        headerView.addGestureRecognizer(tapGestureRecognizer)
        
        return headerView
    }

    
    @objc func headerTapped(_ sender: UITapGestureRecognizer?) {
        guard let section = sender?.view?.tag else { return }
        
        let view = sender?.view as! HeaderView
        view.contentView.backgroundColor = #colorLiteral(red: 0.8196078431, green: 0.8196078431, blue: 0.8392156863, alpha: 1)
        

        selectedCategory = categories[section]
        performSegue(withIdentifier: "unwindBack", sender: self)
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
        fetchCategories()
        tableView.reloadData()
    }
}
