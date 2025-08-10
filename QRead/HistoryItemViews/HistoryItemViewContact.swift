//
//  HistoryItemViewContact.swift
//  QRead
//
//  Created by Jan on 09.08.25.
//

import SwiftUI

struct HistoryItemViewContact: View {
    let item: HistoryItem
    let data: ContactData

    var body: some View {
        HistoryItemViewBase(item: item, iconName: "person.crop.circle", header: "Contact") {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(Array(data.contacts.enumerated()), id: \.offset) { index, contact in
                    VStack(alignment: .leading) {
                        Text(contact.givenName + " " + contact.familyName)
                        ForEach(Array(contact.phoneNumbers.enumerated()), id: \.offset) { index, phoneNumber in
                            Text(phoneNumber)
                        }
                    }
                }
            }
        } actions: {
            Button("save", action: {})
        }
    }
}

#Preview {
    HistoryItemViewContact(
        item: HistoryItem(
            "",
        ),
        data: ContactData(
            contacts: [
                Contact(givenName: "Jan", familyName: "Foo", phoneNumbers: ["+43 1234 56789"]),
                Contact(givenName: "Max", familyName: "Mustermann", phoneNumbers: ["+43 4567 89123", "+43 4321 98765"])
            ]
        )
    )
}
