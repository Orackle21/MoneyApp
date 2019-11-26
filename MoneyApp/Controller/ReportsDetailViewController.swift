//
//  ReportsDetailViewController.swift
//  MoneyApp
//
//  Created by Orackle on 28/09/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit
import Charts

class ReportsDetailViewController: UIViewController {

    var stateController: StateController!
    var selectedTimeRange: DateInterval!
    
    private var transactionsGroupedByCategories = [Category: [Transaction]]()
    
    private var incomeTransactionsGrouped = [Category: [Transaction]]()
    private var expenseTransactionsGrouped = [Category: [Transaction]]()

    
    private var categories: [Category] {
        Array(transactionsGroupedByCategories.keys)
    }
    private var amounts: [Decimal] {
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
    
    
    private var income: Decimal = 0.0
    private var expenses: Decimal = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeChartData()
        calculateIncomeAndExpenses()
        updateChart()
    }
    
    private func setExpenseAndUpdate() {
        transactionsGroupedByCategories = expenseTransactionsGrouped
        updateChart()
    }
    
    private func setIncomeAndUpdate() {
        transactionsGroupedByCategories = incomeTransactionsGrouped
        updateChart()
    }
    
    private func updateChart() {
        customizeChart(dataPoints: categories.map({$0.name!}),
                            values: amounts.map({$0.doubleValue}))
        tableView.reloadData()

    }
    
    private func getAmountByCategory(_ category: Category) -> Decimal {
        var amount: Decimal = 0.0
        let transactions = transactionsGroupedByCategories[category]
        for transaction in transactions! {
            amount += transaction.amount
        }
        return amount
    }
    
    private func getChartAmounts() -> [Decimal] {
        var amounts = [Decimal]()
        for category in categories {
            let amount = getAmountByCategory(category)
            amounts.append(amount)
        }
        return amounts
    }
    
    private func calculateIncomeAndExpenses() {
        for category in expenseTransactionsGrouped.keys {
            let transactions = expenseTransactionsGrouped[category]
            for transaction in transactions! {
                let amount = transaction.amount
                expenses += amount
            }
        }
        
        for category in incomeTransactionsGrouped.keys {
            let transactions = incomeTransactionsGrouped[category]
            for transaction in transactions! {
                let amount = transaction.amount
                income += amount
            }
        }
    }
    
    
    
    private func customizeChartData() {
        guard let wallet = stateController.getSelectedWallet() else {
            return
        }
        
        let transactionDates = wallet.getTransactionDatesBy(dateInterval: selectedTimeRange)
        var transactions = [Transaction]()
        for date in transactionDates {
            guard let transactionsByDate = wallet.allTransactionsGrouped[date] else { return }
            for transaction in transactionsByDate {
                transactions.append(transaction)
            }
        }
        
        let incomeTransactions = Array(transactions.filter({ $0.amount > 0 }))
        let expenseTransactions = Array(transactions.filter({ $0.amount < 0 }))
        
        incomeTransactionsGrouped = Dictionary(grouping: incomeTransactions, by: {
            $0.category!
        })
        expenseTransactionsGrouped = Dictionary(grouping: expenseTransactions, by: {
            $0.category!
        })
        transactionsGroupedByCategories = expenseTransactionsGrouped
        
    }
    
    
   
    
    
   
    

    // MARK: - Navigation

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categoryReport" {
            if let destination = segue.destination as? CategoryReportViewController {
                
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    destination.category = categories[indexPath.row]
                    destination.transactions = transactionsGroupedByCategories[categories[indexPath.row]]
                }
                
            }
        }
    }
    

}

    //MARK: - TableView DataSource and Delegate methods

extension ReportsDetailViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        section == 0 ? 1 : transactionsGroupedByCategories.keys.count
        
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
            
            
            if let name = categories[indexPath.row].name {
                cell.periodNameLabel.text = name
            }
           
            let category = categories[indexPath.row]
            
            cell.amountLabel.text = getAmountByCategory(category).description
            
            if let icon = cell.iconView as? IconView {
                icon.setGradeintForCategory(category: categories[indexPath.row])
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
