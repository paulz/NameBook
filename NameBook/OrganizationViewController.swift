import UIKit
import StoreKit

class OrganizationViewController: UIViewController {
    @IBOutlet var namelyAppButton: UIButton!
    @IBOutlet var notEnoughContactsLabel: UILabel!
    var warningLabelTemplate: String!

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

    func downloadDemoContacts(_ action:UIAlertAction) {
        UIApplication.shared.open(URL(string: "https://s3.amazonaws.com/name-game/sample-contacts.vcf")!)
    }

    @IBAction func skipAndPlayAll() {
        contactsService.selectedServiceName = nil
        let allContacts = contactsService.getContacts()
        if allContacts.count < 6 {
            let alert = UIAlertController(title: "Not enough contacts", message: "You have \(allContacts.count) contacts with photos and you need at least dozen to play this game", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Download Demo Contacts", style: UIAlertActionStyle.destructive, handler: downloadDemoContacts))
            present(alert, animated: true)
        } else {
            stopWaitingAndPlay()
        }
    }

    func stopWaitingAndPlay() {
        if let token = observer {
            NotificationCenter.default.removeObserver(token)
        }
        performSegue(withIdentifier: "have enough contacts to play", sender: self)
    }

    var observer: NSObjectProtocol? = nil

    func checkCountAndMoveOn() {
        let namelyContacts = contactsService.getContacts()
        let enoughToPlay = namelyContacts.count > 5
        if enoughToPlay {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "have enough contacts to play", sender: self)
            }
        } else {
            notEnoughContactsLabel.text = warningLabelTemplate.replacingOccurrences(of: "0", with: "\(namelyContacts.count)")
            observer = contactsService.onChange {
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
