import UIKit

class ViewController: UIViewController {
    var contactsService: ContactsService = ContactsService()
    var gameController: GameController!

    override func viewDidLoad() {
        super.viewDidLoad()
        let orgContacts = contactsService.getContacts(organizationName: "Omada Health")
        gameController = GameController(contacts: orgContacts)
    }
}
