//
//  AddTransactionTableViewController.swift
//  MoneyApp
//
//  Created by Orackle on 10/06/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit
import CoreData

class TransactionDetailViewController: UITableViewController {
    
    var coreDataStack: CoreDataStack!
    var transactionToEdit: Transaction?
    var wallet: Wallet?
    var selectedCategory: Category? {
        didSet {
            if let category = selectedCategory {
                categoryNameLabel.text = category.name
            }
        }
    }
    
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    private var datePickerIsCollapsed = true
    private let dateFormatter = DateFormatter()
    private var datePickerDate = Date() {
        didSet {
            dateLabel.text = dateFormatter.string(from: datePickerDate)
        }
    }
    @IBAction func cancelAdding(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     //   checkTheCategory() //FIXME:
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     let start = CFAbsoluteTimeGetCurrent()
        
        dateFormatter.dateFormat = "MMMM d, yyyy"
        dateLabel.text = dateFormatter.string(from: datePicker.date)

        if let item = transactionToEdit {
            noteTextField.text = item.note
            amountTextField.text = item.amount!.description
            selectedCategory = item.category
            datePickerDate = item.date!
            datePicker.date = item.date!
        }
      let diff = CFAbsoluteTimeGetCurrent() - start
      print("Took \(diff) seconds")
    }
    
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        datePickerDate = sender.date
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if let item = transactionToEdit {
            item.note = noteTextField.text ?? ""
            item.amount = NSDecimalNumber(string: amountTextField.text ?? "0")
            tryToChangeDate(transaction: item)
            item.category = selectedCategory
        }
        else if transactionToEdit == nil {
            if let wallet = wallet  {
                
                let calendar = Calendar.current
                var components = datePickerDate.getComponenets()
                components.timeZone = TimeZone.current
                let date = calendar.date(from: components)
                
                let transaction = Transaction(context: coreDataStack.managedContext)
                transaction.note = noteTextField.text ?? ""
                transaction.wallet = wallet
                transaction.category = selectedCategory!
                transaction.currency = wallet.currency
                transaction.amount = NSDecimalNumber(string: amountTextField.text ?? "0")
                transaction.dateCreated = Date()
                transaction.simpleDate = Int64(date!.getSimpleDescr())
                transaction.month = Int32(date!.month()!)
                transaction.year = Int32(date!.month()!)
                transaction.date = date
            }
        }
        coreDataStack.saveContext()
        self.dismiss(animated: true)
    }
    
    func tryToChangeDate (transaction: Transaction) {
        if transaction.simpleDate == datePickerDate.getSimpleDescr() {
            return
        } else {
            let date = datePickerDate
            transaction.date = date
            transaction.simpleDate = Int64(date.getSimpleDescr())
            transaction.dateCreated = Date()
            
        }
    } 
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 0 {
            datePickerIsCollapsed ? showDatePicker() : hideDatePicker()
        }
         tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 && indexPath.row == 1 {
            if datePickerIsCollapsed {
                return 0
            } else if !datePickerIsCollapsed{
                return 216
            }
        }
        return 44
    }
    
    private func checkTheCategory() {
        //FIXME: Check for category
    }
    
    private func showDatePicker() {
        
        tableView.beginUpdates()
        datePicker.isHidden = false
        datePicker.alpha = 0
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.3,
            delay: 0,
            options: [.transitionCrossDissolve],
            animations: {
                self.datePicker.alpha = 1
                self.datePickerIsCollapsed = false
        }
        )
        tableView.endUpdates()
    }
    
    private func hideDatePicker () {
        
        tableView.beginUpdates()
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.3,
            delay: 0,
            options: [.transitionCrossDissolve],
            animations: {
                self.datePicker.alpha = 0
                self.datePickerIsCollapsed = true
               
        }, completion:  {
            _ in
           //  self.datePicker.isHidden = true
        }
        )
        tableView.endUpdates()
    }
    
    @IBAction func unwindBack(_ unwindSegue: UIStoryboardSegue) {
        if let categoryEdit = unwindSegue.source as? CategoryListViewController {
            selectedCategory = categoryEdit.selectedCategory
        }
       
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CategoryListViewController {
            if let category = selectedCategory {
                destination.selectedCategory = category
            }
            destination.wallet = wallet
            destination.coreDataStack = coreDataStack
        }
     }
    
    
}

