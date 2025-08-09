//
//  HistoryItemViewPlain.swift
//  QRead
//
//  Created by Jan on 09.08.25.
//

import SwiftUI

struct HistoryItemViewPlain: View {
    let item: PlainData

    var body: some View {
        HistoryItemViewBase(item: item, iconName: "text.document", header: "Plain text") {
            Text(item.text)
        }
    }
}

#Preview {
    return HistoryItemViewPlain(item: PlainData(id: UUID(), dateScanned: Date(), text: "This is example text. It could be very very long."))
}
