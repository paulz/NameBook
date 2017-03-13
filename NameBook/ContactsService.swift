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
            return UINavigationController(rootViewController: controller)
        } else {
            return nil
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
