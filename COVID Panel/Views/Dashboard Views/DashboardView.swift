//
//  DashboardView.swift
//  COVID Panel
//
//  Created by Fan Zhang on 11/20/20.
//

import SwiftUI
import RealmSwift

struct DashboardView: View {
    
    @State var nearBy: CovidDataModel? = nil
    @State var results: Results<CovidDataInRealm> = try! Realm().objects(CovidDataInRealm.self).sorted(byKeyPath: "order").sorted(byKeyPath: "order")
    @State var editPage: Bool = false
    
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("Nearby")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fontWeight(.regular)
                        .textCase(.uppercase)
                        .padding(.horizontal, 22)
                        .padding(.top, 24)
                        .padding(.bottom, 14)
                    
                    if let safe_nearBy = nearBy {
                        NavigationLink(
                            destination: PlaceDetailView(covidData: safe_nearBy)
                                .navigationTitle(safe_nearBy.name!),
                            label: {
                                PlaceCardView(covidData: safe_nearBy)
                                    .placeCardStyle()
                            }
                        )
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal)
                    } else {
                        LocalCardPlaceholder()
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                    }
                    
                    Text("Saved Location")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fontWeight(.regular)
                        .textCase(.uppercase)
                        .padding(.horizontal, 22)
                        .padding(.top, 24)
                        .padding(.bottom, 14)
                    
                    Section {
                        LazyVStack(spacing: 16){
                            ForEach((0..<results.count), id:\.self) { idx in
                                NavigationLink(
                                    destination: PlaceDetailView(covidData: CovidDataModel(covidDataInRealm: results[idx]))
                                        .navigationTitle(results[idx].name),
                                    label: {
                                        PlaceCardView(covidData: CovidDataModel(covidDataInRealm: results[idx]))
                                            .placeCardStyle()
                                    }
                                )
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.horizontal)
                        }
                    }
                    .onAppear {
                        print("### Section on appear refreshing")
                        results = try! Realm().objects(CovidDataInRealm.self).sorted(byKeyPath: "order")
                    }
                    
                    HStack {
                        Spacer()
                        Text("Data provided by Johns Hopkins University.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding()
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarTitle("Dashboard", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    editPage = true
                }, label: {
                    Image(systemName: "list.dash")
                        .imageScale(.medium)
                })
            )
            .sheet(isPresented: $editPage, onDismiss: refreshResults, content: {
                CRUDView()
            })
            .onAppear {
                print("### on Appear refreshing")
                DispatchQueue.main.async {
                    if nearBy == nil {
                        updateNearByFromLocation()
                    }
                    results = try! Realm().objects(CovidDataInRealm.self).sorted(byKeyPath: "order").sorted(byKeyPath: "order")
                    for result in results {
                        CovidDataInRealmUpdater.updateCovidDataInRealm(covidDataInRealm: result)
                    }
                }
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}

struct LocalCardPlaceholder: View {
    var body: some View {
        PlaceCardView(covidData: CovidDataModel.defaultCovidData())
            .placeCardStyle()
            .redacted(reason: .placeholder)
        
    }
}


extension DashboardView {
    
    func refreshResults() {
        results = try! Realm().objects(CovidDataInRealm.self).sorted(byKeyPath: "order")
    }
    
    func updateNearByFromLocation() {
        print("### Dashboard starting locating for nearby")
        guard let safe_userCoordinates = locationManager.userCoordinates else { return }
        let covidManager = CovidDataGarbber(covidData: $nearBy)
        covidManager.updateViewFromCoordinates(lat: safe_userCoordinates.latitude, lon: safe_userCoordinates.longitude, mapGoTo: {_  in})
    }
    
}
