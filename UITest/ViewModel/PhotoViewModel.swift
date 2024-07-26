//
//  PhotoViewModel.swift
//  NavigationEffect
//
//  Created by window1 on 7/18/24.
//

import SwiftUI

class PhotoViewModel: ObservableObject {
    
    @Published var data: [DataModel] = []
    @Published var selectedItem: DataModel?
    @Published var animateView: Bool = false
    @Published var showDetailView: Bool = false
    @Published var detailScrollPosition: String?
    @Published var detailIndicatorPosition: String?
    @Published var offset: CGSize = .zero
    @Published var dragProgress: CGFloat = 0
    
    init() {
        Task {
            await fetchImageName()
        }
    }
    
    
    func fetchImageName() async {
        let imgList = [
            "bobcat",
            "bullElk",
            "bullElkSparring",
            "bullTuleElkAndTwoFemales",
            "coyoteAndBison",
            "doubleRainbowLowerMammoth",
            "doubleRainbowYellowstone",
            "grizzly",
            "grizzlyCubs",
            "groundSquirrel",
            "harborSeal",
            "harborSealPup",
            "heartSpring",
            "newGrowthOfAntlers",
            "owlsAtMammoth",
            "rainbowAndBadlands",
            "redTailedHawk",
            "riverOtter",
            "soaringTheRainbow",
            "sunriseAtGrottoGeyser",
            "towerCreekBASIN",
            "yellowBelliedMarmot"
        ]
        
         let data = imgList.enumerated().map { index, name in
            DataModel(value: "\(name)", index: index)
        }
        
        await MainActor.run(body: {
            self.data = data
        })
    }
    
    func toggleView(show: Bool) {
        if show {
            detailScrollPosition = selectedItem?.id
            detailIndicatorPosition = selectedItem?.id
            withAnimation(.easeInOut(duration: 0.2), completionCriteria: .removed) {
                animateView = true
            } completion: {
                self.showDetailView = true
            }
        } else {
            showDetailView = false
            withAnimation(.easeInOut(duration: 0.2), completionCriteria: .removed) {
                animateView = false
                offset = .zero
            } completion: {
                self.resetAnimationProperties()
            }
        }
    }
    
    func resetAnimationProperties() {
        selectedItem = nil
        detailScrollPosition = nil
        offset = .zero
        dragProgress = 0
        detailIndicatorPosition = nil
    }
    
    func didDetailPageChanged() {
        if let updatedItem = data.first(where: { $0.id == detailScrollPosition}) {
            selectedItem = updatedItem
            //상단 ScrollView 움직임에 따라 하단 Indicator 순서 맞추기
            withAnimation(.easeInOut(duration: 0.2)) {
                detailIndicatorPosition = updatedItem.id
            }
        }
    }
    
    func didDetailIndicatorChanged() {
        if let updatedItem = data.first(where: { $0.id == detailIndicatorPosition}) {
            selectedItem = updatedItem
            //하단 Indicator 움직임에 따라 상단 ScrollView 순서 맞추기
            detailScrollPosition = updatedItem.id
        }
    }
}
