//
//  AnyHistoryItem.swift
//  QRead
//
//  Created by Jan on 29.07.25.
//

import Foundation

struct AnyHistoryItem: Codable, Identifiable {
    var id: UUID { get { base.id }}
    let base: any HistoryItem

    enum CodingKeys: String, CodingKey {
        case type
        case payload
    }

    init(_ base: any HistoryItem) {
        self.base = base
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch base {
            case let item as PlainData:
                try container.encode(PlainData.type, forKey: .type)
                try container.encode(item, forKey: .payload)
            case let item as WebsiteData:
                try container.encode(WebsiteData.type, forKey: .type)
                try container.encode(item, forKey: .payload)
            case let item as ContactData:
                try container.encode(ContactData.type, forKey: .type)
                try container.encode(item, forKey: .payload)
            default:
                let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Unknown HistoryItem type")
                throw EncodingError.invalidValue(base, context)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
            case PlainData.type:
                let item = try container.decode(PlainData.self, forKey: .payload)
                base = item
            case WebsiteData.type:
                let item = try container.decode(WebsiteData.self, forKey: .payload)
                base = item
            case ContactData.type:
                let item = try container.decode(ContactData.self, forKey: .payload)
                base = item
            default:
                throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown HistoryItem type: \(type)")
        }
    }
}
