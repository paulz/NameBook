import UIKit

class OrganizationViewController: UIViewController {
    @IBOutlet var namelyAppButton: UIButton!
    @IBOutlet var groupPickerView: UIPickerView!

    @IBAction func showNamelyApp() {
    }

    func isNamelyAppInstalled() -> Bool {
        return false
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
