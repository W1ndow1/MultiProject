//
//  PhotoGalleryView.swift
//  NavigationEffect
//
//  Created by window1 on 7/17/24.
//

import SwiftUI

struct PhotoGalleryView: View {
    @StateObject var model = PhotoViewModel()
    var body: some View {
        NavigationStack {
            Home()
                .environmentObject(model)
                .allowsHitTesting(model.selectedItem == nil)
        }
        .overlay {
            Rectangle()
                .fill(.background)
                .ignoresSafeArea()
                .opacity(model.animateView ? 1 - model.dragProgress : 0)
        }
        
        .overlay {
            if model.selectedItem != nil {
                Detail()
                    .environmentObject(model)
                    .allowsHitTesting(model.showDetailView)
            }
        }
        .overlayPreferenceValue(HeroKey.self) { value in
            if let selectedItem = model.selectedItem,
               let sAnchor = value[selectedItem.id + "SOURCE"],
               let dAnchor = value[selectedItem.id + "DEST"] {
                HeroLayer(
                    data: selectedItem,
                    sAnchor: sAnchor,
                    dAnchor: dAnchor
                )
                .environmentObject(model)
            }
        }
    }
}

#Preview {
    PhotoGalleryView()
}

