import SwinjectStoryboard
import Swinject


extension Container {
    func registerServices() {
        register(ContactsService.self) { _ in ContactsService() }.inObjectScope(.container)
        register(UIApplication.self) { _ in UIApplication.shared }
    }
    func registerViewControllers() {
        inject(PermissionViewController.self) {
            $0.contactsService = self.get()
        }
        inject(FaceCollectionViewController.self) {
            $0.contactsService = self.get()
        }
        inject(OrganizationViewController.self) {
            $0.application = self.get()
            $0.contactsService = self.get()
        }
        inject(LearnCollectionViewController.self) {
            $0.contactsService = self.get()
        }
        inject(RotatingNavigationViewController.self) {_ in}
    }
}

extension SwinjectStoryboard {
    class func setup() {
        defaultContainer.registerServices()
        defaultContainer.registerViewControllers()
    }
}
