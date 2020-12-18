//
//  GoogleMapView.swift
//  Solid News
//
//  Created by Fan Zhang on 11/16/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import SwiftUI
import GoogleMaps
import CoreLocation
import RealmSwift

struct GoogleMapView: UIViewRepresentable {
    
    typealias UIViewType = GMSMapView
    typealias Coordinator = GMSMapViewCoordinator
    
    @Binding var camera: GMSCameraPosition
    @Binding var covidData: CovidDataModel?
    @Binding var mapDotMode: MapDotWeight?
    
    let searchCoordinatesAndUpdatePanel: (Double, Double) -> Void
    
    @State var results: Results<MapDotInRealm> = try! Realm().objects(MapDotInRealm.self)
    
    @EnvironmentObject var locationManager: LocationManager
//    @ObservedObject var locationManager: LocationManager = LocationManager()
    @Environment(\.colorScheme) var colorScheme
    
    func makeUIView(context: Self.Context) -> UIViewType {
        print("### Making GoogleMapView")
        let mapView : GMSMapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = context.coordinator
        mapView.isMyLocationEnabled = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        mapView.setMinZoom(1, maxZoom: 10.0)
        MapDotUpdater.updateCovidDataInRealm()
        refreshResults()
        showUserLocation(mapView)
        return mapView
    }
    
    func updateUIView(_ mapView: UIViewType , context: Self.Context) {
        if covidData != nil {
            mapView.camera = camera
        }
        mapView.clear()
        if let safe_mapDotMode = mapDotMode {
            attachAnAnnotations(mapView, weight: safe_mapDotMode)
        }
        adaptStyle(mapView)
    }
    
    func makeCoordinator() -> Coordinator {
        return GMSMapViewCoordinator(self)
    }
    
}


struct GoogleMapView_Previews: PreviewProvider {
    
    static var previews: some View {
        GoogleMapView(camera: .constant(GMSCameraPosition.camera(withLatitude: 37.7749, longitude: -122.4194, zoom: 10.0)), covidData: .constant(CovidDataModel.defaultCovidData()), mapDotMode: .constant(.todayCases), searchCoordinatesAndUpdatePanel: {_,_ in})
            .edgesIgnoringSafeArea(.all)
    }
}


class GMSMapViewCoordinator: NSObject, GMSMapViewDelegate {
    
    var owner: GoogleMapView
    
    init(_ owner: GoogleMapView) {
        self.owner = owner
    }

    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        owner.searchCoordinatesAndUpdatePanel(coordinate.latitude, coordinate.longitude)
    }
    
}


extension GoogleMapView {
    
    func refreshResults() {
        if results.count == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                results = try! Realm().objects(MapDotInRealm.self)
                refreshResults()
            })
        }
    }
    
    func attachAnAnnotations(_ mapView: UIViewType, weight: MapDotWeight) {
//        let results = try! Realm().objects(MapDotInRealm.self)
        results.forEach { mapDot in
            var number:Int = 0
            switch weight {
            case .totalCases:
                number = mapDot["total_cases"] as? Int ?? 0
            case .todayCases:
                number = mapDot["today_cases"] as? Int ?? 0
            case .totalDeaths:
                number = mapDot["total_deaths"] as? Int ?? 0
            case .todayDeaths:
                number = mapDot["today_deaths"] as? Int ?? 0
            }
            
            if number != 0 {
                let position = CLLocationCoordinate2D(latitude: mapDot.lat, longitude: mapDot.lon)
                let marker = GMSMarker(position: position)
                marker.isTappable = true
                marker.isFlat = true
                var normalizedWeight = CGFloat(CGFloat(number)).squareRoot()

                if normalizedWeight > 0.1 {
                    
                    if mapDotMode == MapDotWeight.totalCases {
                        let threshold: CGFloat = 100
                        if normalizedWeight > threshold {
//                            let offset = threshold - log(threshold)
//                            normalizedWeight = log(normalizedWeight) + offset
                            let offset = threshold - threshold.squareRoot()
                            normalizedWeight = normalizedWeight.squareRoot() + offset
    //                        normalizedWeight = normalizedWeight.squareRoot()
                        }
                        normalizedWeight = normalizedWeight / 4
                    } else if mapDotMode == MapDotWeight.totalDeaths {
                        let threshold: CGFloat = 1000
                        if normalizedWeight > threshold {
//                            let offset = threshold - log(threshold)
//                            normalizedWeight = log(normalizedWeight) + offset
                            let offset = threshold - threshold.squareRoot()
                            normalizedWeight = normalizedWeight.squareRoot() + offset
    //                        normalizedWeight = normalizedWeight.squareRoot()
                        }
                        normalizedWeight = normalizedWeight / 2
                    }
                    

                    if let img = UIImage.circle(diameter: normalizedWeight, color: .red) {
                        marker.icon = img
                        marker.opacity = 0.6
                        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                        marker.map = mapView
                    }
                }
            }
        }
    }
    
    func showUserLocation(_ mapView: UIViewType) {
        print("### start locating for google map")
        guard let safe_userCoordinates = locationManager.userCoordinates else { return }
        mapView.animate(to: GMSCameraPosition.camera(withLatitude: safe_userCoordinates.latitude, longitude: safe_userCoordinates.longitude, zoom: 10.0))
    }
    
    func adaptStyle(_ mapView: UIViewType) {
        if colorScheme == .dark {
            do {
                // Set the map style by passing the URL of the local file.
                if let styleURL = Bundle.main.url(forResource: "GMS_darkmode_style", withExtension: "json") {
                    mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                } else {
                    print("Unable to find style.json")
                }
            } catch {
                print("One or more of the map styles failed to load. \(error)")
            }
        } else {
            do {
                mapView.mapStyle = try GMSMapStyle(jsonString: "[]")
            } catch {
                print("One or more of the map styles failed to load. \(error)")
            }
            
        }
    }
    
}

extension UIImage {
    
    class func circle(diameter: CGFloat, color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil}
        ctx.saveGState()
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: rect)
        ctx.restoreGState()
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else {return nil}
        UIGraphicsEndImageContext()
        return img
    }
}

enum MapDotWeight {
    case totalCases, todayCases, totalDeaths, todayDeaths
}
