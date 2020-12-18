//
//  LocateButton.swift
//  Solid News
//
//  Created by Fan Zhang on 11/7/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import SwiftUI

struct LocateButton: View {
    var locateUser: () -> Void = {}
    @State var showPrompt: Bool = true
    @Binding var mapDotMode: MapDotWeight?
    @State var showingAlert: Bool = false
    let alertTitle = "Data is normalized."
    let alertMessage = "For a better visualization, the data for total cases and total deaths have been normalized, by doing natural logrithm operation on datapoints that are over a threshold, with those under showing linearly."
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if showPrompt {
                HStack(alignment: .center, spacing: 4) {
                    Text("Long press anywhere to show detail.")
                        .font(.caption)
                    Button(action: { withAnimation { showPrompt = false } }) {
                        Text("Dismiss")
                            .font(.caption)
                    }
                }
                .mapButtonStyle()
                .padding(.leading, 8)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 15.0, execute: {
                        withAnimation {
                            showPrompt = false
                        }
                    })
                }
            }
            Spacer()
            VStack(spacing: 4) {
                Menu {
                    Section {
                        Button(action: {
                            mapDotMode = MapDotWeight.todayCases
                        }) {
                            HStack {
                                Text("Today's cases")
                                Spacer()
                                if mapDotMode == MapDotWeight.todayCases {
                                    Image(systemName: "checkmark")
                                        .imageScale(.small)
                                }
                            }
                        }
                        Button(action: {
                            mapDotMode = MapDotWeight.totalCases
                            showingAlert = true
                        }) {
                            HStack {
                                Text("All cases")
                                Spacer()
                                if mapDotMode == MapDotWeight.totalCases {
                                    Image(systemName: "checkmark")
                                        .imageScale(.small)
                                }
                            }
                        }
                        Button(action: {
                            mapDotMode = MapDotWeight.todayDeaths
                        }) {
                            HStack {
                                Text("Today's deaths")
                                Spacer()
                                if mapDotMode == MapDotWeight.todayDeaths {
                                    Image(systemName: "checkmark")
                                        .imageScale(.small)
                                }
                            }
                        }
                        Button(action: {
                            mapDotMode = MapDotWeight.totalDeaths
                            showingAlert = true
                        }) {
                            HStack {
                                Text("All deaths")
                                Spacer()
                                if mapDotMode == MapDotWeight.totalDeaths {
                                    Image(systemName: "checkmark")
                                        .imageScale(.small)
                                }
                            }
                        }
                    }
                    
                    Button(action: {
                        mapDotMode = nil
                    }) {
                        HStack {
                            Text("None")
                            Spacer()
                            if mapDotMode == nil {
                                Image(systemName: "checkmark")
                                    .imageScale(.small)
                            }
                        }
                    }
                    
                }
                label: {
                    Image(systemName: "info.circle")
                }
                .mapButtonStyle()
                .padding(.trailing, 8)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(LocalizedStringKey(alertTitle)), message: Text(LocalizedStringKey(alertMessage)), dismissButton: .default(Text("Confirm")))
                }
                
                Button(action: locateUser) {
                    Image(systemName: "location")
                }
                .mapButtonStyle()
                .padding(.trailing, 8)
            }
        }
        .padding(.vertical, 8)
        .onAppear {
            showPrompt = true
        }
    }
}
