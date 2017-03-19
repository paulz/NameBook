import UIKit

class ReplaceRootControllerSegue: UIStoryboardSegue {
    func appWindow() -> UIWindow? {
        return UIApplication.shared.delegate?.window ?? nil
    }

    override func perform() {
        if let window = appWindow() {
            let performWithoutAnimation = {
                window.rootViewController = self.destination
            }
            if UIView.areAnimationsEnabled {
                UIView.transition(with: window,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations:performWithoutAnimation)
            } else {
                performWithoutAnimation()
            }
        }
    }
}
