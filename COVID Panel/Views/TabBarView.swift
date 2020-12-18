//
//  TabBarView.swift
//  COVID Panel
//
//  Created by Fan Zhang on 11/20/20.
//

import SwiftUI

struct TabBarView: View {
    
    @State private var selectedView = 0
    @Environment(\.appColor) var appColor
        
    var body: some View {
        TabView(selection: $selectedView) {
            DashboardView()
                .tabItem {
                    Image(systemName: "gauge")
                    Text("Dashboard")
                }.tag(0)
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }.tag(1)
            SettingsView()
                .foregroundColor(.primary)
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }.tag(2)
        }
        .accentColor(appColor)
        .navigationViewStyle(
            StackNavigationViewStyle())
    }
}
