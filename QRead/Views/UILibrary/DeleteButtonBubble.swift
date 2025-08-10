//
//  DeleteButtonBubble.swift
//  QRead
//
//  Created by Jan on 09.08.25.
//

import SwiftUI

struct DeleteButtonBubble: View {
    let onRemove: () -> Void
    
    var body: some View {
        Button {
            onRemove()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "xmark")
                Text("Delete")
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(NSColor.windowBackgroundColor).opacity(0.9))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
        .shadow(radius: 5)
    }
}

#Preview {
    DeleteButtonBubble(onRemove: {})
}
