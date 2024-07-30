//
//  Interpolation.swift
//  NavigationEffect
//
//  Created by window1 on 7/26/24.
//

import SwiftUI

extension CGFloat {
    func interpolation(inputRange: [CGFloat], ouputRange: [CGFloat]) -> CGFloat {
        let x = self
        let length = inputRange.count - 1
        if x <= inputRange[0] { return ouputRange[0] }
        
        for index in 1...length {
            let x1 = inputRange[index - 1]
            let x2 = inputRange[index]
            
            let y1 = ouputRange[index - 1]
            let y2 = ouputRange[index]
            
            ///Linear Interpolation Formula : y1 + ((y2-y1) / (x2-x1)) * (x - x1)
            if x <= inputRange[index] {
                let y = y1 + ((y2 - y1) / (x2 - x1)) * (x - x1)
                return y
            }
        }
        
        return ouputRange[length]
    }
}
