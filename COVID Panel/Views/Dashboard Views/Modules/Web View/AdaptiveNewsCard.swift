//
//  AdaptiveNewsCard.swift
//  Solid News
//
//  Created by Fan Zhang on 11/6/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import SwiftUI


let defaultUrl = "https://www.apple.com/"

struct NewsOnPhone: View {
    
    var news: NewsModel = NewsModel.defaultNews()
    var mkt: String = "en-US"
    var url: URL {
        URL(string: news.url ?? defaultUrl)!
    }
    
    var compact: Bool = false
    
    @Binding var show_modal: Bool
    
    var body: some View {
        Button(action: {
            show_modal = true
        }) {
            if compact {
                CompactNewsCardView(news: news, mkt: mkt)
            } else {
                NewsCardView(news: news, mkt: mkt)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $show_modal) {
            SafariView(url: url)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct NewsOnPad: View {
    
    var news: NewsModel = NewsModel.defaultNews()
    var mkt: String = "en-US"
    var url: URL {
        URL(string: news.url ?? defaultUrl)!
    }
    @State private var showShareSheet = false
    
    var compact: Bool = false
    
    var body: some View {
        NavigationLink(
            destination:
                WebView(url: url)
                .edgesIgnoringSafeArea(.all)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle(url.host!)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            UIApplication.shared.open(url)
                        }, label: {
                            Image(systemName: "safari")
                        })
                    }
                }
        ) {
            if compact {
                CompactNewsCardView(news: news, mkt: mkt)
            } else {
                NewsCardView(news: news, mkt: mkt)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
