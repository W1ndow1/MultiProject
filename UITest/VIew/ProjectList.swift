//
//  ProjectList.swift
//  NavigationEffect
//
//  Created by window1 on 7/25/24.
//

import SwiftUI

struct ProjectList: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("PhotoGallery", destination: PhotoGalleryView())
                NavigationLink("ScrollalbeTabBar", destination: ScrollableTabBarView())
                NavigationLink("MiniPlayer", destination: MiniPlayer())
            }
            .navigationTitle("Selection")
        }
    }
}

#Preview {
    ProjectList()
}
