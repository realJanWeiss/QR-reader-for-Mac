//
//  HistoryItemView.swift
//  QRead
//
//  Created by Jan on 29.07.25.
//

import SwiftUI

struct HistoryItemView: View {
    let item: HistoryItem

    var body: some View {
        switch item.data.base {
        case let data as ContactData:
            HistoryItemViewContact(item: item, data: data)

        case let data as WebsiteData:
            HistoryItemViewWebsite(item: item, data: data)

        case let data as PlainData:
            HistoryItemViewPlain(item: item, data: data)

        default:
            EmptyView()
        }
    }
}
