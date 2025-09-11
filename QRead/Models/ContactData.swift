//
//  ContactData.swift
//  QRead
//
//  Created by Jan on 29.07.25.
//

import Foundation
import Contacts

struct ContactData: HistoryItemData {
    var contacts: [CNContact]

    static var type: String { "contact" }

    static func parse(from text: String) throws -> ContactData {
        guard let data = text.data(using: .utf8) else {
            throw ParseError.invalidFormat
        }
        
        let contacts = try CNContactVCardSerialization.contacts(with: data)
        
        if contacts.isEmpty {
            throw ParseError.invalidFormat
        }
        
        return .init(
            contacts: contacts
        )
    }
}
