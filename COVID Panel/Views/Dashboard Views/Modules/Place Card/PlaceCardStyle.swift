//
//  NewsCardViewStyle.swift
//  Solid News
//
//  Created by Fan Zhang on 11/8/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import SwiftUI


struct PlaceCardStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(Color("CardBackground"))
            .cornerRadius(10)
//            .shadow(radius: 1)
    }
}


extension View {
    func placeCardStyle() -> some View {
        self.modifier(PlaceCardStyle())
    }
}
