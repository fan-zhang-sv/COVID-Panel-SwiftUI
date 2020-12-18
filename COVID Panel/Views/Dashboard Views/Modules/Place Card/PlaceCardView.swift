//
//  PlaceCardView.swift
//  Solid News
//
//  Created by Fan Zhang on 7/13/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import SwiftUI
//import URLImage

struct PlaceCardView: View {
    
    @AppStorage("defaultLang") var defaultLang: String?
    var covidData: CovidDataModel
    @Environment(\.appColor) var appColor
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(covidData.name ?? "Name Not Available")
                                .font(.system(size: 20))
                                .fontWeight(.regular)
                                .padding(.bottom, 6)
                            
                            HStack {
                                Text("Daily Growth Rate")
                                    .font(.system(size: 14))
                                    .fontWeight(.light)
                                Text(covidData.getDailyGrowthRate())
                                    .font(.system(size: 14))
                                    .fontWeight(.regular)
                            }
                            
                            HStack {
                                Text("14 Days Growth Rate")
                                    .font(.system(size: 14))
                                    .fontWeight(.light)
                                Text(covidData.get14DaysGrowthRate())
                                    .font(.system(size: 14))
                                    .fontWeight(.regular)
                            }
                            
                            HStack {
                                Text("Fatality")
                                    .font(.system(size: 14))
                                    .fontWeight(.light)
                                Text(covidData.getFatality())
                                    .font(.system(size: 14))
                                    .fontWeight(.regular)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("\(covidData.getTodayCases())")
                            .font(.system(size: 28))
                            .fontWeight(.light)
                        Text("in total")
                            .font(.system(size: 12))
                            .fontWeight(.light)
                        Text("\(covidData.getTodayNewCases())")
                            .font(.system(size: 22))
                            .fontWeight(.light)
                        Text("new cases")
                            .font(.system(size: 12))
                            .fontWeight(.light)
                    }
                }
                .padding(.bottom, 3)
                
                HStack {
                    VStack {
                        HStack {
                            Text("Cases")
                                .font(.system(size: 12))
                                .fontWeight(.light)
                                .lineLimit(1)
                            Spacer()
                            Text("\(covidData.getTodayCases())")
                                .font(.system(size: 12))
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
                                .font(.system(size: 12))
                                .fontWeight(.light)
                                .lineLimit(1)
                            Spacer()
                            Text("\(covidData.getTodayDeaths())")
                                .font(.system(size: 12))
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
                                .font(.system(size: 12))
                                .fontWeight(.light)
                                .lineLimit(1)
                            Spacer()
                            if covidData.hasRecoveredData() && covidData.recovered?.count == CovidDataModel.dataLength {
                                Text("\(covidData.getTodayRecovered()!)")
                                    .font(.system(size: 12))
                                    .fontWeight(.light)
                                    .lineLimit(1)
                            } else {
                                Text("N/A")
                                    .font(.system(size: 12))
                                    .fontWeight(.light)
                                    .lineLimit(1)
                            }
                        }
                        Rectangle()
                            .foregroundColor(Color("recoveredColor"))
                            .frame(height: 2)
                    }
                }
                
            }
            .padding()
        }
        .placeCardStyle()
    }
}

struct PlaceCardView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceCardView(covidData: CovidDataModel.defaultCovidData())
            .padding()
            .previewDevice("iPhone 12")
    }
}
