//
//  ProjectList.swift
//  NavigationEffect
//
//  Created by window1 on 7/25/24.
//

import SwiftUI

struct ProjectList: View {
    @State private var hideNavibar: Bool = true
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("PhotoGallery", destination: PhotoGalleryView())
                NavigationLink("ScrollalbeTabBar", destination: ScrollableTabBarView())
                NavigationLink("MiniPlayer", destination: MiniPlayerHomeView())
                
                Section("테스트"){
                    ForEach(0...50, id: \.self) { index in
                        Text("Row Index Count : \(index)")
                    }
                }
            }
            .navigationTitle("Project List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        hideNavibar.toggle()
                    } label: {
                        Image(systemName: hideNavibar ? "eye.slash" : "eye")
                    }
                }
            }
            .hideNaviBarOnSwipe(hideNavibar)
        }
    }
}

#Preview {
    ProjectList()
}
