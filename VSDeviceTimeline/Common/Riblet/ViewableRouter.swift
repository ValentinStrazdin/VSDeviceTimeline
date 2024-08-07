import UIKit

/// The base protocol for all routers that own their own view controllers.
protocol ViewableRouter: Router {
    
    /// The base ViewController associated with this `Router`. The main point for binding with non-RIB architectures.
    var viewController: UIViewController { get }
    
}

class BaseViewableRouter: BaseRouter, ViewableRouter {

    // MARK: - Internal Properties
    
    var viewController: UIViewController

    // MARK: - Init

    init(interactor: Interactor, view: UIViewController) {
        self.viewController = view
        super.init(interactor: interactor)
    }

}
