import UIKit
import StoreKit

class OrganizationViewController: UIViewController {
    @IBOutlet var namelyAppButton: UIButton!
    @IBOutlet var notEnoughContactsLabel: UILabel!

    var application: UIApplication!
    var contactsService: ContactsService!
    var organizations: [String: Int] = [:]
    var organizationNames: [String] = []

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
        namelyAppButton.setTitle(isNamelyAppInstalled() ? "Open Namely app": "Install Namely app", for: .normal)
        organizations = contactsService.organizations()
        organizationNames = organizations.keys.sorted()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if organizationNames.count > 0 {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "have enough contacts to play", sender: self)
            }
        }
    }
}

extension OrganizationViewController: SKStoreProductViewControllerDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        dismiss(animated: true)
    }
}
