import UIKit
import StoreKit

class OrganizationViewController: UIViewController {
    @IBOutlet var namelyAppButton: UIButton!
    @IBOutlet var groupPickerView: UIPickerView!
    var application: UIApplication!

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
    }
}

extension OrganizationViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
}

extension OrganizationViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Namely"
    }
}

extension OrganizationViewController: SKStoreProductViewControllerDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        dismiss(animated: true)
    }
}
