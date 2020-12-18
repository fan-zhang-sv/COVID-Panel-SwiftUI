//
//  SettingsView.swift
//  Solid News
//
//  Created by Fan Zhang on 11/7/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("defaultLang") var defaultLang: String?
    @Environment(\.appColor) var appColor
    
    let azureUrl: URL = URL(string:"https://azure.microsoft.com/en-us/services/cognitive-services")!
    let jhuUrl: URL = URL(string:"https://github.com/CSSEGISandData/COVID-19")!
    
    let githubUrl: URL = URL(string:"https://github.com/fan-zhang-sv")!
    
    var body: some View {
        NavigationView {
            List {
                Section(
                    header: Text("Language"),
                    footer: Text("Choose a preferred language to use this app, which will affect the user interface and news translation.")
                ) {
                    NavigationLink(destination: LanguageView(selectLang: defaultLang!)) {
                        Label {
                            Text("Display Language")
                        } icon: {
                            Image(systemName: "globe")
                                .foregroundColor(appColor)
                        }
                    }
                    
                }
                
                Section(
                    header: Text("Data Source"),
                    footer: Text("All information is provided by third-party platforms.")
                ) {
                    Button(action: {
                        UIApplication.shared.open(azureUrl)
                    }) {
                        HStack {
                            Label {
                                Text("News Provider")
                            } icon: {
                                Image(systemName: "exclamationmark.bubble")
                                    .foregroundColor(appColor)
                            }
                            Spacer()
                            Image(systemName: "control")
                                .rotationEffect(Angle(degrees: 90))
                                .imageScale(.small)
                                .foregroundColor(Color(.systemGray2))
                        }
                    }
                    .buttonStyle(DefaultButtonStyle())
                    
                    Button(action: {
                        UIApplication.shared.open(jhuUrl)
                    }) {
                        HStack {
                            Label {
                                Text("COVID-19 Data Provider")
                            } icon: {
                                Image(systemName: "staroflife")
                                    .foregroundColor(appColor)
                            }
                            Spacer()
                            Image(systemName: "control")
                                .rotationEffect(Angle(degrees: 90))
                                .imageScale(.small)
                                .foregroundColor(Color(.systemGray2))
                        }
                    }
                    .buttonStyle(DefaultButtonStyle())
                }
                
                Section(
                    header: Text("About"),
                    footer: Text("This app is built to alarm the users of the severeness of the pandemic. Stay safe, fella!")
                ) {
                    HStack {
                        Label {
                            Text("Version:")
                        } icon: {
                            Image(systemName: "number")
                                .foregroundColor(appColor)
                        }
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Undeterminated")
                            .foregroundColor(Color(.systemGray))
                    }
                    
//                    Button(action: {
//                        UIApplication.shared.open(githubUrl)
//                    }) {
//                        HStack {
//                            Label {
//                                Text("Rate & Review on App Store")
//                            } icon: {
//                                Image(systemName: "heart")
//                                    .foregroundColor(appColor)
//                            }git checcccc
//                            Spacer()
//                            Image(systemName: "control")
//                                .rotationEffect(Angle(degrees: 90))
//                                .imageScale(.small)
//                                .foregroundColor(Color(.systemGray2))
//                        }
//                    }
//                    .buttonStyle(DefaultButtonStyle())
                    
                    Button(action: {
                        UIApplication.shared.open(githubUrl)
                    }) {
                        HStack {
                            Label {
                                Text("Follow me on GitHub")
                            } icon: {
                                Image(systemName: "display")
                                    .foregroundColor(appColor)
                            }
                            Spacer()
                            Image(systemName: "control")
                                .rotationEffect(Angle(degrees: 90))
                                .imageScale(.small)
                                .foregroundColor(Color(.systemGray2))
                        }
                    }
                    .buttonStyle(DefaultButtonStyle())
                }
            }
            .navigationBarTitle("Settings", displayMode: .large)
        }
        .listStyle(GroupedListStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
