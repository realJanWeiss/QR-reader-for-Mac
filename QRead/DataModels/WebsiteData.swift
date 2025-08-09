//
//  WebsiteData.swift
//  QRead
//
//  Created by Jan on 29.07.25.
//

import Foundation

struct WebsiteData: HistoryItem {
    var id: UUID
    var dateScanned: Date
    var url: String

    static var type: String { "website" }
    
    static func parse(from text: String) throws -> WebsiteData {
        let url = URL(string: text.trimmingCharacters(in: .whitespacesAndNewlines))
        let scheme = url!.scheme
        if (!["http", "https"].contains(scheme)) {
            throw ParseError.invalidFormat
        }

        return .init(
            id: UUID(),
            dateScanned: Date(),
            url: text
        )
    }
}
