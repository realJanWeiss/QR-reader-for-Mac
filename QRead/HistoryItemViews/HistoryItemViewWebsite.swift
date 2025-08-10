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
        HistoryItemViewBase(
            item: item,
            iconName: "link",
            header: "Website",
            performCopy: {
                $0.setString(data.url.absoluteString, forType: .URL)
            }
        ) {
            Text(data.url.absoluteString)
        } actions: {
            Button("Open", action: {
                NSWorkspace.shared.open(data.url)
            })
        }
    }
}

#Preview {
    HistoryItemViewWebsite(
        item: HistoryItem(""),
        data: WebsiteData(url: URL(string: "https://www.google.com")!)
    )
}
