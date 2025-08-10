//
//  HistoryItemViewBase.swift
//  QRead
//
//  Created by Jan on 09.08.25.
//

import SwiftUI

struct HistoryItemViewBase<Content: View, Actions: View>: View {
    let item: HistoryItem
    let iconName: String?
    let header: String?
    let content: Content
    let actions: Actions?
    
    @EnvironmentObject var historyManager: QRCodeHistoryManager
    @State private var isHovered = false

    init(item: HistoryItem, iconName: String? = nil,  header: String? = nil, @ViewBuilder content: () -> Content, @ViewBuilder actions: () -> Actions = { EmptyView() }) {
        self.item = item
        self.iconName = iconName
        self.header = header
        self.content = content()
        self.actions = actions()
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            mainContent
            
            if isHovered {
                DeleteButtonBubble(onRemove: onRemove)
                    .transition(.scale.combined(with: .opacity))
                    .padding(-6)
            }
        }
        .padding(.top, 8)
        .padding(.horizontal, 8)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
    }
    
    private var mainContent: some View {
        HStack(alignment: .top, spacing: 12) {
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
           
            VStack(alignment: .leading, spacing: 4) {
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
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
    
    private func onRemove() {
        historyManager.removeHistoryItem(withId: self.item.id)
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

#Preview {
    HistoryItemViewBase(
        item: HistoryItem(
            "This is example text. It could be very very long."
        ),
        iconName: "text.document",
        header: "Category"
    ) {
        Text("Content")
    } actions: {
        Button("Action", action: {})
    }
    .frame(maxWidth: 400)
}
