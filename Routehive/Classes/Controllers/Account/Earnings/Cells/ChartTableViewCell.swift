//
//  ChartTableViewCell.swift
//  TT-Driver
//
//  Created by yasir on 19/06/2018.
//  Copyright © 2018 Vizteck. All rights reserved.
//

import UIKit
import Charts

class ChartTableViewCell: UITableViewCell {

    @IBOutlet weak var barChartView: BarChartView!

    override func awakeFromNib() {
        super.awakeFromNib()
//        barChartView.noDataText = "You need to provide data for the chart."
        barChartView.noDataFont = UIFont.appThemeFontWithSize(16)
        
        barChartView.chartDescription?.text = ""
        barChartView.drawGridBackgroundEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.enabled = false
        barChartView.isUserInteractionEnabled = false
        barChartView.xAxis.labelPosition = .bottom
        
        barChartView.xAxis.labelFont = UIFont.appThemeMediumFontWithSize(10)
        barChartView.legend.enabled = false
        //All other additions to this function will go here

        //This must stay at end of function
        barChartView.notifyDataSetChanged()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    class func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> ChartTableViewCell {
        let kChartTableViewCellIdentifier = "kChartTableViewCellIdentifier"
        tableView.register(UINib(nibName: "ChartTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: kChartTableViewCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: kChartTableViewCellIdentifier, for: indexPath) as! ChartTableViewCell
        return cell
    }

    func configureCell(dataSource: WeeklyEarnings, isCurrentWeek: Bool, weekNumber: Int, weekYear: Int) {
        
        if dataSource.weekDayEarnings.count == 7 {
            
            let entry1 = BarChartDataEntry(x: 1, y: Double(dataSource.weekDayEarnings[0].spEarning))
            let entry2 = BarChartDataEntry(x: 2, y: Double(dataSource.weekDayEarnings[1].spEarning))
            let entry3 = BarChartDataEntry(x: 3, y: Double(dataSource.weekDayEarnings[2].spEarning))
            let entry4 = BarChartDataEntry(x: 4, y: Double(dataSource.weekDayEarnings[3].spEarning))
            let entry5 = BarChartDataEntry(x: 5, y: Double(dataSource.weekDayEarnings[4].spEarning))
            let entry6 = BarChartDataEntry(x: 6, y: Double(dataSource.weekDayEarnings[5].spEarning))
            let entry7 = BarChartDataEntry(x: 7, y: Double(dataSource.weekDayEarnings[6].spEarning))

            let dataSet = BarChartDataSet(values: [entry1, entry2, entry3, entry4, entry5, entry6, entry7], label: nil)

            // get current week number
            
            let weekDay = Date().weekday

            dataSet.colors = [#colorLiteral(red: 0.9882352941, green: 0.8784313725, blue: 0.8823529412, alpha: 1), #colorLiteral(red: 0.9882352941, green: 0.8784313725, blue: 0.8823529412, alpha: 1), #colorLiteral(red: 0.9882352941, green: 0.8784313725, blue: 0.8823529412, alpha: 1), #colorLiteral(red: 0.9882352941, green: 0.8784313725, blue: 0.8823529412, alpha: 1), #colorLiteral(red: 0.9882352941, green: 0.8784313725, blue: 0.8823529412, alpha: 1), #colorLiteral(red: 0.9882352941, green: 0.8784313725, blue: 0.8823529412, alpha: 1), #colorLiteral(red: 0.9882352941, green: 0.8784313725, blue: 0.8823529412, alpha: 1)]
            dataSet.valueFont = UIFont.appThemeMediumFontWithSize(10)
            
            if isCurrentWeek {
                var index = weekDay-2
                if index < 0 {index = 0}
                dataSet.colors[index] = #colorLiteral(red: 0.8431372549, green: 0, blue: 0.03921568627, alpha: 1)
            }

            var months = [String]()
            
            // Initialize Date components
            let c = NSDateComponents()
            c.year = weekYear
            c.weekOfYear = weekNumber
            c.weekday = dataSource.weekDayEarnings[0].day

            
            let dateFormatter = DateFormatter()
            
            
            for day in dataSource.weekDayEarnings {
                c.weekday = day.day+1
                let datee = NSCalendar(identifier: NSCalendar.Identifier.ISO8601)?.date(from: c as DateComponents)
                print(datee!)
                dateFormatter.dateFormat = "LLL"
                let nameOfMonth = dateFormatter.string(from: datee!)
                
                dateFormatter.dateFormat = "dd"
                months.append("\(dateFormatter.string(from: datee!))\n\(nameOfMonth.uppercased())")
            }
            
            let data = BarChartData(dataSets: [dataSet])

            let chartFormatter = BarChartFormatter(labels: months)
            let xAxis = XAxis()
            xAxis.valueFormatter = chartFormatter
            barChartView.xAxis.valueFormatter = xAxis.valueFormatter
            barChartView.data = data
            barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInCubic )
        }
    }
}

class BarChartFormatter: NSObject, IAxisValueFormatter {

    var labels: [String] = []

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return labels[Int(value)-1]
    }

    init(labels: [String]) {
        super.init()
        self.labels = labels
    }
}

extension BarChartView {

    func setBarChartData(xValues: [String], yValues: [Double], label: String) {

        var dataEntries: [BarChartDataEntry] = []

        for i in 0..<yValues.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: yValues[i])
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(values: dataEntries, label: label)
        let chartData = BarChartData(dataSet: chartDataSet)

        let chartFormatter = BarChartFormatter(labels: xValues)
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        self.xAxis.valueFormatter = xAxis.valueFormatter

        self.data = chartData
    }
}
