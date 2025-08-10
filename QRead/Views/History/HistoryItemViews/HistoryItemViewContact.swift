//
//  HistoryItemViewContact.swift
//  QRead
//
//  Created by Jan on 09.08.25.
//

import SwiftUI
import Contacts

struct HistoryItemViewContact: View {
    let item: HistoryItem
    let data: ContactData

    var body: some View {
        HistoryItemViewBase(
            item: item,
            iconName: "person.crop.circle",
            header: "Contact",
            performCopy: performCopy
        ) {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(Array(data.contacts.enumerated()), id: \.offset) { _, contact in
                    VStack(alignment: .leading) {
                        Text(contact.givenName + " " + contact.familyName)
                        ForEach(Array(contact.phoneNumbers.enumerated()), id: \.offset) { _, labeledValue in
                            Text(labeledValue.value.stringValue)
                        }
                    }
                }
            }
        } actions: {
            Button("Save", action: saveContact)
        }
    }
    
    private func performCopy(nsPasteboard: NSPasteboard) -> Void {
        let contactsAsString = data.contacts
            .map({
                $0.givenName + " " + $0.familyName + ", " +
                $0.phoneNumbers.map { $0.value.stringValue }.joined(separator: ", ")
            })
            .joined(separator: "\n")
        nsPasteboard.setString(contactsAsString, forType: .string)
    }
    
    private func saveContact() {
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { granted, error in
            if granted && error == nil {
                let saveRequest = CNSaveRequest()
                for contact in data.contacts {
                    saveRequest.add(contact.mutableCopy() as! CNMutableContact, toContainerWithIdentifier: nil)
                }
                
                do {
                    try store.execute(saveRequest)
                    print("Contact saved successfully!")
                } catch {
                    print("Error saving contact: \(error)")
                }
            } else {
                print("Access to contacts denied.")
            }
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
                {
                    let contact = CNMutableContact()
                    contact.givenName = "Max"
                    contact.familyName = "Mustermann"
                    contact.phoneNumbers = [
                        CNLabeledValue<CNPhoneNumber>(
                            label: CNLabelWork,
                            value: CNPhoneNumber(stringValue: "+43 1234567890")
                        )
                    ]
                    return contact.copy() as! CNContact
                }(),
                {
                    let contact = CNMutableContact()
                    contact.givenName = "Jan"
                    contact.familyName = "Test"
                    contact.phoneNumbers = [
                        CNLabeledValue<CNPhoneNumber>(
                            label: CNLabelHome,
                            value: CNPhoneNumber(stringValue: "+43 0987654321")
                        )
                    ]
                    return contact.copy() as! CNContact
                }()
            ]
        )
    )
}
