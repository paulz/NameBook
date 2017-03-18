import UIKit

class PermissionViewController: UIViewController {
    var contactsService: ContactsService!

    override func viewDidLoad() {
        super.viewDidLoad()
        if contactsService.hasAccess {
            moveOn()
        }
    }

    func moveOn() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "start game", sender: self)
        }
    }

    func openSettings() {
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
    }

    @IBOutlet var actionButton: UIButton!

    @IBAction func onButtonTap(_ sender: UIButton) {
        if contactsService.isAccessDenied {
            openSettings()
        } else {
            contactsService.promptForAccess { granted in
                if granted {
                    self.moveOn()
                }
            }
        }
    }
}
