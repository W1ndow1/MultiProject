//
//  MiniPlayer.swift
//  NavigationEffect
//
//  Created by window1 on 7/27/24.
//

import SwiftUI

struct MiniPlayerHomeView: View {
    @State private var activeTab: UnderTab = .home
    @State private var config: PlaterConfig = .init()
    
    var body: some View {
        ZStack(alignment: .bottom){
            TabView(selection: $activeTab) {
                HomeTabView()
                    .setupTab(.home)
                Text(UnderTab.shorts.rawValue)
                    .setupTab(.shorts)
                Text(UnderTab.subscriptions.rawValue)
                    .setupTab(.subscriptions)
                Text(UnderTab.you.rawValue)
                    .setupTab(.you)
            }
            .padding(.bottom, tabBarHeight)
            
            ///MiniPlayerView
            GeometryReader {
                let size = $0.size
                if config.showMiniPlayer {
                    MiniPlayerView(config: $config, size: size) {
                        withAnimation(.easeInOut(duration: 0.3), completionCriteria: .logicallyComplete) {
                            config.showMiniPlayer = false
                        } completion: {
                            config.resetPostion()
                            config.selectedPlaterItem = nil
                        }
                    }
                }
            }
            
            CustomTabBar()
                .offset(y: config.showMiniPlayer ? tabBarHeight - (config.progress * tabBarHeight) : 0)
            
        }
        .navigationTitle("\(activeTab.rawValue)")
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    @ViewBuilder
    func HomeTabView() -> some View {
            ScrollView(.vertical) {
                LazyVStack(spacing: 20) {
                    ForEach(items) { item in
                        PlayerItemCardView(item) {
                            config.selectedPlaterItem = item
                            withAnimation(.easeInOut(duration: 0.3)) {
                                config.showMiniPlayer = true
                            }
                        }
                    }
                }
                .padding(15)
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.background, for: .navigationBar)
    }
    
    @ViewBuilder
    func PlayerItemCardView(_ item: PlayerItem, onTap: @escaping () -> ()) -> some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Image(item.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .onTapGesture(perform: onTap)
            HStack(alignment: .top) {
                Image(item.image)
                    .resizable()
                    .frame(width:40, height: 40)
                    .clipShape(Circle())
                    .padding(.horizontal, 5)
                VStack(alignment:.leading) {
                    Text(item.title)
                        .foregroundStyle(.foreground)
                    HStack(spacing: 6) {
                        Text(item.author)
                            .foregroundStyle(.gray)
                            .font(.system(size: 15))
                        Text(" 2 Days Ago")
                            .foregroundStyle(.gray)
                            .font(.system(size: 15))
                    }
                }
            }
        })
    }
    
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack {
            ForEach(UnderTab.allCases, id: \.self) { tab in
                VStack(spacing: 4) {
                    Image(systemName: tab.symbol)
                        .font(.title3)
                    Text(tab.rawValue)
                        .font(.caption2)
                }
                .foregroundStyle(activeTab == tab ? Color.primary : .gray)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipShape(.rect)
                .onTapGesture {
                    activeTab = tab
                }
            }
        }
        .overlay(alignment: .top) {
            Divider()
        }
        .frame(height: tabBarHeight)
        .background(.background)
    }
    
}

extension View {
    @ViewBuilder
    func setupTab(_ tab: UnderTab) -> some View {
        self
            .tag(tab)
            .toolbar(.hidden, for: .tabBar)
    }
    
    var safeArea: UIEdgeInsets {
        if let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets {
            return safeArea
        }
        return .zero
    }
    
    var tabBarHeight: CGFloat {
        return 49 + safeArea.bottom
    }
}

#Preview {
    MiniPlayerHomeView()
}


