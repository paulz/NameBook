import Foundation

struct GameController {
    let gameContacts: [String]
    var queueToPlay: [String]
    var choices: [String] = []
    var correct: String!

    init(contacts: [String]) {
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

    func randomContacts(count: Int) -> [String] {
        var selection = gameContacts
        var selected: [String] = []
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
