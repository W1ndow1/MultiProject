//
//  ScrollableTabBarView.swift
//  NavigationEffect
//
//  Created by window1 on 7/25/24.
//

import SwiftUI

struct ScrollableTabBarView: View {
    @State private var tabs: [TabModel] = [
        .init(id: TabModel.Tab.research),
        .init(id: TabModel.Tab.deployment),
        .init(id: TabModel.Tab.analytics),
        .init(id: TabModel.Tab.audience),
        .init(id: TabModel.Tab.privacy),
    ]
    @State private var activeTab: TabModel.Tab = .research
    @State private var mainViewScrollState: TabModel.Tab?
    @State private var tabButtonScrollState: TabModel.Tab?
    @State private var progress: CGFloat = .zero
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            CustomTabBar()
            GeometryReader {
                let size = $0.size
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(tabs) { item in
                            Text(item.id.rawValue)
                                .frame(width: size.width, height: size.height)
                                .contentShape(.rect)
                        }
                    }
                    .scrollTargetLayout()
                    .rect { rect in
                        progress = -rect.minX / size.width
                    }
                }
                .scrollPosition(id: $mainViewScrollState)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .onChange(of: mainViewScrollState) { oldValue, newValue in
                    if let newValue {
                        withAnimation(.snappy) {
                            tabButtonScrollState = newValue
                            activeTab = newValue
                        }
                    }
                }
            }
        }
    }
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            Image(.bullElk)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
            Spacer()
            
            Button("", systemImage: "plus.circle") {
                
            }
            .font(.title2)
            .tint(.primary)
            
            Button("", systemImage: "bell") {
                
            }
            .font(.title2)
            .tint(.primary)
            
            Button(action: {}, label: {
                Image(.grizzly)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .clipShape(.circle)
            })
            
        }
        .padding(15)
        ///
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(height: 1)
                
        }
        
    }
    
    @ViewBuilder
    func CustomTabBar() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach($tabs) { $item in
                    Button(action: {
                        withAnimation(.snappy){
                            activeTab = item.id
                            tabButtonScrollState = item.id
                            mainViewScrollState = item.id
                        }
                    }) {
                        Text(item.id.rawValue)
                            .padding(.vertical, 12)
                            .foregroundStyle(activeTab == item.id ? Color.primary : Color.gray)
                            .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .rect { rect in
                        item.size = rect.size
                        item.minX = rect.minX
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: .init(get: {
            return tabButtonScrollState
        }, set: { _ in
            
        }), anchor: .center)
        .overlay(alignment: .bottom) {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(height: 1)
                let inputRange = tabs.indices.compactMap { return CGFloat($0)}
                let outputRange = tabs.compactMap { return $0.size.width }
                let outputPositionRange = tabs.compactMap { return $0.minX }
                let indicatorWidth = progress.interpolation(inputRange: inputRange, ouputRange: outputRange)
                let indicatorPosition = progress.interpolation(inputRange: inputRange, ouputRange: outputPositionRange)
                
                Rectangle()
                    .fill(.primary)
                    .frame(width: indicatorWidth, height: 1.5)
                    .offset(x: indicatorPosition)
            }
        }
        .safeAreaPadding(.horizontal, 15)
        .scrollIndicators(.hidden)
         
    }
}

#Preview {
    ScrollableTabBarView()
}
