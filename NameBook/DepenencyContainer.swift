import Swinject

extension Container {
    func registerServices() {
        register(ContactsService.self) { _ in ContactsService() }.inObjectScope(.container)
        register(UIApplication.self) { _ in UIApplication.shared }
    }
}

class DepenencyContainer {
    static var defaultContainer = Container()
    class func setup() {
        defaultContainer.registerServices()
    }
}

public func resolve<Service>() -> Service {
    return DepenencyContainer.defaultContainer.get()!
}
