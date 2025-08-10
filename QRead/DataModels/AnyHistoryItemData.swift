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

    func encode(to encoder: Encoder) throws {
        try base.encode(to: encoder)
    }

    init(from decoder: Decoder) throws {
        // You need to implement decoding logic based on a type discriminator
        throw ParseError.invalidFormat
    }
}
