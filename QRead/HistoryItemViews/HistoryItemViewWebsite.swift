//
//  HistoryItemViewWebsite.swift
//  QRead
//
//  Created by Jan on 09.08.25.
//

import SwiftUI

struct HistoryItemViewWebsite: View {
    let item: WebsiteData
    
    var body: some View {
        HistoryItemViewBase(item: item, iconName: "link", header: "Website") {
            Text(item.url)
        } actions: {
            Button("open", action: {})
        }
    }
}

#Preview {
    HistoryItemViewWebsite(item: WebsiteData(id: UUID(), dateScanned: Date(), url: "https://www.google.com"))
}
