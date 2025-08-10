//
//  HistoryItemViewPlain.swift
//  QRead
//
//  Created by Jan on 09.08.25.
//

import SwiftUI

struct HistoryItemViewPlain: View {
    let item: HistoryItem
    let data: PlainData

    var body: some View {
        HistoryItemViewBase(
            item: item,
            iconName: "text.document",
            header: "Plain text",
            performCopy: {
                $0.setString(data.text, forType: .string)
            }
        ) {
            Text(data.text)
        }
    }
}

#Preview {
    return HistoryItemViewPlain(
        item: HistoryItem(""),
        data: PlainData(text: "This is example text. It could be very very long.")
    )
}
