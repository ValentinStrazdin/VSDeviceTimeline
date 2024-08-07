/// An `Interactor` defines a unit of business logic that corresponds to a router unit.
///
/// The base interactor protocol that all interactors should conform to.
protocol Interactor: AnyObject {
    
    /// Prepare initial state, start observing of services
    ///
    /// - note: This method is internally invoked by the corresponding router. Application code should never explicitly
    ///   invoke this method.
    func start()
    
    /// Stop observing and discard current activities.
    ///
    /// - note: This method is internally invoked by the corresponding router. Application code should never explicitly
    ///   invoke this method.
    func stop()
    
}

class BaseInteractor: Interactor {

    // MARK: - Internal Properties

    private(set) var isActive = false

    // MARK: - Init

    init() { /* Do nothing */ }

    // MARK: - Deinit

    deinit {
        guard isActive else {
            return
        }

        assertionFailure("Interactor should be stopped before deiniting")
    }

    // MARK: - Protocol Interactor

    func start() {
        assert(!isActive, "Interactor is expected to be inactive")
        isActive = true
    }

    func stop() {
        assert(isActive, "Interactor is expected to be active")
        isActive = false
    }

}
