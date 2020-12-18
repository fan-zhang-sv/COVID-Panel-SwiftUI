//
//  SearchBar.swift
//  Solid News
//
//  Created by Fan Zhang on 11/2/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import SwiftUI

struct SearchBar: View {
    
    var placeholder: String
    @Binding var text: String
    var onTap: (String) -> Void
    
    @State var isEditing: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.appColor) var appColor
    
    var backgroundColor: Color {
        if colorScheme == .dark {
            return Color(.systemGray5)
        } else {
            return Color(.systemGray6)
        }
    }
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField(LocalizedStringKey(placeholder), text: $text)
                { isEditing in
                    self.isEditing = isEditing
                } onCommit: {
                    if self.text != "" {
                        onTap(text)
                    }
                    //                    self.text = ""
                    self.hideKeyboard()
                    self.isEditing = false
                }
                .keyboardType(.default)
                .disableAutocorrection(false)
                .autocapitalization(.words)
                //                .onTapGesture {
                //                    self.isEditing = true
                //                }
                //                    .font(.system(size: 16))
                if text != "" {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.medium)
                        .foregroundColor(Color(.systemGray3))
                        .padding(.horizontal, 3)
                        .onTapGesture {
                            withAnimation {
                                self.text = ""
                            }
                        }
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(backgroundColor)
            .cornerRadius(12)
            
            if isEditing {
                Button<Text>(action: {
                    withAnimation {
                        self.text = ""
                        self.hideKeyboard()
                        self.isEditing = false
                    }
                }, label: {
                    Text("Cancel")
                        .font(.system(size: 16))
                })
            }
        }
        
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
