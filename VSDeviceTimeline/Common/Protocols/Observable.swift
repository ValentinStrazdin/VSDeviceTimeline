import Foundation

/// Describes an instance that can be observed
public protocol Observable {

    /// Type of observers
    associatedtype Observer

    /// All observers that subscribed to changes
    var observers: ObserversCollection<Observer> { get }

    /// Adds a new observer
    ///
    /// - Parameter observer: observer that will be listening for changes
    func addObserver(_ observer: Observer)

    /// Removes an existing observer
    ///
    /// - Parameter observer: observer that should be removed
    func removeObserver(_ observer: Observer)
}

extension Observable {

    public func addObserver(_ observer: Observer) {
        observers.add(observer)
    }

    public func removeObserver(_ observer: Observer) {
        observers.remove(observer)
    }

    public func add(observer: Observer) {
        addObserver(observer)
    }

    public func remove(observer: Observer) {
        removeObserver(observer)
    }

}

/// Container for observers
public final class ObserversCollection<Observer> {

    // MARK: - Private Properties

    private let observers = NSHashTable<AnyObject>.weakObjects()
    private let lock = NSRecursiveLock()

    // MARK: - Init

    /// Creates an instance
    public init() { /* Do nothing */ }

    // MARK: - Public Methods

    public func isAdded(_ observer: Observer) -> Bool {
        return lock.withCritical {
            let observerAsObject = observer as AnyObject
            return observers.contains(observerAsObject)
        }
    }

    /// Adds a new observer
    ///
    /// - Parameter observer: observer that will be listening for changes
    public func add(_ observer: Observer) {
        lock.withCritical {
            guard !isAdded(observer) else {
                NSLog("<WARNING>: Attempt to add observer (\(observer)) which had been added already")
                return
            }

            let observer = observer as AnyObject
            observers.add(observer)
        }
    }

    /// Add all observers from given collection to receiver
    ///
    /// - Parameter collection: Collection to add observers from
    public func add(from collection: ObserversCollection<Observer>) {
        let otherObservers = collection.getAllObservers()
        for observer in otherObservers {
            add(observer)
        }
    }

    /// Removes an existing observer
    ///
    /// - Parameter observer: observer that should be removed
    public func remove(_ observer: Observer) {
        lock.withCritical {
            guard isAdded(observer) else {
                NSLog("<WARNING>: Attempt to remove observer (\(observer)) which hasn't been added yet")
                return
            }

            let observer = observer as AnyObject
            observers.remove(observer)
        }
    }

    /// Remove all observers from collection
    public func removeAll() {
        lock.withCritical {
            observers.removeAllObjects()
        }
    }

    /// Move all observers to given colletion. All observers will be removed from the receiver
    ///
    /// - Parameter collection: Collection to move observers to
    public func move(to collection: ObserversCollection<Observer>) {
        lock.withCritical {
            collection.add(from: self)
            removeAll()
        }
    }

    /// Iterates over all contained observers with `closure`
    ///
    /// - Parameter closure: closure to be called with every observer
    public func notify(with closure: (Observer) -> ()) {
        for observer in getAllObservers() {
            closure(observer)
        }
    }

    // MARK: - Private Methods

    /// Thread safe get all observers
    ///
    /// - Returns: All observers added to collection by the call time
    private func getAllObservers() -> [Observer] {
        return lock.withCritical { Array(observers.allObjects as! [Observer]) }
    }

}
