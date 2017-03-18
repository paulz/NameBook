import Foundation
import Contacts
import ContactsUI

struct ContactsService {
    let contactStore = CNContactStore()


    func contact(identifier:String) -> CNContact? {
        let descriptor = CNContactViewController.descriptorForRequiredKeys()
        return try? contactStore.unifiedContact(withIdentifier: identifier, keysToFetch: [descriptor])
    }

    func editContact(identifier:String) -> UIViewController? {
        if let unified = contact(identifier: identifier) {
            let controller = CNContactViewController.init(for: unified)
            controller.shouldShowLinkedContacts = true
            return controller
        }
        return nil
    }

    func getContacts(serviceName: String) -> [String] {
        let stringKeys = [
            CNContactOrganizationNameKey,
            CNContactImageDataAvailableKey,
            CNContactSocialProfilesKey,
            CNContactTypeKey
        ]
        let request = CNContactFetchRequest(keysToFetch: stringKeys as [CNKeyDescriptor])
        var contacts: Set<CNContact> = Set()
        var organizationNames: Set<String> = Set()
        try? contactStore.enumerateContacts(with: request) { (contact, _) in
            if contact.socialProfiles.contains(where: { $0.value.service == serviceName }),
                contact.contactType == .person,
                !contact.organizationName.isEmpty,
                contact.imageDataAvailable {
                organizationNames.insert(contact.organizationName)
                contacts.insert(contact)
            }
        }
        try? contactStore.enumerateContacts(with: request) { (contact, _) in
            if organizationNames.contains(contact.organizationName),
                contact.contactType == .person,
                contact.imageDataAvailable {
                contacts.insert(contact)
            }
        }
        print(contacts.count)
        return Array(contacts.map{$0.identifier})
    }
}

extension ContactsService {
    var hasAccess: Bool {
        return contactsAccess == .authorized
    }

    var isAccessDenied: Bool {
        return [.denied, .restricted].contains(contactsAccess)
    }

    func promptForAccess(onComplete:@escaping ()->()) {
        contactStore.requestAccess(for: CNEntityType.contacts) { (success, error) in
            onComplete()
        }
    }

    private var contactsAccess: CNAuthorizationStatus {
        return CNContactStore.authorizationStatus(for: .contacts)
    }
}
