//
//  HeroKey.swift
//  NavigationEffect
//
//  Created by window1 on 7/23/24.
//

import SwiftUI

struct HeroKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
    
    
}
