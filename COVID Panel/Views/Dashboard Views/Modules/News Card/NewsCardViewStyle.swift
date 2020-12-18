//
//  NewsCardViewStyle.swift
//  Solid News
//
//  Created by Fan Zhang on 11/8/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import SwiftUI


struct NewsCardViewStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
            .shadow(radius: 1)
    }
}


extension View {
    func newsCardViewStyle() -> some View {
        self.modifier(NewsCardViewStyle())
    }
}
