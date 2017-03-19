import Foundation
import Contacts
import ContactsUI

struct ContactsService {
    let contactStore = CNContactStore()

    func contact(identifier:String) -> CNContact? {
        let descriptor = CNContactViewController.descriptorForRequiredKeys()
        return try? contactStore.unifiedContact(withIdentifier: identifier, keysToFetch: [descriptor])
    }

    func onChange(_ block: @escaping ()->()) {
        let center = NotificationCenter.default
        var token: NSObjectProtocol?
        token = center.addObserver(forName: .CNContactStoreDidChange, object: nil, queue: nil) { _ in
            block()
            center.removeObserver(token!)
        }
    }

    func editContact(identifier:String) -> UIViewController? {
        if let unified = contact(identifier: identifier) {
            let controller = CNContactViewController.init(for: unified)
            controller.shouldShowLinkedContacts = true
            return controller
        }
        return nil
    }

    func organizations() -> [String:Int] {
        var organizations:[String:Int] = [:]
        let stringKeys = [
            CNContactOrganizationNameKey,
            CNContactImageDataAvailableKey,
            CNContactSocialProfilesKey,
            CNContactTypeKey
        ]
        let request = CNContactFetchRequest(keysToFetch: stringKeys as [CNKeyDescriptor])
        try? contactStore.enumerateContacts(with: request) { (contact, _) in
            if contact.contactType == .person {
                let organization = contact.organizationName
                if !organization.isEmpty {
                    let count = organizations[organization] ?? 0
                    organizations[organization] = count + 1
                }
            }
        }
        let tuples = organizations.filter { name, count in
            return count > 6
        }
        var result:[String:Int] = [:]
        tuples.forEach { name, count in
            result[name] = count
        }
        return result
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
        NSLog("found \(contacts.count) \(serviceName) contacts")
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
