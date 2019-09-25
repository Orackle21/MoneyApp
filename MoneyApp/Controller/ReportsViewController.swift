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
    
    var stateController: StateController!
    lazy private var dater = stateController.dater
    lazy private var wallet = stateController.getSelectedWallet()
    
    private var dateStrings = [String]()
    private var amountsByDate = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateChartData()
        updateChart(dataPoints: dateStrings, values: amountsByDate)
        customizeChartLooks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateChartData()
        updateChart(dataPoints: dateStrings, values: amountsByDate)
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
        lineChartView.xAxis.valueFormatter = DayAxisValueFormatter(chart: lineChartView, data: dateStrings)
    }
    
    func updateChartData() {
        let dates = dater.getRelevantTimeRangesFrom(date: Date())
        
        dateStrings = [String]()
        amountsByDate = [Double]()
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
        xAxis.valueFormatter = DayAxisValueFormatter(chart: lineChartView, data: dateStrings)
       
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


//extension ReportsViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//    
//    
//}

public class DayAxisValueFormatter: NSObject, IAxisValueFormatter {
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

