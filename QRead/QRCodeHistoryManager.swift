//
//  HistoryModel.swift
//  QRead
//
//  Created by Jan on 29.07.25.
//

import Combine
import Foundation

class QRCodeHistoryManager: ObservableObject {
    @Published var history: [AnyHistoryItem] = [] // "any HistoryItem" breaks reactivity in View ...
    
    private let historyFileURL: URL = {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent("QRCodeHistory.json")
    }()
    
    init() {
        loadHistory()
    }
    
    func addHistoryItem(_ item: any HistoryItem) {
        history.insert(AnyHistoryItem(item), at: 0)
        saveHistory()
    }

    func removeHistoryItem(withId id: UUID) {
        if let index = history.firstIndex(where: { $0.id == id }) {
            history.remove(at: index)
            saveHistory()
        }
    }
    
    func clearHistory() {
        history.removeAll()
        saveHistory()
    }
    
   private func saveHistory() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(history)
            try data.write(to: historyFileURL)
        } catch {
            print("Failed to save history: \(error)")
        }
    }

    private func loadHistory() {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: historyFileURL)
            history = try decoder.decode([AnyHistoryItem].self, from: data)
        } catch {
            print("Failed to load history: \(error)")
        }
    }
}
