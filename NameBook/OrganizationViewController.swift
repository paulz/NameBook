import UIKit
import StoreKit

class OrganizationViewController: UIViewController {
    @IBOutlet var namelyAppButton: UIButton!
    @IBOutlet var groupPickerView: UIPickerView!

    @IBAction func showNamelyApp() {
        if isNamelyAppInstalled() {
            openNamelyApp()
        } else {
            openNamelyInAppStore()
        }
    }

    func openNamelyApp() {
        let namelyUrl = URL(string: "namely://profiles")!
        return UIApplication.shared.open(namelyUrl)
    }

    func openNamelyInAppStore() {
        // https://itunes.apple.com/us/app/namely/id1053112477?mt=8
        let vc: SKStoreProductViewController = SKStoreProductViewController()
        let params = [
            SKStoreProductParameterITunesItemIdentifier:1053112477,
// TODO: Affiliate
//            SKStoreProductParameterAffiliateToken:"",
//            SKStoreProductParameterCampaignToken:""
        ]
        vc.delegate = self
        vc.loadProduct(withParameters: params)
        self.present(vc, animated: true)
    }

    func isNamelyAppInstalled() -> Bool {
        let namelyUrl = URL(string: "namely://profiles")!
        return UIApplication.shared.canOpenURL(namelyUrl)
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
