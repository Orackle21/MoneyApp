//
//  ReportsViewController.swift
//  MoneyApp
//
//  Created by Orackle on 31/08/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit
import Charts
import CoreData

class ReportsViewController: UIViewController {
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chartContainer: UIView!
    
    private var actionSheet: UIAlertController?
    @IBAction func chooseTimeInterval(_ sender: Any) {
        prepareAlert()
        self.present(actionSheet!, animated: true, completion: nil)
    }
    
    var coreDataStack: CoreDataStack!
    lazy private var dater = Dater()
    var walletContainer: WalletContainer!
    
    //FIXME: Get selected wallet
    lazy private var wallet = walletContainer.getSelectedWallet()
    
    private var outerIntervals = [DateInterval]()
    private var dateIntervals = [DateInterval: [DateInterval]]()
    private var dateStrings = [String]()
    private var amountsByDate = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateChartData()
        updateChart(dataPoints: dateStrings, values: amountsByDate)
        customizeChartLooks()
    }
    
    func getAmounts() {
        for (_, innerIntervals) in dateIntervals {
            for dateInterval in innerIntervals {
                let result =  sumAmount(dateInterval: dateInterval)
                print (result)
                amountsByDate.append(result.doubleValue)
                let string = dater.dateFormatter.string(from: dateInterval.start)
                dateStrings.append(string)
            }
        }
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        let frameWidth = self.chartContainer.frame.width
        //        let frameHeight = (tableView.superview?.frame.height ?? 0) / 2
        //        let frame = CGRect(x: 0, y: 0, width: frameWidth, height: frameHeight)
        //        chartContainer.frame = frame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateChartData()
        updateChart(dataPoints: dateStrings, values: amountsByDate)
        tableView.reloadData()
        getAmounts()
    }
    
    func updateChart (dataPoints: [String], values: [Double]) {
        
                var dataEntries: [ChartDataEntry] = []
                for i in 0..<dataPoints.count {
                    let dataEntry = ChartDataEntry(x: Double(i), y: Double(values[i]), data: dataPoints[i])
                    dataEntries.append(dataEntry)
                }
        
                let chartDataSet = LineChartDataSet(entries: dataEntries, label: "BarChart")
                customizeChartSet(chartDataSet: chartDataSet)
                let chartData = LineChartData(dataSet: chartDataSet)
        
                lineChartView.data = chartData
                lineChartView.legend.enabled = false
                lineChartView.xAxis.valueFormatter = AxisValueFormatter(chart: lineChartView, data: dateStrings)
    }
    
    private func updateChartData() {
        
        guard let wallet = wallet else { return }
        
        dateIntervals = dater.getReportsIntervals(broad: 3)
        dateStrings = [String]()
        amountsByDate = [Double]()
        
        outerIntervals = dateIntervals.keys.sorted(by: >)
        
        getAmounts()
        
        
    }
    
    
    private func customizeChartLooks() {
        let xAxis = lineChartView.xAxis
        xAxis.axisLineWidth = 1
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        xAxis.forceLabelsEnabled = false
        xAxis.labelFont = UIFont.systemFont(ofSize: 13)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.valueFormatter = AxisValueFormatter(chart: lineChartView, data: dateStrings)
        
        let yAxis = lineChartView.leftAxis
        
        if #available(iOS 13.0, *) {
            xAxis.labelTextColor = UIColor.label
            yAxis.labelTextColor = UIColor.label
        } else {
            yAxis.labelTextColor = UIColor.black
            xAxis.labelTextColor = UIColor.black
        }
        
        lineChartView.zoom(scaleX: 6, scaleY: 0, x: 0, y: 0)
        lineChartView.rightAxis.enabled = false
    }
    
    private func customizeChartSet (chartDataSet: LineChartDataSet) {
        if #available(iOS 13.0, *) {
            chartDataSet.setColor(UIColor.label)
            chartDataSet.valueTextColor = UIColor.label
        } else {
            chartDataSet.setColor(UIColor.black)
            chartDataSet.valueTextColor = UIColor.black
            
        }
        chartDataSet.mode = .cubicBezier
        chartDataSet.lineWidth = 2.5
    }
    
    
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reportsDetail" {
            if let destination = segue.destination as? ReportsDetailViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    
                    let innerArray = dateIntervals[outerIntervals[indexPath.section]]
                    let dateInterval = innerArray![indexPath.row]
                    destination.selectedTimeRange = dateInterval
                    destination.coreDataStack = coreDataStack
                }
            }
        }
        
    }
}

// MARK: - TableView Methods

