//
//  HeroLayer.swift
//  NavigationEffect
//
//  Created by window1 on 7/23/24.
//

import SwiftUI

struct HeroLayer: View {
    @EnvironmentObject private var model: PhotoViewModel
    var data: DataModel
    var sAnchor: Anchor<CGRect>
    var dAnchor: Anchor<CGRect>
    
    var body: some View {
        GeometryReader { proxy in
            let sRect = proxy[sAnchor]
            let dRect = proxy[dAnchor]
            let animateView = model.animateView
            
            let viewSize: CGSize = .init(
                width: animateView ? dRect.width : sRect.width,
                height: animateView ? dRect.height : sRect.height
            )
            let viewPosition: CGSize = .init(
                width: animateView ? dRect.minX: sRect.minX,
                height: animateView ? dRect.minY: sRect.minY
            )
            if let value = data.value, !model.showDetailView {
                Image(value)
                    .resizable()
                    .aspectRatio(contentMode: animateView ? .fit : .fill)
                    .frame(width: viewSize.width, height: viewSize.height)
                    .clipped()
                    .offset(viewPosition)
                    .transition(.identity)
            }
        }
    }
}

#Preview {
    ProjectList()
}
