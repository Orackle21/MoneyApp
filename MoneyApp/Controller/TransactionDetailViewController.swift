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
    var wallet: Wallet?
    
    var transactionToEdit: Transaction?
    var selectedCategory: Category? {
        didSet {
            if let category = selectedCategory {
                categoryNameLabel.text = category.name
            } else {
                categoryNameLabel.text = "Select Category"
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
        amountTextField.delegate = self
        dateFormatter.dateFormat = "MMMM d, yyyy"
        dateLabel.text = dateFormatter.string(from: datePicker.date)

        if let item = transactionToEdit {
            noteTextField.text = item.note
            amountTextField.text = getAmountString(amount: item.amount)
            selectedCategory = item.category
            datePickerDate = item.simpleDate.convertToDate()!
            datePicker.date = item.simpleDate.convertToDate()!
        }
        
        
    }
    
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        datePickerDate = sender.date
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if let item = transactionToEdit, let wallet = wallet {
            item.note = noteTextField.text ?? ""
            wallet.amount! = wallet.amount! - item.amount!
            item.amount = getAmount()
            wallet.amount! = wallet.amount! + item.amount!
            tryToChangeDate(transaction: item)
            item.category = selectedCategory
        }
        else if transactionToEdit == nil {
            if let wallet = wallet  {
                
                var calendar = Calendar.current
                calendar.timeZone = TimeZone.current
                let components = datePickerDate.getComponenets()
                let date = calendar.date(from: components)
                
                let transaction = Transaction(context: coreDataStack.managedContext)
                transaction.note = noteTextField.text ?? ""
                transaction.wallet = wallet
                transaction.category = selectedCategory!
                transaction.currency = wallet.currency
                transaction.amount = getAmount()
                transaction.dateCreated = Date()
                transaction.simpleDate = Int64(date!.getSimpleDescr())
                transaction.month = Int32(date!.month()!)
                transaction.year = Int32(date!.month()!)
                wallet.amount = transaction.amount! + wallet.amount!
            }
        }
        coreDataStack.saveContext()
        self.dismiss(animated: true)
    }
    
    private func getAmountString(amount: NSDecimalNumber?) -> String {
        
        if let amount = amount {
            let number = abs(amount.decimalValue)
            return number.description
        }
        else {
            return ""
        }
        
    }
    
    private func getAmount() -> NSDecimalNumber {
        
        if let category = selectedCategory {
            var absoluteValue = 0
            if let textfieldAmount = Int(amountTextField.text ?? "0") {
                absoluteValue = abs(textfieldAmount)
            }
            
            if category.isExpense {
                return -(NSDecimalNumber(value: absoluteValue))
            } else {
                return NSDecimalNumber(value: absoluteValue)
            }
        }
        else{
            return 0
        }
        
    }
    
    
    
    private func tryToChangeDate (transaction: Transaction) {
        if transaction.simpleDate == datePickerDate.getSimpleDescr() {
            return
        } else {
            let date = datePickerDate
            transaction.simpleDate = date.getSimpleDescr()
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


extension TransactionDetailViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       guard let text = textField.text, let decimalSeparator = NSLocale.current.decimalSeparator else {
           return true
       }

        var splitText = text.components(separatedBy: decimalSeparator)
        let totalDecimalSeparators = splitText.count - 1
        let isEditingEnd = (text.count - 3) < range.lowerBound

        splitText.removeFirst()

        // Check if we will exceed 2 dp
        if
            splitText.last?.count ?? 0 > 1 && string.count != 0 &&
            isEditingEnd
        {
            return false
        }

        // If there is already a dot we don't want to allow further dots
        if totalDecimalSeparators > 0 && string == decimalSeparator {
            return false
        }

        // Only allow numbers and decimal separator
        switch(string) {
        case "", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", decimalSeparator:
            return true
        default:
            return false
        }
    }

}
