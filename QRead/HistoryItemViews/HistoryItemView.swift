//
//  HistoryItemView.swift
//  QRead
//
//  Created by Jan on 29.07.25.
//

import SwiftUI

struct HistoryItemView: View {
    let item: any HistoryItem

    var body: some View {
        if let contact = item as? ContactData {
            HistoryItemViewContact(item: contact)
        } else if let plain = item as? PlainData {
            HistoryItemViewPlain(item: plain)
        } else if let website = item as? WebsiteData {
            HistoryItemViewWebsite(item: website)
        } else {
            EmptyView()
        }
    }
}
