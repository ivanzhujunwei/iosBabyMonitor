//
//  ShinobiChartController.swift
//  babyMonitor
//
//  Created by zjw on 5/11/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit

// This controller is displaying the pie chart
class ShinobiChartController: UIViewController, SChartDatasource, SChartDelegate {

    @IBOutlet weak var chart: ShinobiChart!
    // baby activities analysised
    var babyActivities : [BabyActivity]!
    // the pie chart data which is going to be used
    var pieChartData : Dictionary<String, Int>!
    // baby name
    var babyName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        chart.licenseKey = "Z+jYC/4kVdposDWMjAxNjEyMDNpdmFuemh1anVud2VpQGdtYWlsLmNvbQ==Jd5W/nO+Sx4l3ZLkwysnQGV4kgqDmVb2tckKIonNWa68DwKsd1evEwrn3LjP1RahZTLqwelbmAvM4ovdlvLiCPNucAtFz2I0CqkIR8ymy/wTLjTztswPkGO78t7p9P851Bp532vllqQ46GtIkzQl3s7W5+8w=AXR/y+mxbZFM+Bz4HYAHkrZ/ekxdI/4Aa6DClSrE4o73czce7pcia/eHXffSfX9gssIRwBWEPX9e+kKts4mY6zZWsReM+aaVF0BL6G9Vj2249wYEThll6JQdqaKda41AwAbZXwcssavcgnaHc3rxWNBjJDOk6Cd78fr/LwdW8q7gmlj4risUXPJV0h7d21jO1gzaaFCPlp5G8l05UUe2qe7rKbarpjoddMoXrpErC9j8Lm5Oj7XKbmciqAKap+71+9DGNE2sBC+sY4V/arvEthfhk52vzLe3kmSOsvg5q+DQG/W9WbgZTmlMdWHY2B2nbgm3yZB7jFCiXH/KfzyE1A==PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+" // TODO: Insert Trial license key here
        
        // This view controller will provide the data points to the chart
        chart.datasource = self
        // Set this controller to be the chart's delegate in order to respond to touches on a pie segment
        chart.delegate = self

        // Do any additional setup after loading the view.
//        pieChartData = Dictionary<String, Int>()
        chart.legend.hidden = UIDevice.currentDevice().userInterfaceIdiom == .Phone
        
        var monitorTime = 0
        var startTime:NSDate!
        var endTime:NSDate!
        
        // Generating the title name based on the time
        for i in 0 ..< babyActivities.count {
            let activity = babyActivities[i]
            // Count the monitoring time
            if activity.type == BabyActityType.START.rawValue{
                startTime = activity.date!
            }
            if activity.type == BabyActityType.END.rawValue{
                endTime = activity.date!
                monitorTime = monitorTime + minutesFromTwoDate(startTime, newDate: endTime)
            }
            if i == babyActivities.count - 1 && activity.type != BabyActityType.END.rawValue{
                let currentDate = NSDate()
                monitorTime = monitorTime + minutesFromTwoDate(startTime, newDate: currentDate)
            }
            var monitorTimeText = ""
            if monitorTime < 60 {
                monitorTimeText = "\(monitorTime) miniutes"
            }else if monitorTime < 60*24 {
                monitorTimeText = "\(monitorTime/60) hours"
            }else {
                monitorTimeText = "\(monitorTime/60/24) days"
            }
            chart.title = "\(babyName) activity analysis in \(monitorTimeText)"
            
            // Initialise the pieChartData
//            if activity.type != BabyActityType.START.rawValue && activity.type != BabyActityType.END.rawValue
//            {
//                let key = activity.type!
//                if  pieChartData.indexForKey(key) == nil {
//                    pieChartData.updateValue(1, forKey: key)
//                }else{
//                    let v = pieChartData![key]! + 1
//                    pieChartData.updateValue(v, forKey: key)
//                }
//            }
            
            
            
        }
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc(numberOfSeriesInSChart:)
    func numberOfSeries(in chart: ShinobiChart) -> Int {
        return 1
    }
    
    func sChart(chart: ShinobiChart, seriesAtIndex index: Int) -> SChartSeries {
        let series = SChartPieSeries()
        // Set series font
        series.style().labelFont = UIFont.systemFontOfSize(20)
        // Set the distance for selected series
        series.selectedStyle().protrusion = 20
        series.gesturePanningEnabled = true
        return series
    }
    
    // How many objects in the data needed to be analysised
    func sChart(chart: ShinobiChart, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
        return pieChartData.count
    }
    
    func sChart(chart: ShinobiChart, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData {
        // Get the key of pieChartData at particular index
        let key = Array(pieChartData.keys)[dataIndex]
        let datapoint = SChartRadialDataPoint()
        datapoint.name = key
        print(Int(pieChartData[key]!))
        datapoint.value = Int(pieChartData[key]!)
        return datapoint
    }
    
    func sChart(chart: ShinobiChart, alter label: UILabel, for datapoint: SChartRadialDataPoint, atSlice index: Int, in series: SChartRadialSeries) {
        label.text = datapoint.name
    }
    
    func sChart(chart: ShinobiChart, labelForSliceAtIndex sliceIndex: Int, inRadialSeries series: SChartRadialSeries) -> UILabel? {
        let key = Array(pieChartData.keys)[sliceIndex]
        let label = UILabel()
        let count = Int(pieChartData[key]!)
        switch key {
        case BabyActityType.COLD.rawValue:
            label.text = "Felt cold / "
            break
        case BabyActityType.WET.rawValue:
            label.text = "Diaper wet / "
            break
        case BabyActityType.OUTOFSIGHT.rawValue:
            label.text = "OutOfSight / "
            break
        case BabyActityType.CRY.rawValue:
            label.text = "Cried / "
            break
        default:
            label.text = "Unknown / "
        }
        label.text = label.text! + String(count)
        label.font = UIFont.systemFontOfSize(10)
        return label
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
