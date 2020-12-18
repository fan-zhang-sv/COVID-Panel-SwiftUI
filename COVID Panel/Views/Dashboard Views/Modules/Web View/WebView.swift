//
//  WebView.swift
//  Solid News
//
//  Created by Fan Zhang on 11/4/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {

    var url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }

}

