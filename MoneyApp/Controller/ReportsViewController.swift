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

    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var barChartView: LineChartView!
    
    var stateController: StateController!
    lazy private var dater = stateController.dater
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let players = ["Ozil", "Ramsey", "Laca", "Auba", "Xhaka", "Torreira", "Xhaka", "Torreira"]
        let goals = [6, 8, 26, 30, 8, 10, 15, 16]
        
        customizeChart(dataPoints: players, values: goals.map{ Double($0) })
        customizeLineChart(dataPoints: players, values: goals.map{ Double($0) })
        
    }
    
    
    func customizeLineChart (dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(values[i]), data: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        
        let xAxis = barChartView.xAxis
        xAxis.axisLineWidth = 1
        xAxis.labelPosition = .bottom
        xAxis.labelRotationAngle = CGFloat(-50)
        xAxis.labelRotatedHeight = CGFloat(120)
        xAxis.drawGridLinesEnabled = false
        xAxis.forceLabelsEnabled = false
        xAxis.labelTextColor = UIColor.black
        xAxis.labelFont = UIFont.systemFont(ofSize: 13)
        xAxis.granularity = 1
        xAxis.labelCount = dataPoints.count
        xAxis.valueFormatter = DayAxisValueFormatter(chart: barChartView, data: [Date()])
        

        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "BarChart")
        
        let chartData = LineChartData(dataSet: chartDataSet)
        
        barChartView.data = chartData
        
    
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        // 4. Assign it to the chart’s data
        pieChartView.data = pieChartData
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


public class DayAxisValueFormatter: NSObject, IAxisValueFormatter {
    weak var chart: BarLineChartViewBase?
   
    init(chart: BarLineChartViewBase, data: [Date]) {
        self.chart = chart
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "nigga"
        }
    
    }

