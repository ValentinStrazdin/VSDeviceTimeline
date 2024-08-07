import Foundation

extension NSRecursiveLock: Locking {
    public func withCritical<Result>(_ section: () throws -> Result) rethrows -> Result {
        if !`try`() {
            lock()
        }

        defer {
            unlock()
        }

        return try section()
    }
}
