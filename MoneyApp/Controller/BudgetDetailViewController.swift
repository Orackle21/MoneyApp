//
//  BudgetDetailViewController.swift
//  MoneyApp
//
//  Created by Orackle on 22.01.2020.
//  Copyright © 2020 Orackle. All rights reserved.
//

import UIKit

class BudgetDetailViewController: UITableViewController {
    
    var coreDataStack: CoreDataStack!
    var wallet: Wallet?
    
    var budgetToEdit: Budget?
    private var startDate = Date()
    private var endDate = Date()
    
    private var selectedCategory: Category? {
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
    @IBOutlet weak var dateLabel: UILabel!
    
    private let dateFormatter = DateFormatter()
    
    
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
        self.clearsSelectionOnViewWillAppear = true
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        amountTextField.delegate = self
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        if let item = budgetToEdit {
            amountTextField.text = getCurrencySymbol() + getAmountString(amount: item.amount)
            selectedCategory = item.category
            startDate = item.startDate.convertToDate()!
            endDate = item.endDate.convertToDate()!
            dateLabel.text = dateFormatter.string(from: startDate) + dateFormatter.string(from: endDate)
        }
        
        else {
            amountTextField.becomeFirstResponder()
        }
        
        amountTextField.placeholder = getCurrencySymbol() + "0"
        
    }
    
    private func switchSaveButton() {
        if amountIsWrong() || selectedCategory == nil  {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
        
    }
    
    private func amountIsWrong() -> Bool {
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
    
    
   
    
    @IBAction func saveAction(_ sender: Any) {
        if let item = budgetToEdit, let _ = wallet {
            item.amount = getAmount()
            tryToChangeDate(budget: item)
            item.category = selectedCategory
        }
        else if budgetToEdit == nil {
             if let wallet = wallet  {

                let budget = Budget(context: coreDataStack.managedContext)
                budget.wallet = wallet
                budget.category = selectedCategory!
                budget.amount = getAmount()
                budget.dateCreated = Date()
                budget.startDate = startDate.getSimpleDescr()
                budget.endDate = endDate.getSimpleDescr()
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
    
    
    
    private func tryToChangeDate (budget: Budget) {
        
        if budget.startDate == startDate.getSimpleDescr() &&
           budget.endDate == endDate.getSimpleDescr() {
            return
        } else {
          //  let date = datePickerDate
//            budget.simpleDate = date.getSimpleDescr()
//            budget.dateCreated = Date()
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == 0 {
            return 55
        }
        return 44
    }
    
    private func checkTheCategory() {
        //FIXME: Check for category
    }
    
    
    @IBAction func unwindBack(_ unwindSegue: UIStoryboardSegue) {
        if let categoryList = unwindSegue.source as? CategoryListViewController {
            selectedCategory = categoryList.selectedCategory
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


extension BudgetDetailViewController: UITextFieldDelegate {
    
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
        
        
        // Check if there is only one dot
        if totalDecimalSeparators > 0 && string == decimalSeparator {
            return false
        }
        
        if range.length > 0  && range.location == currencySymbolText.count {
            return false
        }
        
        if text == (getCurrencySymbol() + "0") {
            amountTextField.text = getCurrencySymbol() + string
            switchSaveButton()
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


