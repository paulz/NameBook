import UIKit
import Contacts

private let reuseIdentifier = "contact cell"

class LearnCollectionViewController: UICollectionViewController {
    var contactsService: ContactsService!
    var contactIds: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        contactIds = contactsService.getContacts()
        fitWithoutScroll()
    }

    private func fitWithoutScroll() {
        if let flow = collectionView!.collectionViewLayout as? UICollectionViewFlowLayout {
            let widthMax = collectionView!.bounds.width / 2
            let heightMax = collectionView!.bounds.height / 2
            let heightOptimal = widthMax * 3 / 2
            var optimal: CGSize
            if heightOptimal > heightMax {
                optimal = CGSize(width: heightMax / 3 * 2, height: heightMax)
            } else {
                optimal = CGSize(width: widthMax, height: heightOptimal)
            }
            if flow.itemSize != optimal {
                flow.itemSize = optimal
                flow.invalidateLayout()
            }
        }
    }

    private func onTransitionInContext(context:UIViewControllerTransitionCoordinatorContext) {
        fitWithoutScroll()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: onTransitionInContext, completion: onTransitionInContext)
    }

    func dismissContact() {
        presentedViewController?.dismiss(animated: true, completion: {
            self.collectionView?.reloadData()
        })
    }

    @IBAction func onLongPress(_ sender: UILongPressGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.began){
            let locationInView = sender.location(in: self.collectionView)

            if let indexPath = collectionView?.indexPathForItem(at: locationInView) {
                if let controller = contactsService.editContact(identifier: contactIds[indexPath.row]) {
                    controller.navigationItem.backBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                                  target: self,
                                                                                  action: #selector(dismissContact))
                    present(UINavigationController(rootViewController: controller), animated: true)
                }
            }
        }
    }

}

// MARK: UICollectionViewDataSource
extension LearnCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contactIds.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ContactCollectionViewCell
        cell.configure(with: contactsService.contact(identifier: contactIds[indexPath.row])!)
        return cell
    }
}
