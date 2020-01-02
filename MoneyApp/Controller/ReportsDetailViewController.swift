//
//  ReportsDetailViewController.swift
//  MoneyApp
//
//  Created by Orackle on 28/09/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit
import Charts
import CoreData

class ReportsDetailViewController: UIViewController {

    var coreDataStack: CoreDataStack!
    var wallet: Wallet!
    var dateInterval: DateInterval!
    
    
    private var incomeTransactions = [Category: [Transaction]]()
    private var expenseTransactions = [Category: [Transaction]]()

    private lazy var categories = [Category]()
    
    private var amounts: [NSDecimalNumber] {
        get {
            return getChartAmounts()
        }
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
   
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: setExpenseAndUpdate()
        case 1: setIncomeAndUpdate()
        default:
            return
        }
    }
    
    
    private var income: NSDecimalNumber = 0.0
    private var expenses: NSDecimalNumber = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeChartData()
        calculateIncomeAndExpenses()
        updateChart()
    }
    
    private func setExpenseAndUpdate() {
        categories = Array(expenseTransactions.keys)
        updateChart()
    }
    
    private func setIncomeAndUpdate() {
       categories = Array(incomeTransactions.keys)
        updateChart()
    }
    
    private func updateChart() {
        customizeChart(dataPoints: categories.map({$0.name!}),
                            values: amounts.map({$0.doubleValue}))
        tableView.reloadData()

    }
    
    private func getAmountByCategory(_ category: Category) -> NSDecimalNumber {
        var amount: NSDecimalNumber = 0.0
        
        var transactionsByCategory: [Category: [Transaction]]
        
        switch segmentedControl.selectedSegmentIndex {
            case 0: transactionsByCategory = expenseTransactions
            case 1: transactionsByCategory = incomeTransactions
            default: transactionsByCategory = expenseTransactions
            }
        
        
        let transactions = transactionsByCategory[category]
        for transaction in transactions! {
            amount = amount + transaction.amount!
        }
        return amount
    }
    
    private func getChartAmounts() -> [NSDecimalNumber] {
        var amounts = [NSDecimalNumber]()
        for category in categories {
            let amount = getAmountByCategory(category)
            amounts.append(amount)
        }
        return amounts
    }
    
    private func calculateIncomeAndExpenses() {
        for category in expenseTransactions.keys {
            let transactions = expenseTransactions[category]
            for transaction in transactions! {
                let amount = transaction.amount
                expenses = expenses + amount!
            }
        }
        
        for category in incomeTransactions.keys {
            let transactions = incomeTransactions[category]
            for transaction in transactions! {
                let amount = transaction.amount
                income = income + amount!
            }
        }
    }
    
    
    
    private func customizeChartData() {
        guard let wallet = wallet else {
            return
        }
             
        let transactions = fetchTransactions()
        
        var incomeTransactions = Array(transactions.filter({ $0.amount! > 0.0 }))
        var expenseTransactions = Array(transactions.filter({ $0.amount! < 0.0 }))

        self.incomeTransactions = Dictionary(grouping: incomeTransactions, by: {
            $0.category!
        })
        self.expenseTransactions = Dictionary(grouping: expenseTransactions, by: {
            $0.category!
        })
        categories = Array(self.expenseTransactions.keys)
        
        //FIXME: FIX ALL THIS 
        
    }
    
    
    
    func fetchTransactions() -> [Transaction]{
        
        let startDate = NSNumber(value: dateInterval.start.getSimpleDescr())
        let endDate = NSNumber(value: dateInterval.end.getSimpleDescr())

        

        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()

        let predicate = NSPredicate(format: "simpleDate >=  %@ AND simpleDate <  %@ AND wallet == %@", startDate, endDate, wallet! )
        fetchRequest.predicate = predicate
        
        var result = [Transaction]()
        do {
            result =  try coreDataStack.managedContext.fetch(fetchRequest)
            print (result)
        } catch let error as NSError {
            print (error)
        }
        return result
    }
   
    
    
   
    

    // MARK: - Navigation

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categoryReport" {
            if let destination = segue.destination as? CategoryReportViewController {
                
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    destination.category = categories[indexPath.row]
                }
                
            }
        }
    }
    

}

    //MARK: - TableView DataSource and Delegate methods

extension ReportsDetailViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            
            switch segmentedControl.selectedSegmentIndex {
            case 0: return expenseTransactions.keys.count
            case 1: return incomeTransactions.keys.count
            default: return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier: String
        
        if indexPath.section == 0 {
            cellIdentifier = "detailReportCell"
        }
        else {
            cellIdentifier = "reportsCell"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if let cell = cell as? ReportsDetailCell {
            cell.selectionStyle = .none
            cell.incomeIcon.backgroundColor = UIColor.systemGreen
            cell.expenseIcon.backgroundColor = UIColor.systemRed
            
            cell.incomeLabel.text = income.description
            cell.expenseLabel.text = expenses.description
            
            if #available(iOS 13.0, *) {
                cell.stackView.spacing = 10.0
            } else {
                cell.stackView.spacing = 1.0
                cell.stackView.subviews[0].layer.cornerRadius = 0.0
                cell.stackView.subviews[1].layer.cornerRadius = 0.0
            }
        }
        
        if let cell = cell as? ReportsCell {
            
            
            let name = categories[indexPath.row].name
            cell.periodNameLabel.text = name
            
           
            let category = categories[indexPath.row]
            
            cell.amountLabel.text = getAmountByCategory(category).description
            
            if let icon = cell.iconView as? IconView {
                icon.drawIcon(skin: categories[indexPath.row].skin!)
                icon.setNeedsDisplay()
            }
            
        }
        return cell
    }
    
}

extension ReportsDetailViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
       }

    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 22.0
    }
}


// MARK: - Chart View Customization

extension ReportsDetailViewController {
    private func customizeChart(dataPoints: [String], values: [Double]) {
        let format = NumberFormatter()
        var newValue = values
        
        if let value = values.first {
           if value < 0 {
                newValue = values.map( { $0 * -1 })
                format.positivePrefix = "-"
            }
           
        }
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: newValue[i], label: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        format.numberStyle = .decimal
       
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        // 4. Assign it to the chart’s data
        pieChart.data = pieChartData
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for _ in 0..<numbersOfColor {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        return colors
    }
}


