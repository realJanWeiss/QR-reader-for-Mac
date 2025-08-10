//
//  HistoryItem.swift
//  QRead
//
//  Created by Jan on 29.07.25.
//

import Foundation

struct HistoryItem: Codable, Identifiable {
    var id: UUID
    let dateScanned: Date
    /** QR code payload */
    let payload: String
    /** QR code text parsed */
    let data: AnyHistoryItemData

    enum CodingKeys: String, CodingKey {
        case id
        case dateScanned
        case payload
    }

    init(_ qrCodePayload: String) {
        self.id = UUID()
        self.dateScanned = Date()
        self.payload = qrCodePayload
        self.data = QRCodeUtils.historyItemDataFromQRCode(qrCodePayload)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(dateScanned, forKey: .dateScanned)
        try container.encode(payload, forKey: .payload)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        dateScanned = try container.decode(Date.self, forKey: .dateScanned)
        payload = try container.decode(String.self, forKey: .payload)
        data = QRCodeUtils.historyItemDataFromQRCode(payload)
    }
}
