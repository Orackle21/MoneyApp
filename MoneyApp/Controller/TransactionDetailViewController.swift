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
                switchSaveButton()
            } else {
                categoryNameLabel.text = "Select Category"
            }
        }
    }
   
    
    
    @IBOutlet weak var amountTextField: UITextField! {
        didSet {
           switchSaveButton()
        }
    }
    @IBAction func didStartEditing(_ sender: Any) {
        if amountTextField.text == "" {
               self.amountTextField.text = getCurrencySymbol() + "0"
           }
       }
    
    @IBAction func editingChanged(_ sender: UITextField) {
       switchSaveButton()
    }
    
    
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var noteTextField: UITextView!
  
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    private var datePickerIsCollapsed = true
    private let dateFormatter = DateFormatter()
    private var datePickerDate = Date() {
        didSet {
            dateLabel.text = dateFormatter.string(from: datePickerDate)
        }
    }
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBAction func cancelAdding(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        amountTextField.delegate = self
        dateFormatter.dateFormat = "MMMM d, yyyy"
        dateLabel.text = dateFormatter.string(from: datePicker.date)
        
        if let item = transactionToEdit {
            noteTextField.text = item.note
            amountTextField.text = getCurrencySymbol() + getAmountString(amount: item.amount)
            
            selectedCategory = item.category
            
            datePickerDate = item.simpleDate.convertToDate()!
            datePicker.date = item.simpleDate.convertToDate()!
        } else {
            amountTextField.becomeFirstResponder()
        }
        
        amountTextField.placeholder = getCurrencySymbol() + "0"
        
    }
    
    private func switchSaveButton() {
        if isWrongAmountText() || selectedCategory == nil  {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }

    }
    
    private func isWrongAmountText() -> Bool {
        switch amountTextField.text {
        case  getCurrencySymbol(): return true
        case getCurrencySymbol() + "0": return true
        case .none:
            return true
        case .some(_):
            return false
        }
    }
    
    private func getCurrencySymbol() -> String{
        
        let symbol = (wallet?.currency?.symbol  ?? (wallet?.currency!.id)!) + " "
        return symbol
        
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
                transaction.month = Int64(date!.month()!)
                transaction.year = Int64(date!.month()!)
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
        let string = amountTextField.text?.components(separatedBy: getCurrencySymbol())
        
        if let category = selectedCategory, let string = string {
            var absoluteValue: Decimal
            
            let textfieldAmount = Decimal(string: string[1])
            absoluteValue = abs(textfieldAmount ?? 0)
            let resultValue = NSDecimalNumber(decimal: absoluteValue)
            
            if category.isExpense {
                return -resultValue
            } else {
                return resultValue
            }
        }
        else {
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
        if indexPath.section == 2 && indexPath.row == 0 {
            if datePickerIsCollapsed {
                return 44
            } else if !datePickerIsCollapsed{
                return 270
            }
        }
        
        if indexPath.section == 0 {
            return 55
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
        let currencySymbolText = text.components(separatedBy: " ")[0]
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
        
        if range.length > 0  && range.location == currencySymbolText.count {
            return false
        }
        
        if text == (getCurrencySymbol() + "0") {
            amountTextField.text = getCurrencySymbol() + string
            saveButton.isEnabled = true
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
