//
//  Blur.swift
//  Solid News
//
//  Created by Fan Zhang on 11/2/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import SwiftUI


struct BlurBackground: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme
    var backgroundColor: Color {
        if colorScheme == .dark {
            return Color.black.opacity(0)
        } else {
            return Color.white.opacity(0.9)
        }
    }
    
    func body(content: Content) -> some View {
        content
            .background(backgroundColor)
            .background(Blur())
    }
}


extension View {
    func blurBackground() -> some View {
        self.modifier(BlurBackground())
    }
}



struct Blur: UIViewRepresentable {
    let style: UIBlurEffect.Style = .systemThickMaterial
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
