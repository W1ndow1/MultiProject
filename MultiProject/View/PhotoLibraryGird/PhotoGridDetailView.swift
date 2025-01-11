//
//  PhotoGridDetailView.swift
//  MultiProject
//
//  Created by window1 on 8/19/24.	//

import SwiftUI
import Photos

struct PhotoGridDetailView: View {
    @ObservedObject var photoCollection: PhotoCollection
    @EnvironmentObject var model: PhotoViewModel
    
    @State private var image: UIImage? = nil
    
    var body: some View {
        VStack {
            navigationBar()
            GeometryReader {
                let size = $0.size
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(photoCollection.photoAssets) { asset in
                            imageView(asset: asset, size: size)
                                .offset(model.offset)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: .init(get: {
                    return model.detailScrollPosition
                }, set: {
                    model.detailScrollPosition = $0
                }))
                
            }
            .opacity(model.showDetailView ? 1 : 0)
            bottomIndicatorView()
                .offset(y: model.showDetailView ? (120 * model.dragProgress) : 120)
                .animation(.easeInOut, value: model.showDetailView)
        }
        .onAppear {
            model.toggleToPhoto(show: true)
        }
    }
    
    @ViewBuilder
    func navigationBar() -> some View {
        HStack {
            Button(action: {
                model.toggleToPhoto(show: false)
            }, label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                Text("뒤로")
            })
            
            Spacer()
            
            Button(action: {
                
            }, label: {
                Image(systemName: "ellipsis")
                    .padding(10)
                    .background(.bar, in: .circle)
            })
        }
        .padding([.top, .horizontal], 15)
        .padding(.bottom, 10)
        .background(.ultraThinMaterial)
        .offset(y: model.showDetailView ?  (-120 * model.dragProgress) : -120)
        .animation(.easeInOut, value: model.showDetailView)
    }
    
    @ViewBuilder
    func imageView(asset: PhotoAsset, size: CGSize) -> some View {
        Image(uiImage: image ?? .bobcat)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size.width, height: size.height)
            .onAppear() {
                Task {
                    image = await model.loadImage(for: asset, targetSize: size)
                }
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let translaction = value.translation
                        let velocity = value.velocity
                        let height = translaction.height + (velocity.height / 5)
                        if height > (size.height * 0.5) {
                            model.toggleView(show: false)
                        } else {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                model.offset = .zero
                                model.dragProgress = 0
                            }
                        }
                    }
            )
        
    }
    
    @ViewBuilder
    func bottomIndicatorView() -> some View {
        GeometryReader {
            let size = $0.size
            let frameSize: CGFloat = 50
            ScrollView(.horizontal) {
                LazyHStack(spacing: 2) {
                    ForEach(photoCollection.photoAssets) { asset in
                        indiatorCell(asset: asset, size: frameSize)
                    }
                }
                .padding(.vertical, 10)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: .init(get: {
                return model.detailIndicatorPosition
            }, set: {
                model.detailIndicatorPosition = $0
            }))
            .safeAreaPadding(.horizontal, (size.width - 50) / 2)
            .overlay {
                indicatorFrame(size: frameSize)
            }
            .scrollIndicators(.hidden)
            .onChange(of: model.detailIndicatorPosition, { ov, nv in
                model.didDetailIndicatorChanged()
                
            })
        }
        .frame(height: 50)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
        }
    }
     
    @ViewBuilder
    func indiatorCell(asset: PhotoAsset, size: CGFloat) -> some View {
        PhotoGridCellView(asset: asset, cache: photoCollection.cache, itemSize: CGSize(width: 100, height: 100))
            .aspectRatio(contentMode: .fill)
            .frame(width:size, height:size)
            .clipped()
            .scaleEffect(0.85)
    }
    
    @ViewBuilder
    func indicatorFrame(size: CGFloat) -> some View {
        Rectangle()
            .stroke(Color.accentColor, lineWidth: 5)
            .frame(width: 50, height: 50)
            .clipped()
            .allowsHitTesting(false)
    }

}

#Preview {
    PhotoCollectionView()
}
