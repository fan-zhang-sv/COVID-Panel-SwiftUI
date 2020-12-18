//
//  DeathsAndChartView.swift
//  COVID Panel
//
//  Created by Fan Zhang on 11/21/20.
//

import SwiftUI

struct DeathsAndChartView: View {
    @Binding var covidData: CovidDataModel
    
    @AppStorage("defaultLang") var defaultLang: String?
    var localeIdentifier: String {
        defaultLang!.replacingOccurrences(of: "-", with: "_")
    }
    
    @State var today: String = "_"
    
    @State var loadingPeriod: LoadingPeriod = LoadingPeriod.month
    @State var cumulativeOrNew: CumulativeOrNew = CumulativeOrNew.new
    @State var logOrValue: LogOrValue = LogOrValue.value
    
    @State var total: String = "N/A"
    @State var new: String = "N/A"
    @State var fatality: String = "N/A"
    
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
    
    func updateView(num: Double?=nil, day: Double?=nil) {
        
        if let _ = num, let safe_day = day {
            let modifiedDate = Calendar.current.date(byAdding: .day, value: -days + Int (safe_day), to: Date())!
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: localeIdentifier)
            today = dateFormatter.string(from: modifiedDate)
            
            total = String(covidData.getTodayDeaths(offset: days-Int(safe_day)))
            new = String(covidData.getTodayNewDeath(offset: days-Int(safe_day)))
            fatality = covidData.getFatality(offset: days-Int(safe_day))
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: localeIdentifier)
        today = dateFormatter.string(from: Date())
        
        total = String(covidData.getTodayDeaths())
        new = String(covidData.getTodayNewDeath())
        fatality = covidData.getFatality()
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Deaths")
                        .font(.system(size: 32, weight: .black))
                        .foregroundColor(Color("deathsColor"))
//                    Divider()
//                        .padding(.vertical, 3)
                    Text(today)
                        .font(.system(size: 18, weight: .black))
//                        .foregroundColor(Color("deathsColor"))
//                        .font(.subheadline)
                    
                }
                .padding(.bottom, 25)
                
                HStack {
                    VStack {
                        HStack {
                            Text("Total")
                                .font(.system(size: 14))
                                .fontWeight(.light)
                            Spacer()
                            Text(total)
                                .font(.system(size: 14))
                                .fontWeight(.light)
                        }
                        Rectangle()
                            .foregroundColor(Color("deathsColor"))
                            .frame(height: 2)
                    }
                    VStack {
                        HStack {
                            Text("New")
                                .font(.system(size: 14))
                                .fontWeight(.light)
                            Spacer()
                            Text(new)
                                .font(.system(size: 14))
                                .fontWeight(.light)
                        }
                        Rectangle()
                            .foregroundColor(Color("deathsColor"))
                            .frame(height: 2)
                    }
                    
                }
                HStack {
                    VStack {
                        HStack {
                            Text("Fatality")
                                .font(.system(size: 14))
                                .fontWeight(.light)
                            Spacer()
                            Text(fatality)
                                .font(.system(size: 14))
                                .fontWeight(.light)
                        }
                        Rectangle()
                            .foregroundColor(Color("deathsColor"))
                            .frame(height: 2)
                    }
                    Spacer()
                }
                
                ChartView(
                    covidData: covidData,
                    loadingPeriod: $loadingPeriod,
                    dataCategory: .constant(.deaths),
                    cumulativeOrNew: $cumulativeOrNew,
                    logOrValue: $logOrValue,
                    updatePrompt: updateView
                )
                .frame(height: 100)
                .padding(.top, 30)
                .padding(.bottom, 27)
                .onAppear {
                    updateView()
                }
                
                HStack {
                    Picker(selection: $cumulativeOrNew, label: Text("X-Axis")) {
                        Text("New").tag(CumulativeOrNew.new)
                        Text("Cumulative").tag(CumulativeOrNew.cumulative)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    Picker(selection: $logOrValue, label: Text("Y-Axis")) {
                        Text("Value").tag(LogOrValue.value)
                        Text("Log").tag(LogOrValue.log)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.bottom, 8)
                
                Picker(selection: $loadingPeriod, label: Text("Loading Period")) {
                    Text("One Week").tag(LoadingPeriod.week)
                    Text("One Month").tag(LoadingPeriod.month)
                    Text("Three Months").tag(LoadingPeriod.threeMonth)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.vertical)
            
            Divider()
            
            HStack {
                Text("Data updated on:")
                Text(today)
            }.font(.footnote)
            .foregroundColor(.gray)
            .padding(.bottom, 20)
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color(.systemBackground),Color(.systemBackground), Color(.systemGray6)]), startPoint: .top, endPoint: .bottom))
        
    }
}


struct DeathsAndChartView_Previews: PreviewProvider {
    static var previews: some View {
        DeathsAndChartView(covidData: .constant(CovidDataModel.defaultCovidData()))
    }
}
