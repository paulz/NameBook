import Foundation
import Contacts

struct ContactsService {
    let contactStore = CNContactStore()

    init() {
        contactStore.requestAccess(for: CNEntityType.contacts) { (success, error) in
            print(success)
        }
    }

    func getContacts(organizationName: String) -> [CNContact] {
        let stringKeys = [
            CNContactGivenNameKey,
            CNContactOrganizationNameKey,
            CNContactJobTitleKey,
            CNContactThumbnailImageDataKey,
            CNContactImageDataAvailableKey,
            CNContactNicknameKey
        ]
        var keysToFetch: [CNKeyDescriptor] = [CNContact.descriptorForAllComparatorKeys()]
        keysToFetch.append(contentsOf: stringKeys as [CNKeyDescriptor])
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        var contacts: [CNContact] = []
        try? contactStore.enumerateContacts(with: request) { (contact, more) in
            if contact.organizationName == organizationName {
                print(contact)
                contacts.append(contact)
            }
        }
        print(contacts.count)
        return contacts
    }
}
