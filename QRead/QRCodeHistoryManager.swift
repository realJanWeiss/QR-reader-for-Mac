//
//  HistoryModel.swift
//  QRead
//
//  Created by Jan on 29.07.25.
//

import Combine
import Foundation

class QRCodeHistoryManager: ObservableObject {
    @Published var history: [any HistoryItem] = []
    
    private let historyFileURL: URL = {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent("QRCodeHistory.json")
    }()
    
    init() {
        loadHistory()
    }
    
    func addHistoryItem(_ item: any HistoryItem) {
        history.insert(item, at: 0)
        saveHistory()
    }

    func removeHistoryItem(withId id: UUID) {
        if let index = history.firstIndex(where: { $0.id == id }) {
            history.remove(at: index)
            saveHistory()
        }
    }
    
   private func saveHistory() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(history.map(AnyHistoryItem.init))
            try data.write(to: historyFileURL)
        } catch {
            print("Failed to save history: \(error)")
        }
    }

    private func loadHistory() {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: historyFileURL)
            let anyItems = try decoder.decode([AnyHistoryItem].self, from: data)
            history = anyItems.map { $0.base }
        } catch {
            print("Failed to load history: \(error)")
        }
    }
}
