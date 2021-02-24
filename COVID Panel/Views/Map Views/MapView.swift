//
//  MapView.swift
//  Solid News
//
//  Created by Fan Zhang on 11/2/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import GoogleMaps
import SwiftUI

struct MapView: View {
    
    @State var searchText: String = ""
    
    var covidDataManager: CovidDataGarbber {
        CovidDataGarbber(covidData: $covidData)
    }
    
    @EnvironmentObject var locationManager: LocationManager
//    @ObservedObject var locationManager: LocationManager = LocationManager()
    @State var camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 37.7749, longitude: -122.4194, zoom: 10.0)
    @State var mapDotMode: MapDotWeight? = .todayCases
    
    @State var covidData: CovidDataModel? = nil
    @State var showPanel: Bool = false
    
    var body: some View {
        ZStack {
            GoogleMapView(camera: $camera, covidData: $covidData, mapDotMode: $mapDotMode, searchCoordinatesAndUpdatePanel: searchCoordinatesAndUpdatePanel)
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading){
                LocateButton(locateUser: {
                    buttonPressed(to: nil)
                }, mapDotMode: $mapDotMode)
                Spacer()
                VStack {
                    if showPanel {
                        if let safe_covidData = covidData {
                            InfoCardView(covidData: safe_covidData, buttonCallback: closePanel)
                                .mapViewCardStyle(paddings: false)
                                .padding(.horizontal, 8)
                        } else {
                            InfoCardView(covidData: CovidDataModel.defaultCovidData(), buttonCallback: closePanel)
                                .mapViewCardStyle(paddings: false)
//                                .redacted(reason: .placeholder)
                                .padding(.horizontal, 8)
                        }
                    }
                    SearchBar(placeholder: "Search for location", text: $searchText, onTap: searchPlaceAndUpdatePanel)
                        .mapViewCardStyle()
                        .padding(.horizontal, 8)
                    
                }
                .frame(maxWidth: 420)
            }
            .padding(.bottom, 8)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}


//MARK: - Update Location

extension MapView {
    
    func buttonPressed(to: GMSCameraPosition? = nil) {
        if let safe_to = to {
            cameraRelocate(to: safe_to)
        } else {
            showUserLocationAndUpdatePanel()
        }
    }
    
    func showUserLocation() {
        print("### start locating for google map")
        guard let safe_userCoordinates = locationManager.userCoordinates else { return }
        camera = GMSCameraPosition.camera(withLatitude: safe_userCoordinates.latitude, longitude: safe_userCoordinates.longitude, zoom: 10.0)
    }
    
    func cameraRelocate(to: GMSCameraPosition) {
        print("### successfully relocate camera")
        camera = to
    }
    
    func showUserLocationAndUpdatePanel() {
        guard let safe_userCoordinates = locationManager.userCoordinates else { return }
        searchCoordinatesAndUpdatePanel(lat: safe_userCoordinates.latitude, lon: safe_userCoordinates.longitude)
    }
    
    func searchCoordinatesAndUpdatePanel(lat: Double, lon: Double) {
        withAnimation {
            showPanel = true
        }
//        covidDataManager.updateViewFromCoordinates(lat: lat, lon: lon, mapGoTo: cameraRelocate)

    }
    
    func closePanel() {
        withAnimation {
            covidData = nil
            showPanel = false
        }
    }
    
    func searchPlaceAndUpdatePanel(topic: String) {
        withAnimation {
            showPanel = true
        }
//        covidDataManager.updateView(addr_string: topic, mapGoTo: cameraRelocate)
    }
    
}



//MARK: - Preview

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}


