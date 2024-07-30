//
//  PlaterConfig.swift
//  MultiProject
//
//  Created by window1 on 7/30/24.
//

import SwiftUI

struct PlaterConfig: Equatable {
    var position: CGFloat = .zero
    var lastPosition: CGFloat = .zero
    var progress: CGFloat = .zero
    var selectedPlaterItem: PlayerItem?
    var showMiniPlayer: Bool = false
    
    mutating func resetPostion() {
        position = .zero
        lastPosition = .zero
        progress = .zero 
    }
}