extension ReportsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //        if dater.daterRange == .days {
        //            return 1
        //        }
        //        else  {
        return outerIntervals.count
        
        //    }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if dater.daterRange == .year {
            return "All Years"
        }
        else {
            let sectionDate = outerIntervals[section]
            return dater.reportsHeaderDateFormatter.string(from: sectionDate.start)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let outerInterval = outerIntervals[section]
        return dateIntervals[outerInterval]?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportsCell", for: indexPath)
        
        if let cell = cell as? ReportsCell {
            guard let _ = wallet else {return cell}
            
            let innerArray = dateIntervals[outerIntervals[indexPath.section]]
            let dateInterval = innerArray![indexPath.row]
            
           
            let index = getAmountIndex(sectionNumber: indexPath.section, rowNumber: indexPath.row)
            let amount = amountsByDate[index]
            
            if amount > 0 {
                cell.iconView.backgroundColor = UIColor.systemGreen
            } else {
                cell.iconView.backgroundColor = UIColor.systemRed
            }
            
            cell.amountLabel.text = amount.description //FIXME: Fix it
            
            if dater.daterRange == .weeks {
                let string = dater.dateFormatter.string(from: dateInterval.start) + " - " + dater.dateFormatter.string(from: dateInterval.end)
                cell.periodNameLabel.text = string
            } else {
                cell.periodNameLabel.text = dater.dateFormatter.string(from: dateInterval.start)
            }
        }
        return cell
    }
    
}

extension ReportsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.systemFont(ofSize: 15)
    }
    
    
}

// MARK: - Chart Axis text customization class

public class AxisValueFormatter: NSObject, IAxisValueFormatter {
    weak var chart: BarLineChartViewBase?
    
    let data: [String]
    
    init(chart: BarLineChartViewBase, data: [String]) {
        self.chart = chart
        self.data = data
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return data[Int(value)]
    }
    
}

extension ReportsViewController {
    
    private func prepareAlert() {
        actionSheet = UIAlertController(title: "Select Time Range", message: "Filter transactions by selected date", preferredStyle: .actionSheet)
        actionSheet!.addAction(UIAlertAction(
            title: "This Week",
            style: .default,
            handler: { _ in
                self.upDater(.days)
        }))
        actionSheet!.addAction(UIAlertAction(
            title: "This Month",
            style: .default,
            handler: { _ in
                self.upDater(.weeks)
        }))
        actionSheet!.addAction(UIAlertAction(
            title: "Last Month",
            style: .default,
            handler: { _ in
                self.upDater(.months)
                
        }))
        actionSheet!.addAction(UIAlertAction(
            title: "Last 6 Months",
            style: .default,
            handler: { _ in
                self.upDater(.year)
        }))
        
        actionSheet!.addAction(UIAlertAction(
                 title: "This Year",
                 style: .default,
                 handler: { _ in
                     self.upDater(.year)
             }))
        
        actionSheet!.addAction(UIAlertAction(
                 title: "Last Year",
                 style: .default,
                 handler: { _ in
                     self.upDater(.year)
             }))
        actionSheet!.addAction(UIAlertAction(
                 title: "All Time",
                 style: .default,
                 handler: { _ in
                     self.upDater(.year)
             }))
        
        actionSheet!.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        ))
        
        
    }
    
    private func upDater(_ daterRange: DaterRange) {
        
        dater.daterRange = daterRange
        updateChartData()
        updateChart(dataPoints: dateStrings, values: amountsByDate)
        tableView.reloadData()
        
    }
    
}


extension ReportsViewController {
    
    func getAmountIndex(sectionNumber: Int, rowNumber: Int) -> Int {
        var result = 0
        
        for number in 0..<sectionNumber {
            let rows = tableView.numberOfRows(inSection: number)
            result += rows
        }
        
        return result + rowNumber
        
    }
    
}

extension ReportsViewController {
    
    func sumAmount(dateInterval: DateInterval) -> Decimal {
        var amountSum : Decimal = 0
        let startDate = NSNumber(value: dateInterval.start.getSimpleDescr())
        let endDate = NSNumber(value: dateInterval.end.getSimpleDescr())

        
        // Fetch Request
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Transaction")
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType

        let predicate = NSPredicate(format: "simpleDate >=  %@ AND simpleDate <  %@ AND wallet == %@", startDate, endDate, wallet! )
        fetchRequest.predicate = predicate

        
        //Exrpession
        let sumExpressionDesc = NSExpressionDescription()
        sumExpressionDesc.name = "sumAmounts"
        
        let specialCountExp =  NSExpression(forKeyPath: #keyPath(Transaction.amount))
        sumExpressionDesc.expression = NSExpression(
            forFunction: "sum:",
            arguments: [specialCountExp])
        sumExpressionDesc.expressionResultType = .decimalAttributeType

        
        fetchRequest.propertiesToFetch = [sumExpressionDesc]

        // Step 3:
        // - Execute the fetch request which returns an array.
        // - There will only be one result. Get the first array
        //   element and assign to 'resultMap'.
        // - The summed amount value is in the dictionary as
        //   'amountTotal'. This will be summed value.

        do {
            let results = try coreDataStack.managedContext.fetch(fetchRequest)
            let resultDict = results.first!
            amountSum = resultDict["sumAmounts"] as! Decimal
        } catch let error as NSError {
            NSLog("Error when summing amounts: \(error.localizedDescription)")
        }

        return amountSum
    }
    
    
    
    
}
