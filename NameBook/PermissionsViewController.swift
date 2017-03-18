import UIKit

class PermissionViewController: UIViewController {
    var contactsService: ContactsService!

    override func viewDidLoad() {
        super.viewDidLoad()
        proceedWhenGranted()
    }

    func proceedWhenGranted() {
        if contactsService.hasAccess {
            performSegue(withIdentifier: "start game", sender: self)
        }
    }

    func openSettings() {
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
    }

    @IBAction func onAllowContactsAccess() {
        if contactsService.isAccessDenied {
            openSettings()
        } else {
            contactsService.promptForAccess(onComplete: proceedWhenGranted)
        }
    }
}
