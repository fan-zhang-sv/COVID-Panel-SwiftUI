//
//  AppColorEnvironmentKey.swift
//  Solid News
//
//  Created by Fan Zhang on 11/7/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import SwiftUI

struct AppColorEnvironmentKey: EnvironmentKey {
    static let defaultValue: Color? = nil
}

extension EnvironmentValues {
    var appColor: Color? {
        get {
            return self[AppColorEnvironmentKey]
        }
        set {
            self[AppColorEnvironmentKey] = newValue
        }
    }
}
