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
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                
                Text("Scanned on")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                Text(dateFormatter.string(from: item.dateScanned))
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            Text("message")
                .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .shadow(radius: 5)
                
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

#Preview {
    return HistoryItemView(item: PlainData(id: UUID(), dateScanned: Date(), text: "This is example text. It could be very very long."))
}
