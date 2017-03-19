import UIKit

class NavigationViewController: UINavigationController {
    var navigationBarTitleTextAttributes: [String : Any]?

    override func awakeFromNib() {
        super.awakeFromNib()
        navigationBarTitleTextAttributes = navigationBar.titleTextAttributes
    }

    override func willTransition(to newCollection: UITraitCollection,
                                 with coordinator: UIViewControllerTransitionCoordinator) {
        let isVertical = newCollection.verticalSizeClass == .regular
        setCustomTitleAttributes(isVertical)
        hidePromptInTransition(with: coordinator)
    }

    func setCustomTitleAttributes(_ custom:Bool) {
        navigationBar.titleTextAttributes = custom ? navigationBarTitleTextAttributes : [:]
    }

    func hidePromptInTransition(with coordinator: UIViewControllerTransitionCoordinator) {
        let prompt = navigationBar.topItem?.prompt
        navigationBar.topItem?.prompt = nil
        coordinator.animate(alongsideTransition: nil) { _ in
            self.navigationBar.topItem?.prompt = prompt
        }
    }
}
