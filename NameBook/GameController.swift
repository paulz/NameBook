import Foundation
import Contacts

struct GameController {
    let gameContacts: [CNContact]

    init(contacts: [CNContact]) {
        gameContacts = contacts
    }

    func randomContacts(count: Int) -> [CNContact] {
        var selection = gameContacts
        var selected: [CNContact] = []
        for _ in 0...count {
            let random = Int(arc4random()) % selection.count
            let contact = selection[random]
            selection.remove(at: random)
            selected.append(contact)
        }
        return selected
    }
}
