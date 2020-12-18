//
//  WebView.swift
//  Solid News
//
//  Created by Fan Zhang on 7/13/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = SFSafariViewController
    @Environment(\.appColor) var appColor

    var url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ safariViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        safariViewController.preferredControlTintColor = UIColor.systemPink
//        safariViewController.dismissButtonStyle = .done
    }
}

struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        SafariView(url: URL(string: "https://www.apple.com")!)
    }
}
