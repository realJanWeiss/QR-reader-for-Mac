import Foundation

struct AnyHistoryItemData: HistoryItemData {
    let base: HistoryItemData

    static var type: String {
        "any"
    }

    init(_ base: HistoryItemData) {
        self.base = base
    }

    static func parse(from text: String) throws -> AnyHistoryItemData {
        throw ParseError.invalidFormat
    }

    init(from decoder: Decoder) throws {
        throw ParseError.invalidFormat
    }
}
