

import SwiftUI

let dummyDescription: String = """
국무총리는 국무위원의 해임을 대통령에게 건의할 수 있다. 대통령의 임기가 만료되는 때에는 임기만료 70일 내지 40일전에 후임자를 선거한다. 국회의원은 법률이 정하는 직을 겸할 수 없다. 한 회계연도를 넘어 계속하여 지출할 필요가 있을 때에는 정부는 연한을 정하여 계속비로서 국회의 의결을 얻어야 한다. 모든 국민은 언론·출판의 자유와 집회·결사의 자유를 가진다. 
"""

struct PlayerItem: Identifiable, Equatable {
    let id: UUID = .init()
    var title: String
    var author: String
    var image: String
    var description: String = dummyDescription
}

var items: [PlayerItem] = [
    .init(title: "Apple Vision Pro - Unboxing, Review and Demos",
          author: "GokMulCookie",
          image: "Pic_1"),
    .init(title: "Kevin Durant You are GOAT",
          author: "조코피",
          image: "Pic_2"),
    .init(title: "혼자서 4인분 대왕뚜껑 먹으며 프랑스 이야기",
          author: "침착맨",
          image: "Pic_3"),
    .init(title: "티몬, 위메프 '기업회생시청'",
          author: "슈카월드",
          image: "Pic_4"),
    .init(title: "올림픽은 언제부터 막장화가 되었을까?",
          author: "지식해적단",
          image: "Pic_5"),
]
