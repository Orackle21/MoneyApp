//
//  ReportsViewController.swift
//  MoneyApp
//
//  Created by Orackle on 31/08/2019.
//  Copyright © 2019 Orackle. All rights reserved.
//

import UIKit
import AAInfographics

class ReportsViewController: UIViewController {

    var stateController: StateController!
    lazy var dater = stateController.dater

    override func viewDidLoad() {
        super.viewDidLoad()
        let dates = dater.getRelevantTimeRangesFrom(date: Date())
        var dateNames = [String]()
        var dateIntervals = [DateInterval]()
        var totalByMonth = [Decimal]()
        
        for date in dates {
            dateNames.append(date.description(with: Locale.current))
        }
        
        for date in dates {
            dateIntervals.append(dater.getTimeIntervalFor(date: date))
        }
        
        for dateInterval in dateIntervals {
            totalByMonth.append(stateController.getSelectedWallet()?.getTotalByInterval(dateInterval: dateInterval) ?? 0.00)
        }
        
        
        let aaChartView = AAChartView()
        let chartViewWidth  = self.view.frame.size.width
        let chartViewHeight = self.view.frame.size.height
        aaChartView.frame = CGRect(x:0,y:0,width:chartViewWidth,height:chartViewHeight)
        // set the content height of aachartView
        // aaChartView?.contentHeight = self.view.frame.size.height
        aaChartView.contentMode = .redraw
        self.view.addSubview(aaChartView)
        
        
        
        let aaChartModel = AAChartModel()
            .chartType(.spline)//Can be any of the chart types listed under `AAChartType`.
            .animationType(.easeInCubic)
            .title("Graph")//The chart title
            .subtitle("subtitle")//The chart subtitle
            .dataLabelsEnabled(false) //Enable or disable the data labels. Defaults to false
            .tooltipValueSuffix("USD")//the value suffix of the chart tooltip
            .categories(dateNames)
            .colorsTheme(["#fe117c","#ffc069","#06caf4","#7dffc0"])
            .series([
                AASeriesElement()
                    .name("Wallet")
                    .data(totalByMonth)
                ])
        aaChartView.aa_drawChartWithChartModel(aaChartModel)
        aaChartView.aa_drawChartWithChartModel(aaChartModel)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
