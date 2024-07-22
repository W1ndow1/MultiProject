//
//  NavigationEffectApp.swift
//  NavigationEffect
//
//  Created by window1 on 7/17/24.
//

import SwiftUI

@main
struct NavigationEffetctApp: App {
    var body: some Scene {
        WindowGroup {
            PhotoGalleryView(selectedItem: .init(value: "bobcat", index: 0))
        }
    }
}
