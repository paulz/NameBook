import SwinjectStoryboard
import Swinject

extension SwinjectStoryboard {
    class func setup() {
        defaultContainer.register(ContactsService.self) { _ in ContactsService() }
        defaultContainer.register(UIApplication.self) { _ in UIApplication.shared }
        defaultContainer.storyboardInitCompleted(PermissionViewController.self) { r, c in
            c.contactsService = r.resolve(ContactsService.self)!
        }
        defaultContainer.storyboardInitCompleted(FaceCollectionViewController.self) { r, c in
            c.contactsService = r.resolve(ContactsService.self)!
        }
        defaultContainer.storyboardInitCompleted(OrganizationViewController.self) { r, c in
            c.application = r.resolve(UIApplication.self)!
            c.contactsService = r.resolve(ContactsService.self)!
        }
        defaultContainer.storyboardInitCompleted(LearnCollectionViewController.self) { r, c in
            c.contactsService = r.resolve(ContactsService.self)!
        }
    }
}
