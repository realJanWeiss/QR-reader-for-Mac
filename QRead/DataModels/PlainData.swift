//
//  PlainData.swift
//  QRead
//
//  Created by Jan on 29.07.25.
//

import Foundation

struct PlainData: HistoryItem {
    var id: UUID
    var dateScanned: Date
    var text: String

    static var type: String { "plain" }
    
    static func parse(from text: String) -> PlainData {
        return .init(id: UUID(), dateScanned: Date(), text: text)
    }
}
