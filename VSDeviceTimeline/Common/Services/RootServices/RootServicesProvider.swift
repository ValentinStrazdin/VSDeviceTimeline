import Foundation

class RootServicesProvider: NSObject {

    // MARK: - Internal Properties

    var rootServicesContainer: RootServicesContainer {
        rootServicesContainerImpl
    }

    // MARK: - Private Properties

    private let rootServicesContainerImpl: RootServicesContainerImpl

    // MARK: - Init

    init(rootServicesContainerImpl: RootServicesContainerImpl) {
        self.rootServicesContainerImpl = rootServicesContainerImpl
        super.init()
    }

}
