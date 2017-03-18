import SwinjectStoryboard
import Swinject

extension SwinjectStoryboard {
    class func setup() {
        defaultContainer.register(ContactsService.self) { _ in ContactsService() }
        defaultContainer.storyboardInitCompleted(PermissionViewController.self) { r, c in
            c.contactsService = r.resolve(ContactsService.self)!
        }
        defaultContainer.storyboardInitCompleted(FaceCollectionViewController.self) { r, c in
            c.contactsService = r.resolve(ContactsService.self)!
        }
    }
}
