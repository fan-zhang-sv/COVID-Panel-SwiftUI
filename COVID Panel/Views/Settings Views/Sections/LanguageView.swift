//
//  LanguageView.swift
//  Solid News
//
//  Created by Fan Zhang on 11/11/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import SwiftUI

struct LanguageView: View {
    
    @AppStorage("defaultLang") var defaultLang: String?
    
    @State var selectLang: String
    
    @Environment(\.appColor) var appColor
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        List {
            ForEach(Languages.lang.sorted(), id:\.self) { lang in
                Button(action: {
                    selectLang = lang
                }) {
                    HStack {
                        Text(Languages.languageName[lang]!)
                        Spacer()
                        if lang == selectLang {
                            Image(systemName: "checkmark")
                                .imageScale(.small)
                                .foregroundColor(appColor)
                        }
                    }
                }
                .buttonStyle(DefaultButtonStyle())
            }
        }
        .navigationBarTitle("Display Language", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                if defaultLang == selectLang {
                    Text("Update")
                        .foregroundColor(Color(.systemGray))
                } else {
                    Button(action: {
                        defaultLang = selectLang
                        UIApplication.shared.windows.forEach { window in
                            if window.isKeyWindow {
                                window.rootViewController =
                                    UIHostingController(
                                        rootView: TabBarView()
                                            .environment(\.locale, .init(identifier: selectLang))
                                            .environmentObject(locationManager)
                                    )
                            }
                        }
                    }) {
                        Text("Update")
                    }
                }
            }
        }
    }
    
}

struct LanguageView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageView(selectLang: "en-US")
    }
}
