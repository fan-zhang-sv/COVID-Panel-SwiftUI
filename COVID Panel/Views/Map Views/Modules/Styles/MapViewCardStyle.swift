//
//  SearchBarStyle.swift
//  Solid News
//
//  Created by Fan Zhang on 11/2/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import SwiftUI

struct MapViewCardStyle: ViewModifier {
    
    var paddings: Bool
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, paddings ? 10 : 0)
            .padding(.vertical, paddings ? 10 : 0)
            .blurBackground()
            .cornerRadius(14)
    }
}


extension View {
    func mapViewCardStyle(paddings:Bool=true) -> some View {
        self.modifier(MapViewCardStyle(paddings:paddings))
    }
}



