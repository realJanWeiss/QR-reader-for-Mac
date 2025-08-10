//
//  WebsiteData.swift
//  QRead
//
//  Created by Jan on 29.07.25.
//

import Foundation

struct WebsiteData: HistoryItemData {
    var url: URL

    static var type: String { "website" }
    
    static func parse(from text: String) throws -> WebsiteData {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: trimmed),
              let scheme = url.scheme,
              ["http", "https"].contains(scheme) else {
                throw ParseError.invalidFormat
        }
        return .init(url: url)
    }
}
