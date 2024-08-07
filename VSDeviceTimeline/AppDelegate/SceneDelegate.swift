//
//  SceneDelegate.swift
//  VSDeviceTimeline
//
//  Created by Valentin Strazdin on 06.08.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Internal  Properties

    var window: UIWindow?

    // MARK: - Private Properties

    private let appLifecycleHandler: ApplicationLifecycleHandler = ApplicationLifecycleHandlerImpl.shared

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        window = appLifecycleHandler.scene(scene, willConnectTo: session, options: connectionOptions)
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }

}

