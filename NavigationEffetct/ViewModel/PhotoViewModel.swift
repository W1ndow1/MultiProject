//
//  PhotoViewModel.swift
//  NavigationEffect
//
//  Created by window1 on 7/18/24.
//

import Foundation

class PhotoViewModel: ObservableObject {
    
    @Published var data: [DataModel] = []
    
    
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
        
        self.data = imgList.enumerated().map { index, name in
            DataModel(value: "\(name)", index: index)
        }
    }
    
}
