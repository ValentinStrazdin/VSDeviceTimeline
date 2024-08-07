/// The base router protocol that all routers should conform to.
public protocol Router: AnyObject {
    
    /// Start RIB, instantiate stack of child RIBs, activate interactor
    func start()
    
    /// Stop child RIBs, deactivate interactor
    func stop()
    
}

open class BaseRouter: Router {

    // MARK: - Public Properties

    public private(set) var children: [Router] = []

    // MARK: - Private Properties

    private var isActive = false
    private let interactor: Interactor

    // MARK: - Init

    init(interactor: Interactor) {
        self.interactor = interactor
    }

    // MARK: - Deinit

    deinit {
        guard isActive else {
            return
        }

        assertionFailure("Router should be stopped before deiniting")
    }

    // MARK: - Public Methods

    // MARK: Protocol Router

    open func start() {
        assert(!isActive, "Router is expected to be inactive")
        isActive = true
        interactor.start()
    }

    open func stop() {
        assert(isActive, "Router is expected to be active")
        isActive = false
        interactor.stop()
    }

    // MARK: Children manipulation

    /// Starts child router and maintains strong reference to it.
    ///
    /// - Parameter child: router to attach
    public final func attachChild(_ child: Router) {
        guard !children.contains(where: { $0 === child }) else {
            assertionFailure("Child is attached - \(child)")
            return
        }

        children.append(child)
        child.start()
    }

    /// Stops child router and removes strong reference to it.
    ///
    /// - Parameter child: router to detach
    public final func detachChild(_ child: Router) {
        guard let index = children.firstIndex(where: { $0 === child }) else {
            assertionFailure("Child is not attached - \(child)")
            return
        }

        child.stop()
        children.remove(at: index)
    }

    /// Stops all child routers and removes strong references.
    public final func detachChildren() {
        while !children.isEmpty {
            let child = children.removeFirst()
            child.stop()
        }
    }

}
