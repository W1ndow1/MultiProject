//
//  PhotoCollectionView.swift
//  MultiProject
//
//  Created by window1 on 8/9/24.
//

import SwiftUI
import PhotosUI

struct PhotoCollectionView: View {
    @StateObject var model = PhotoViewModel()
    
    var body: some View {
        NavigationStack {
            PhotoGirdView(photoCollection: model.photoCollection)
                .environmentObject(model)
                .allowsHitTesting(model.selectedAssetItem == nil)
        }
        .overlay {
            Rectangle()
                .fill(.background)
                .ignoresSafeArea()
                .opacity(model.animateView ? 1 - model.dragProgress : 0)
            
        }
        .overlay {
            if model.selectedAssetItem != nil {
                PhotoGridDetailView(photoCollection: model.photoCollection)
                    .environmentObject(model)
                    .allowsHitTesting(model.showDetailView)
            }
        }
    }
}

#Preview {
    PhotoCollectionView()
}
