import Foundation
import Contacts

struct ContactsService {
    func getContacts() -> [CNContact] {
        CNContactStore().requestAccess(for: CNEntityType.contacts) { (success, error) in
            print(success)
        }
        return []
    }
}
