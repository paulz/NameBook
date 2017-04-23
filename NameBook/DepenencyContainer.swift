import Swinject

class DepenencyContainer {
    static var defaultContainer = Container()
    class func resolve<Service>() -> Service {
        return defaultContainer.resolve(Service.self)!
    }
}
