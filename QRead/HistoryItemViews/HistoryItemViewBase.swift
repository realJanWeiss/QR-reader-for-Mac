//
//  HistoryItemViewBase.swift
//  QRead
//
//  Created by Jan on 09.08.25.
//

import SwiftUI

struct HistoryItemViewBase<Content: View, Actions: View>: View {
    let item: any HistoryItem
    let iconName: String?
    let header: String?
    let content: Content
    let actions: Actions?

    init(item: any HistoryItem, iconName: String? = nil,  header: String? = nil, @ViewBuilder content: () -> Content, @ViewBuilder actions: () -> Actions = { EmptyView() }) {
        self.item = item
        self.iconName = iconName
        self.header = header
        self.content = content()
        self.actions = actions()
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Group {
                if let iconName {
                    Image(systemName: iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28)
                        .foregroundStyle(.secondary)
                } else {
                    Color.clear
                        .frame(width: 28, height: 0)
                }
            }
           
            VStack(alignment: .leading) {
                HStack {
                    if let header {
                        Text(header)
                            .font(.headline)
                    }
                    
                    Spacer()
                    
                    Text("Scanned")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                    Text(dateFormatter.string(from: item.dateScanned))
                        .font(.caption)
                        .foregroundColor(.primary)
                    
                }
                content
                    .foregroundColor(.primary)
                HStack {
                    actions
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
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
    return HistoryItemViewBase(item: PlainData(id: UUID(), dateScanned: Date(), text: "This is example text. It could be very very long."), iconName: "text.document", header: "Category"
    ) {
        Text("Content")
    } actions: {
        Button("Action", action: {})
    }
}
