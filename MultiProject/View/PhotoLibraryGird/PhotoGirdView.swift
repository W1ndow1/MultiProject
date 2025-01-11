//
//  PhotoItemView.swift
//  NavigationEffect
//
//  Created by window1 on 7/18/24.
//

import SwiftUI
import Photos

struct PhotoGirdView: View {
    @ObservedObject var photoCollection: PhotoCollection
    @EnvironmentObject var model: PhotoViewModel
    
    var colums = Array(repeating: GridItem(.flexible(minimum: 100, maximum: 300), spacing: 6), count: 3)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: colums, spacing: 2 /* 상하 여백 */) {
                ForEach(photoCollection.photoAssets) { asset in
                    PhotoGridCellView(asset: asset,
                                      cache: photoCollection.cache,
                                      itemSize: CGSize(width: 200, height: 200))
                    .id(asset.id)
                    .onTapGesture {
                        model.selectedAssetItem = asset
                    }
                }
            }
        }
        .scrollPosition(id: .init(get: {
            return model.detailScrollPosition
        }, set: {
            model.detailScrollPosition = $0
        }))
        .defaultScrollAnchor(.bottomLeading  )
        .navigationTitle("최근사진")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    PhotoCollectionView()
}
