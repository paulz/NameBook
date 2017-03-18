import SwinjectStoryboard
import Swinject

extension SwinjectStoryboard {
    class func setup() {
        defaultContainer.storyboardInitCompleted(FaceCollectionViewController.self) { r, c in
            c.contactsService = r.resolve(ContactsService.self)!
        }
        defaultContainer.register(ContactsService.self) { _ in ContactsService() }
    }
}
