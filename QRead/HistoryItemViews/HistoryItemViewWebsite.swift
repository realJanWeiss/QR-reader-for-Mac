//
//  HistoryItemViewWebsite.swift
//  QRead
//
//  Created by Jan on 09.08.25.
//

import SwiftUI

struct HistoryItemViewWebsite: View {
    let item: HistoryItem
    let data: WebsiteData
    
    var body: some View {
        HistoryItemViewBase(item: item, iconName: "link", header: "Website") {
            Text(data.url)
        } actions: {
            Button("open", action: {})
        }
    }
}

#Preview {
    HistoryItemViewWebsite(
        item: HistoryItem(""),
        data: WebsiteData(url: "https://www.google.com")
    )
}
