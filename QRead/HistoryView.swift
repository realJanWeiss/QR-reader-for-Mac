//
//  HistoryView.swift
//  QRead
//
//  Created by Jan on 10.08.25.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var historyManager: QRCodeHistoryManager

    var body: some View {
        VStack(alignment: .leading) {
            Text("QR Code History")
                .font(.headline)
                .padding(.horizontal)
                .shadow(
                    color: Color(NSColor.windowBackgroundColor).opacity(0.3), radius: 3, x: 0, y: 2
                )
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(historyManager.history, id: \.id) { historyItem in
                        HistoryItemView(item: historyItem)
                    }
                }
            }
        }
        .padding(.top)
    }
}
