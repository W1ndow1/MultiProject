//
//  DataModel.swift
//  NavigationEffect
//
//  Created by window1 on 7/17/24.
//

import Foundation

struct DataModel: Identifiable, Equatable {
    var id: String = UUID().uuidString
    var value: String?
    var index: Int?
}


