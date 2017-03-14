import Foundation
import Contacts

struct GameController {
    let gameContacts: [CNContact]
    var queueToPlay: [CNContact]
    var choices: [CNContact] = []
    var correct: CNContact!

    init(contacts: [CNContact]) {
        gameContacts = contacts
        queueToPlay = gameContacts
        queueToPlay.shuffle()
    }

    func isCorrect(selection:Int) -> Bool {
        return choices.index(of: correct) == selection
    }

    mutating func nextRound()  {
        choices = randomContacts(count: 6)
        let selected = Int(arc4random_uniform(UInt32(choices.count)))
        correct = choices[selected]
    }

    func randomContacts(count: Int) -> [CNContact] {
        var selection = gameContacts
        var selected: [CNContact] = []
        for _ in 1...count {
            if selection.count == 0 {
                break
            }
            let random = Int(arc4random_uniform(UInt32(selection.count)))
            let contact = selection[random]
            selection.remove(at: random)
            selected.append(contact)
        }
        return selected
    }
}
