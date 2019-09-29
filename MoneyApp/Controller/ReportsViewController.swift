//
//  ReportsViewController.swift
//  MoneyApp
//
//  Created by Orackle on 31/08/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit
import Charts

class ReportsViewController: UIViewController {
   
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chartContainer: UIView!
    
    var stateController: StateController!
    lazy private var dater = stateController.dater
    lazy private var wallet = stateController.getSelectedWallet()
    
    private var dates = [Date]()
    private var dateStrings = [String]()
    private var amountsByDate = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateChartData()
        updateChart(dataPoints: dateStrings, values: amountsByDate)
        customizeChartLooks()
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
    
    func updateChartData() {
        dates = dater.getRelevantTimeRangesFrom(date: Date())
        
        dateStrings = [String]()
        amountsByDate = [Double]()
        wallet = stateController.getSelectedWallet()
        if let wallet = wallet  {
            for date in dates {
                let sumByDate = wallet.getTotalByIntervalNoSort(dateInterval: dater.getTimeIntervalFor(date: date))
                amountsByDate.append(sumByDate.doubleValue)
            }
        }
        
        for date in dates {
            let string = dater.dateFormatter.string(from: date)
            dateStrings.append(string)
        }
    }
    

    func customizeChartLooks() {
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
    
    func customizeChartSet (chartDataSet: LineChartDataSet) {
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
                    
                    let date = dates[indexPath.row]
                    destination.selectedTimeRange = date
                    destination.stateController = stateController
                }
            }
        }
        
    }
}

    // MARK: - TableView Methods

extension ReportsViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return amountsByDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportsCell", for: indexPath)
        
        if let cell = cell as? ReportsCell {
            
            let amount = amountsByDate[indexPath.row]
            if amount > 0 {
                cell.iconView.backgroundColor = UIColor.systemGreen
            } else {
                cell.iconView.backgroundColor = UIColor.systemRed

            }
            
            cell.amountLabel.text = String(amountsByDate[indexPath.row])
            cell.periodNameLabel.text = dateStrings[indexPath.row]
        }
        return cell
    }
    
    
}

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

