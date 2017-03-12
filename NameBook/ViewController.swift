import UIKit

class ViewController: UIViewController {
    var contactsService: ContactsService = ContactsService()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(contactsService.getContacts())
    }
}
