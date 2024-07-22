//
//  PhotoGalleryView.swift
//  NavigationEffect
//
//  Created by window1 on 7/17/24.
//

import SwiftUI

struct PhotoGalleryView: View {
    
    @StateObject var model = PhotoViewModel()
    @State var selectedItem: DataModel
    @State private var position = CGSize.zero
    @State private var showDetailView = false
    
    let columns = Array(repeating: GridItem(.flexible(minimum: 100, maximum: 300), spacing: 2), count: 3)

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(model.data) { image in
                            Image(image.value)
                                .resizable()
                                .aspectRatio(1, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                                .zIndex(selectedItem == image ? 1: 0)
                                .onTapGesture() {
                                    position = .zero
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                        self.selectedItem = image
                                        self.showDetailView.toggle()
                                    }
                                }
                        }
                    }
                    .padding(2)
                }
                .defaultScrollAnchor(.bottom)
                if showDetailView {
                    PhotoItemView(model: model ,showDetailView: $showDetailView, seletedItem: $selectedItem, position: $position)
                }
            }
            .navigationTitle("사진보관함")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    @ViewBuilder
    func GridImageView(_item: DataModel) -> some View {
        
    }
}

#Preview {
    PhotoGalleryView(selectedItem: .init(value: "bobcat", index: 0))
}
