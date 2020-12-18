//
//  PlaceDetailView.swift
//  COVID Panel
//
//  Created by Fan Zhang on 11/20/20.
//

import SwiftUI

struct PlaceDetailView: View {
    
    @State var covidData: CovidDataModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Spacer()
                }
                
                HStack {
                    VStack {
                        HStack {
                            Text("Cases")
                                .font(.system(size: 14))
                                .fontWeight(.light)
                                .lineLimit(1)
                            Spacer()
                            Text("\(covidData.getTodayCases())")
                                .font(.system(size: 14))
                                .fontWeight(.light)
                                .lineLimit(1)
                        }
                        Rectangle()
                            .foregroundColor(Color("casesColor"))
                            .frame(height: 2)
                    }
                    VStack {
                        HStack {
                            Text("Deaths")
                                .font(.system(size: 14))
                                .fontWeight(.light)
                                .lineLimit(1)
                            Spacer()
                            Text("\(covidData.getTodayDeaths())")
                                .font(.system(size: 14))
                                .fontWeight(.light)
                                .lineLimit(1)
                        }
                        Rectangle()
                            .foregroundColor(Color("deathsColor"))
                            .frame(height: 2)
                    }
                    VStack {
                        HStack {
                            Text("Recovered")
                                .font(.system(size: 14))
                                .fontWeight(.light)
                                .lineLimit(1)
                            Spacer()
                            if covidData.hasRecoveredData() {
                                Text("\(covidData.getTodayRecovered()!)")
                                    .font(.system(size: 14))
                                    .fontWeight(.light)
                                    .lineLimit(1)
                            } else {
                                Text("N/A")
                                    .font(.system(size: 14))
                                    .fontWeight(.light)
                                    .lineLimit(1)
                            }
                        }
                        Rectangle()
                            .foregroundColor(Color("recoveredColor"))
                            .frame(height: 2)
                    }
                }
                .padding(.top, 32)
                .padding(.horizontal)
                .background(Color(UIColor.systemBackground))
                
                
                CasesAndChartView(covidData: $covidData)
                
                DeathsAndChartView(covidData: $covidData)
                
                if covidData.hasRecoveredData() {
                    RecoveredAndChartView(covidData: $covidData)
                }
                
                if Array(Languages.countryToMkt.keys).contains(covidData.country!) {
                    NewsView(placeName: covidData.name!, country: covidData.country!)
                }
            }
        }
        .background(Color(UIColor.systemBackground))
    }
}

struct PlaceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetailView(covidData: CovidDataModel.defaultCovidData())
    }
}

