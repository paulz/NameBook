import SwinjectStoryboard
import Swinject

extension Resolver {
    public func get<Service>() -> Service? {
        return resolve(Service.self)
    }
}

extension Container {
    func inject<C: Controller>(_ controllerType: C.Type, initCompleted: @escaping (C) -> ()) {
        storyboardInitCompleted(C.self) { (_, controller) in
            initCompleted(controller)
        }
    }
}
