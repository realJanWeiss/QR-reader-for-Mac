//
//  ContactData.swift
//  QRead
//
//  Created by Jan on 29.07.25.
//

import Foundation
import Contacts

struct ContactData: HistoryItem {
    var id: UUID
    var dateScanned: Date
    var contacts: [Contact]

    static var type: String { "contact" }
    
    static func parse(from text: String) throws -> ContactData {
        let contacts = try CNContactVCardSerialization.contacts(with: text.data(using: .utf8)!)
        return .init(id: UUID(), dateScanned: Date(), contacts: contacts.map { Contact(contact: $0) })
    }
}

struct Contact: Codable {
    var givenName: String
    var familyName: String
    var phoneNumbers: [String]
    
    init(givenName: String, familyName: String, phoneNumbers: [String]) {
        self.givenName = givenName
        self.familyName = familyName
        self.phoneNumbers = phoneNumbers
    }
    
    init(contact: CNContact) {
        self.givenName = contact.givenName
        self.familyName = contact.familyName
        self.phoneNumbers = contact.phoneNumbers.map { $0.value.stringValue }
    }
}
