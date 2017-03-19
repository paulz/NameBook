import UIKit

class RotatingNavigationViewController: UINavigationController {
    var storyboardTextAttributes: [String : Any]?

    override func awakeFromNib() {
        super.awakeFromNib()
        storyboardTextAttributes = navigationBar.titleTextAttributes
    }

    override func willTransition(to newCollection: UITraitCollection,
                                 with coordinator: UIViewControllerTransitionCoordinator) {
        let isVertical = newCollection.verticalSizeClass == .regular
        useStoryboardTitleAttributes(isVertical)
        hidePromptInTransition(with: coordinator)
    }
}

extension RotatingNavigationViewController {
    func useStoryboardTitleAttributes(_ custom:Bool) {
        navigationBar.titleTextAttributes = custom ? storyboardTextAttributes : [:]
    }

    func hidePromptInTransition(with coordinator: UIViewControllerTransitionCoordinator) {
        let prompt = navigationBar.topItem?.prompt
        navigationBar.topItem?.prompt = nil
        coordinator.animate(alongsideTransition: nil) { _ in
            self.navigationBar.topItem?.prompt = prompt
        }
    }
}
