import UIKit

public protocol ApplicationLifecycleHandler: AnyObject {

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) -> UIWindow?

}

class ApplicationLifecycleHandlerImpl: ApplicationLifecycleHandler {

    // MARK: - Internal Properties

    static let shared: ApplicationLifecycleHandler = ApplicationLifecycleHandlerImpl()

    private var rootRouter: ViewableRouter? {
        willSet {
            if let currentRouter = rootRouter {
                assertionFailure("Root router supposed to be set once. Going to replace current root router <\(currentRouter)> with new one <\(String(describing: newValue))>")
            }
        }
    }

    // MARK: - Public Methods

    open func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) -> UIWindow? {
        guard let windowScene = (scene as? UIWindowScene) else {
            assertionFailure("Couldn't cast scene to UIWindowScene: <\(scene)>")
            return nil
        }

        let window = makeWindowForSession(using: windowScene)

        return window
    }

    // MARK: - Private Methods

    private func makeWindowForSession(using windowScene: UIWindowScene) -> UIWindow {
        let window = UIWindow(windowScene: windowScene)
        configure(window)

        return window
    }

    private func configure(_ window: UIWindow) {
        // Method `scene(_:willConnectTo:options:)` may be called multiple times.
        // For instance, on iOS 13 this method is sometimes called when the application is being closed by user via swipe.
        // This leads to multiple calls to `makeWindowForSession(using windowScene:)`, which triggers `configure(_ window:)` each time.
        // To prevent unnecessary `rootRouter`'s deinit, we make sure to reuse it instead.
        if let currentRootRouter = rootRouter {
            window.rootViewController = currentRootRouter.viewController
        }
        else {
            let router = makeRootRouter()
            window.rootViewController = router.viewController
            rootRouter = router
            router.start()
        }

        window.makeKeyAndVisible()
    }

    private func makeRootRouter() -> ViewableRouter {
        RootBuilder().build()
    }

}
