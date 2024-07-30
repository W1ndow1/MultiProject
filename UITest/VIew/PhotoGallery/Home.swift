//
//  Home.swift
//  NavigationEffect
//
//  Created by window1 on 7/22/24.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject private var model: PhotoViewModel
    var colums = Array(repeating: GridItem(.flexible(minimum: 100, maximum: 300), spacing: 2), count: 3)
    var body: some View {
        ScrollViewReader { reader in
            ScrollView(.vertical) {
                LazyVGrid(columns: colums, spacing: 2){
                    ForEach(model.data) { item in
                        GridImageView(item)
                            .id(item.id)
                            .onTapGesture {
                                model.selectedItem = item
                            }
                    }
                }
                .padding(2)
            }
            .scrollPosition(id: .init(get: {
                return model.detailScrollPosition
            }, set: {
                model.detailScrollPosition = $0
            }))
            .defaultScrollAnchor(.bottom)
            .navigationTitle("최근사진")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    @ViewBuilder
    func GridImageView(_ item: DataModel) -> some View {
        GeometryReader {
            let size = $0.size
            
            Rectangle()
                .fill(.clear)
                .anchorPreference(key: HeroKey.self, value: .bounds, transform: { anchor in
                    return [item.id + "SOURCE": anchor]
                })
            
            if let value = item.value {
                Image(value)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .opacity(model.selectedItem?.id == item.id ? 0 : 1)
            }
        }
        .frame(height: 130)
        .contentShape(.rect)
    }
}

#Preview {
    ProjectList()
}
