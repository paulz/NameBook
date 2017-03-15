import Foundation
import Contacts
import ContactsUI

struct ContactsService {
    let contactStore = CNContactStore()

    init() {
        contactStore.requestAccess(for: CNEntityType.contacts) { (success, error) in
            print(success)
        }
    }

    func editContact(contact:CNContact) -> UIViewController? {
        let descriptor = CNContactViewController.descriptorForRequiredKeys()
        if let unified = try? contactStore.unifiedContact(withIdentifier: contact.identifier, keysToFetch: [descriptor]) {
            let controller = CNContactViewController.init(for: unified)
            controller.allowsEditing = true
            return controller
        } else {
            return nil
        }
    }

    func getContacts(serviceName: String) -> [CNContact] {
        let stringKeys = [
            CNContactGivenNameKey,
            CNContactOrganizationNameKey,
            CNContactJobTitleKey,
            CNContactThumbnailImageDataKey,
            CNContactImageDataAvailableKey,
            CNContactNicknameKey,
            CNContactSocialProfilesKey
        ]
        var keysToFetch: [CNKeyDescriptor] = [CNContact.descriptorForAllComparatorKeys()]
        keysToFetch.append(contentsOf: stringKeys as [CNKeyDescriptor])
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        var contacts: Set<CNContact> = Set()
        var organizationNames: Set<String> = Set()
        try? contactStore.enumerateContacts(with: request) { (contact, more) in
            if contact.socialProfiles.contains(where: { $0.value.service == serviceName }),
                !contact.organizationName.isEmpty,
                contact.imageDataAvailable {
                organizationNames.insert(contact.organizationName)
                contacts.insert(contact)
            }
        }
        try? contactStore.enumerateContacts(with: request) { (contact, more) in
            if organizationNames.contains(contact.organizationName) {
                contacts.insert(contact)
            }
        }
        print(contacts.count)
        return Array(contacts)
    }
}
