//
//  InfoCardView.swift
//  Solid News
//
//  Created by Fan Zhang on 11/6/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import SwiftUI

struct InfoCardView: View {
    
    var covidData: CovidDataModel
    
    @State var loadingPeriod: LoadingPeriod = LoadingPeriod.week
    @State var dataCategory: DataCategory = DataCategory.cases
    @State var cumulativeOrNew: CumulativeOrNew = CumulativeOrNew.new
    @State var logOrValue: LogOrValue = LogOrValue.value
    @State var casesOnPropmt: String = "_"
    @State var dayOnPropmt: String = "_"
    @State var compactMode: Bool = false
    
    @AppStorage("defaultLang") var defaultLang: String?
    var localeIdentifier: String {
        defaultLang!.replacingOccurrences(of: "-", with: "_")
    }
    
    var period: String {
        switch loadingPeriod {
        case .week: return "in the past week"
        case .month: return "in the past month"
        case .threeMonth: return "in the past three months"
        }
    }
    
    var days: Int {
        switch loadingPeriod {
        case .week: return 7
        case .month: return 30
        case .threeMonth: return 90
        }
    }
    
    var sum: Int {
        covidData.cases![CovidDataModel.dataLength-1] - covidData.cases![CovidDataModel.dataLength-days]
    }
    
    var title: String {
        switch dataCategory {
        case .cases: return "Cases"
        case .deaths: return "Deaths"
        case .recovered: return "Recovered"
        }
    }
    
    var buttonCallback: () -> Void = {}
    
    func updatePrompt(num: Double?=nil, day: Double?=nil) {
        if let safe_num = num, let safe_day = day {
            var digitsLength = 2
            if safe_num - (Double (Int (safe_num))) == 0 {
                digitsLength = 0
            }
            casesOnPropmt = String(format: "%.\(digitsLength)f", safe_num)
            let today = Date()
            let modifiedDate = Calendar.current.date(byAdding: .day, value: -days + Int (safe_day), to: today)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: localeIdentifier)
            dayOnPropmt = dateFormatter.string(from: modifiedDate)
            return
        }
        casesOnPropmt = String(sum)
        dayOnPropmt = period
    }
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(covidData.name ?? "Name unavailable")
//                    .font(.system(size: 24))
//                    .fontWeight(.medium)
                    .font(.system(size: 20))
                    .fontWeight(.regular)
                    .padding(.bottom, 4)
                Spacer()
                Button(action: {
                    withAnimation {
                        buttonCallback()
                    }
                }) {
                    Text("Discard")
                        .font(.system(size: 16))
                }
            }
            
            if !compactMode {
                HStack(spacing: 0) {
                    Text(casesOnPropmt)
                        .font(.system(size: 14))
                        .fontWeight(.regular)
                    Text(", ")
                        .font(.system(size: 14))
                        .fontWeight(.regular)
                    Text(LocalizedStringKey(dayOnPropmt))
                        .font(.system(size: 14))
                        .fontWeight(.regular)
                }
                
                    .padding(.bottom, 6)
                Picker(selection: $dataCategory, label: Text("Data Category")) {
                    Text("Cases").tag(DataCategory.cases)
                    Text("Deaths").tag(DataCategory.deaths)
                    if covidData.hasRecoveredData() {
                        Text("Recovered").tag(DataCategory.recovered)
                    }
                }
                
                .pickerStyle(SegmentedPickerStyle())
            }
            
            ChartView(
                covidData: covidData,
                loadingPeriod: $loadingPeriod,
                dataCategory: $dataCategory,
                cumulativeOrNew: $cumulativeOrNew,
                logOrValue: $logOrValue,
                updatePrompt: updatePrompt
            )
            .frame(height: compactMode ? 75 : 100)
            .onAppear {
                updatePrompt(num: nil, day: nil)
            }
            
            if !compactMode {
                HStack {
                    Picker(selection: $cumulativeOrNew, label: Text("X-Axis")) {
                        Text("New").tag(CumulativeOrNew.new)
                        Text("Cumulative").tag(CumulativeOrNew.cumulative)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.bottom, 2)
                    Picker(selection: $logOrValue, label: Text("Y-Axis")) {
                        Text("Value").tag(LogOrValue.value)
                        Text("Log").tag(LogOrValue.log)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Picker(selection: $loadingPeriod, label: Text("Loading Period")) {
                    Text("One Week").tag(LoadingPeriod.week)
                    Text("One Month").tag(LoadingPeriod.month)
                    Text("Three Months").tag(LoadingPeriod.threeMonth)
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: loadingPeriod, perform: { _ in
                    updatePrompt(num: nil, day: nil)
                })
            }
        }
        .padding()
    }
}

struct InfoCardView_Previews: PreviewProvider {
    static var previews: some View {
        InfoCardView(covidData: CovidDataModel.defaultCovidData())
            .previewDevice("iPhone 12")
    }
}

enum LoadingPeriod {
    case week, month, threeMonth
}

enum DataCategory {
    case cases, deaths, recovered
}

enum CumulativeOrNew {
    case cumulative, new
}

enum LogOrValue {
    case log, value
}

