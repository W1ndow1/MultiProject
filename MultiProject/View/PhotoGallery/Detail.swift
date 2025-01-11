//
//  Detail.swift
//  NavigationEffect
//
//  Created by window1 on 7/23/24.
//

import SwiftUI

struct Detail: View {
    @EnvironmentObject private var model: PhotoViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBar()
            
            GeometryReader {
                let size = $0.size
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0.0) {
                        ForEach(model.data) { item in
                            ImageView(item, size: size)
                                .offset(model.offset)
                                .gesture(
                                    DragGesture(minimumDistance: 5)
                                        .onChanged { value in
                                            model.offset.height = value.translation.height
                                            model.dragProgress = max(min(value.translation.height / 200, 1), 0)
                                            
                                        }
                                        .onEnded { value in
                                            let translation = value.translation
                                            let velocity = value.velocity
                                            let height = translation.height + (velocity.height / 5)
                                            
                                            if height > (size.height * 0.5) {
                                                //뷰 닫기
                                                model.toggleView(show: false)
                                            } else {
                                                //초기화
                                                withAnimation(.easeInOut(duration: 0.2)) {
                                                    model.offset = .zero
                                                    model.dragProgress = 0
                                                }
                                            }
                                        }
                                )
                              
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
                .onChange(of: model.detailScrollPosition) { oldValue, newValue in
                    withAnimation {
                        model.didDetailPageChanged()
                    }
                }
                .background {
                    if let selectedItem = model.selectedItem {
                        Rectangle()
                            .fill(.clear)
                            .anchorPreference(key: HeroKey.self, value: .bounds, transform: { anchor in
                                return [selectedItem.id + "DEST": anchor]
                            })
                    }
                }
            }
            .opacity(model.showDetailView ? 1 : 0)
            
            BottomIndicatorView()
                .offset(y: model.showDetailView ? (120 * model.dragProgress) : 120)
                .animation(.easeInOut, value: model.showDetailView)
        }
        .onAppear {
            model.toggleView(show: true)
        }
    }
    @ViewBuilder
    func NavigationBar() -> some View {
        HStack {
            Button(action: {
                model.toggleView(show: false)
            }, label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                Text("뒤로")
            })
            
            Spacer(minLength: 0)
            
            Button {
                
            } label: {
                Image(systemName: "ellipsis")
                    .padding(10)
                    .background(.bar, in: .circle)
            }
        }
        .padding([.top, .horizontal], 15)
        .padding(.bottom, 10)
        .background(.ultraThinMaterial)
        .offset(y: model.showDetailView ? (-120 * model.dragProgress) : -120)
        .animation(.easeInOut, value: model.showDetailView)
    }
    
    @ViewBuilder
    func ImageView(_ item: DataModel, size: CGSize) -> some View {
        if let value = item.value {
            Image(value)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:size.width, height:size.height)
                
        }
    }
    
    @ViewBuilder
    func BottomIndicatorView() -> some View {
        GeometryReader {
            let size = $0.size
            ScrollView(.horizontal) {
                LazyHStack(spacing: 2) {
                    ForEach(model.data) { item in
                        if let value = item.value {
                            Image(value)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipped()
                                .scaleEffect(0.95)
                        }
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
            .safeAreaPadding(.horizontal, (size.width - 50) / 2 )
            .overlay {
                Rectangle()
                    .stroke(Color.accentColor, lineWidth: 5)
                    .frame(width: 50, height: 50)
                    .clipped()
                    .allowsTightening(false)
            }
            .scrollIndicators(.hidden)
            .onChange(of: model.detailIndicatorPosition, { ov, nv in
                model.didDetailIndicatorChanged()
                print(size.width)
            })
        }
        .frame(height: 50)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
        }
    }

}

#Preview {
    PhotoGalleryView()
}
