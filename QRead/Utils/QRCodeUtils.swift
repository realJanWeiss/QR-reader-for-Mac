//
//  QRCodeUtils.swift
//  QRead
//
//  Created by Jan on 29.07.25.
//

import Foundation

class QRCodeUtils {
    
    static func historyItemDataFromQRCode(_ qrCode: String) -> AnyHistoryItemData {
        var data: HistoryItemData
        do {
            data = try ContactData.parse(from: qrCode)
        } catch {
            do {
                data = try WebsiteData.parse(from: qrCode)
            } catch {
                data = PlainData.parse(from: qrCode)
            }
        }
        return AnyHistoryItemData(data)
    }
}
