import UIKit

open class ContainerViewController: UIViewController {

    // MARK: - Open properties

    open override var childForStatusBarHidden: UIViewController? {
        return embeddedViewController
    }

    open override var childForStatusBarStyle: UIViewController? {
        return embeddedViewController
    }

    open var containerView: UIView {
        return view
    }

    // MARK: - Internal properties

    private(set) var embeddedViewController: UIViewController? {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    // MARK: - Init

    convenience init(embeddedViewController: UIViewController) {
        self.init()
        self.embeddedViewController = embeddedViewController
    }

    // MARK: - Open methods

    open override func viewDidLoad() {
        super.viewDidLoad()

        if let embeddedViewController = embeddedViewController {
            embed(child: embeddedViewController, currentChild: nil)
        }
    }

    open func onWillEmbed(child: UIViewController, currentChild: UIViewController?) {
        // Do nothing
    }

    open func onDidEmbed(child: UIViewController, previousChild: UIViewController?) {
        handleStatusBarUpdateForTransition(child: child, previousChild: previousChild)
    }

    // MARK: - Public methods

    final func embed(child: UIViewController) {
        let currentChild = embeddedViewController
        embeddedViewController = child

        guard isViewLoaded else {
            // ViewController's view is not loaded at the moment. In order to avoid the
            // force loading of view store view controller and attach it later (in |viewDidLoad|).

            // Invoke completion handler right away, clients should treat this situation as successful embedding
            return
        }

        embed(child: child, currentChild: currentChild)
    }

    // MARK: - Private Methods

    private func embed(child: UIViewController, currentChild: UIViewController?) {
        currentChild?.willMove(toParent: nil)
        addChild(child)

        onWillEmbed(child: child, currentChild: currentChild)

        let onEmbedFinish = { [weak self] in
            guard let this = self else {
                return
            }

            currentChild?.removeFromParent()
            child.didMove(toParent: this)

            this.onDidEmbed(child: child, previousChild: currentChild)
        }

        switchWithoutAnimation(from: currentChild, to: child)
        onEmbedFinish()
    }

    private func switchWithoutAnimation(from currentChild: UIViewController?, to newChild: UIViewController) {
        if let currentChild = currentChild, currentChild.isViewLoaded {
            currentChild.view.removeFromSuperview()
        }

        containerView.addSubview(newChild.view)
        newChild.view.frame = containerView.bounds
        newChild.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    // MARK: - Status Bar

    private func handleStatusBarUpdateForTransition(child: UIViewController, previousChild: UIViewController?) {
        guard let previousChild = previousChild else {
            return
        }

        // Signal `setNeedsStatusBarAppearanceUpdate` only if status bar styles differ.
        if child.preferredStatusBarStyle != previousChild.preferredStatusBarStyle {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

}
