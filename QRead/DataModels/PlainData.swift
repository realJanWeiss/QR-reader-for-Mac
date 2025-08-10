//
//  PlainData.swift
//  QRead
//
//  Created by Jan on 29.07.25.
//

import Foundation

struct PlainData: HistoryItemData {
    var text: String

    static var type: String { "plain" }
    
    static func parse(from text: String) -> PlainData {
        return .init(text: text)
    }
}
