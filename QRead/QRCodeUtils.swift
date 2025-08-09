//
//  QRCodeUtils.swift
//  QRead
//
//  Created by Jan on 29.07.25.
//

import Foundation

class QRCodeUtils {
    
    static func historyItemFromQRCode(_ qrCode: String) -> any HistoryItem {
        do {
            return try ContactData.parse(from: qrCode)
        } catch {
            do {
                return try WebsiteData.parse(from: qrCode)
            } catch {
                return PlainData.parse(from: qrCode)
            }
        }
    }
}
