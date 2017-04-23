import Swinject

extension Container {
    func registerServices() {
        register(ContactsService.self) { _ in ContactsService() }.inObjectScope(.container)
        register(UIApplication.self) { _ in UIApplication.shared }
    }
}

extension DepenencyContainer {
    class func setup() {
        defaultContainer.registerServices()
    }
}
