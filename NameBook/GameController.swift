import Foundation

struct GameController {
    let gameContacts: [String]
    var queueToPlay: [String]
    var choices: [String] = []
    var correct: Int = -1

    init(contacts: [String]) {
        gameContacts = contacts
        queueToPlay = gameContacts
        queueToPlay.shuffle()
    }

    func correctChoice() -> String {
        return choices[correct]
    }

    func isCorrect(selection:Int) -> Bool {
        return correct == selection
    }

    mutating func nextRound()  {
        choices = randomContacts(count: 6)
        correct = Int(arc4random_uniform(UInt32(choices.count)))
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
