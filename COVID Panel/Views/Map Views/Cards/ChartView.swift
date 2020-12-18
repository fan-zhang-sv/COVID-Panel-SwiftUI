//
//  ChartView.swift
//  Solid News
//
//  Created by Fan Zhang on 11/7/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import SwiftUI
import Charts

struct ChartView: UIViewRepresentable {
    
    var covidData: CovidDataModel
    
    @Binding var loadingPeriod: LoadingPeriod
    @Binding var dataCategory: DataCategory
    @Binding var cumulativeOrNew: CumulativeOrNew
    @Binding var logOrValue: LogOrValue
    
    var updatePrompt: (Double?,Double?) -> Void
    
    let chartView = BarChartView()
    
    var title: String {
        switch dataCategory {
        case .cases: return "Cases"
        case .deaths: return "Deaths"
        case .recovered: return "Recovered"
        }
    }
    
    var barColor: NSUIColor {
        switch dataCategory {
        case .cases: return NSUIColor(red: 233/255.0, green: 71/255.0, blue: 93/255.0, alpha: 1.0)
        case .deaths: return NSUIColor(red: 240/255.0, green: 145/255.0, blue: 53/255.0, alpha: 1.0)
        case .recovered: return NSUIColor(red: 118/255.0, green: 189/255.0, blue: 144/255.0, alpha: 1.0)
        }
    }
    
    func makeYValues() -> [BarChartDataEntry] {
        var quantity = 0
        if loadingPeriod == .week {
            quantity = 7
        } else if loadingPeriod == .month {
            quantity = 30
        } else if loadingPeriod == .threeMonth {
            quantity = 90
        }
        
        var yValues: [BarChartDataEntry] = []
        if dataCategory == .cases, let safe_cases = covidData.cases  {
            for (idx, num) in safe_cases[(CovidDataModel.dataLength-quantity)...].enumerated() {
                var yValue = Double(num)
                let lastValue = Double(safe_cases[CovidDataModel.dataLength-quantity-1+idx])
                if cumulativeOrNew == .new {
                    yValue = yValue - lastValue
                }
                if logOrValue == .log {
                    yValue = yValue != 0 ? log10(yValue) : 0
                }
                
                yValues.append(BarChartDataEntry(x: Double(idx), y: yValue))
            }
        } else if dataCategory == .deaths, let safe_deaths = covidData.deaths {
            for (idx, num) in safe_deaths[(CovidDataModel.dataLength-quantity)...].enumerated() {
                var yValue = Double(num)
                let lastValue = Double(safe_deaths[CovidDataModel.dataLength-quantity-1+idx])
                if cumulativeOrNew == .new {
                    yValue = yValue - lastValue
                }
                if logOrValue == .log {
                    yValue = yValue != 0 ? log10(yValue) : 0
                }
                yValues.append(BarChartDataEntry(x: Double(idx), y: yValue))
            }
        } else if let safe_recovered = covidData.recovered {
            for (idx, num) in safe_recovered[(CovidDataModel.dataLength-quantity)...].enumerated() {
                var yValue = Double(num)
                let lastValue = Double(safe_recovered[CovidDataModel.dataLength-quantity-1+idx])
                if cumulativeOrNew == .new {
                    yValue = yValue - lastValue
                }
                if logOrValue == .log {
                    yValue = yValue != 0 ? log10(yValue) : 0
                }
                yValues.append(BarChartDataEntry(x: Double(idx), y: yValue))
            }
        }
        return yValues
    }
    
    func makeUIView(context: Context) -> BarChartView {
        chartView.backgroundColor = .clear
        chartView.noDataText = "No Data Available"
        chartView.animate(xAxisDuration: 1.6)
        chartView.drawGridBackgroundEnabled = false
        chartView.doubleTapToZoomEnabled = false
        

        return chartView
    }
    
    func updateUIView(_ chartView: BarChartView, context: Context) {
        
        let set = BarChartDataSet(entries: makeYValues(), label: title)
        set.form = .line
        set.drawValuesEnabled = false
        if loadingPeriod == .week {
            set.drawValuesEnabled = true
        }
        
        let color = barColor
        set.setColor(color)
        let data = BarChartData(dataSet: set)
//        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        chartView.data = data
    }
    
    func makeCoordinator() -> Coordinator {
        let co = Coordinator(owner: self)
        chartView.delegate = co
        return co
    }
    
}

extension ChartView {
    
    class Coordinator: NSObject, ChartViewDelegate {
        let owner: ChartView
        
        init(owner: ChartView) {
            self.owner = owner
        }
        
        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
            owner.updatePrompt(entry.y, entry.x)
        }
        
        func chartValueNothingSelected(_ chartView: ChartViewBase) {
            owner.updatePrompt(nil, nil)
        }
    
    }
    
}


struct ChartView_Previews_Wrapper: View {
    
    @State var loadingPeriod: LoadingPeriod = LoadingPeriod.week
    @State var dataCategory: DataCategory = DataCategory.cases
    @State var cumulativeOrNew: CumulativeOrNew = CumulativeOrNew.new
    @State var logOrValue: LogOrValue = LogOrValue.value
    
    var body: some View {
        ChartView(covidData: CovidDataModel.defaultCovidData(), loadingPeriod: $loadingPeriod, dataCategory: $dataCategory, cumulativeOrNew: $cumulativeOrNew, logOrValue: $logOrValue, updatePrompt: {_, _ in})
            .frame(height: 100)
    }
    
}


struct ChartView_Previews: PreviewProvider {
    
    static var previews: some View {
        ChartView_Previews_Wrapper()
    }
}
