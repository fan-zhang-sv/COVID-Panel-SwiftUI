//
//  MapButton.swift
//  Solid News
//
//  Created by Fan Zhang on 11/2/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import SwiftUI

struct MapButtonStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 22))
            .padding(10)
            .blurBackground()
            .cornerRadius(8)
    }
}

extension View {
    func mapButtonStyle() -> some View {
        self.modifier(MapButtonStyle())
    }
}
