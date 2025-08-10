//
//  HistoryItemData.swift
//  QRead
//
//  Created by Jan on 29.07.25.
//

import Foundation

protocol HistoryItemData {
    static var type: String { get }
    static func parse(from text: String) throws -> Self
}

enum ParseError: Error {
    case invalidFormat
}
