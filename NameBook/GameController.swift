import Foundation

struct GameController {
    let gameContacts: Set<String>
    var queueToPlay: [String] = []
    var choices: [String] = []
    var correct: Int = -1

    init(contacts: [String]) {
        gameContacts = Set(contacts)
    }

    func correctChoice() -> String {
        return choices[correct]
    }

    mutating func isCorrect(selection:Int) -> Bool {
        let won = correct == selection
        if !won {
            queueToPlay.insert(choices[selection], at: 0)
            queueToPlay.insert(choices[correct], at: 0)
            queueToPlay.shuffle()
        }
        return won
    }

    mutating func nextRound()  {
        if queueToPlay.count < 6 {
            queueToPlay = Array(gameContacts)
            queueToPlay.shuffle()
        }
        choices = randomContacts(count: 6)
        correct = Int(arc4random_uniform(UInt32(choices.count)))
    }

    mutating func randomContacts(count: Int) -> [String] {
        var selected: [String] = []
        for _ in 1...count {
            if queueToPlay.count == 0 {
                break
            }
            let random = Int(arc4random_uniform(UInt32(queueToPlay.count)))
            let contact = queueToPlay[random]
            queueToPlay.remove(at: random)
            selected.append(contact)
        }
        return selected
    }
}
