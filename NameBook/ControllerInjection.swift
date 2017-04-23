import UIKit

extension PermissionViewController: WithContactsService {}
extension FaceCollectionViewController: WithContactsService {}
extension OrganizationViewController: WithContactsService {}
extension LearnCollectionViewController: WithContactsService {}
extension OrganizationViewController {
    var application: UIApplication { return DepenencyContainer.resolve() }
}

protocol WithContactsService {
    var contactsService: ContactsService {get}
}

extension WithContactsService {
    var contactsService: ContactsService { return DepenencyContainer.resolve() }
}
