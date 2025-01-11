//
//  PhotoGridCellView.swift
//  MultiProject
//
//  Created by window1 on 8/14/24.
//

import SwiftUI
import Photos

struct PhotoGridCellView: View {
    @Environment(\.displayScale) private var displayScale
    
    var asset: PhotoAsset
    var cache: CachedImageManager?
    var itemSize: CGSize?
    
    @State private var image: Image?
    @State private var imageRequsetID: PHImageRequestID?
    
    var imageSize: CGSize {
        return CGSize(width: (itemSize?.width ?? 125) * min(displayScale, 2),
                      height: (itemSize?.height ?? 125) * min(displayScale, 2))}
    
    var body: some View {
        VStack {
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 125, height: 125)
                    .clipped()
            } else {
                Rectangle()
                    .fill(.clear)
                    .scaledToFill()
            }
        }
        .task {
            guard image == nil, let cache = cache else { return }
            imageRequsetID = cache.requestImage(for: asset, targetSize: imageSize) { result in
                Task {
                    if let result = result {
                        self.image = result.image
                    }
                }
            }
        }
    }
}
