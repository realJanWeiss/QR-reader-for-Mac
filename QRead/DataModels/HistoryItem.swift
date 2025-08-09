//
//  File.swift
//  QRead
//
//  Created by Jan on 29.07.25.
//

import Foundation

protocol HistoryItem: Identifiable, Codable {
    var id: UUID { get }
    var dateScanned: Date { get }
    
    static var type: String { get }
    static func parse(from text: String) throws -> Self
}
