import UIKit
import StoreKit

class OrganizationViewController: UIViewController {
    @IBOutlet var namelyAppButton: UIButton!
    @IBOutlet var notEnoughContactsLabel: UILabel!
    var warningLabelTemplate: String!

    var application: UIApplication!
    var contactsService: ContactsService!

    @IBAction func showNamelyApp() {
        if isNamelyAppInstalled() {
            openNamelyApp()
        } else {
            openNamelyInAppStore()
        }
    }

    func openNamelyApp() {
        return application.open(URL(string: "namely://profiles")!)
    }

    func openNamelyInAppStore() {
        // https://itunes.apple.com/us/app/namely/id1053112477?mt=8
        let productController: SKStoreProductViewController = SKStoreProductViewController()
        productController.delegate = self
        productController.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier:1053112477])
        self.present(productController, animated: true)
    }

    func isNamelyAppInstalled() -> Bool {
        return application.canOpenURL(URL(string: "namely://profiles")!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        warningLabelTemplate = notEnoughContactsLabel.text
        namelyAppButton.setTitle(isNamelyAppInstalled() ? "Open Namely app": "Install Namely app", for: .normal)
        checkCountAndMoveOn()
    }

    func checkCountAndMoveOn() {
        let namelyContacts = contactsService.getContacts(serviceName: "Namely")
        let enoughToPlay = namelyContacts.count > 5
        if enoughToPlay {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "have enough contacts to play", sender: self)
            }
        } else {
            notEnoughContactsLabel.text = warningLabelTemplate.replacingOccurrences(of: "0", with: "\(namelyContacts.count)")
            contactsService.onChange {
                self.checkCountAndMoveOn()
            }
        }
    }
}

extension OrganizationViewController: SKStoreProductViewControllerDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        dismiss(animated: true)
    }
}
