import UIKit

class PermissionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        proceedWhenGranted()
    }

    func proceedWhenGranted() {
        if contactsService.hasAccess {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "can access contacts", sender: self)
            }
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

