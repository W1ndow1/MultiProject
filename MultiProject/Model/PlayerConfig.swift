

import SwiftUI

struct PlayerConfig: Equatable {
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
