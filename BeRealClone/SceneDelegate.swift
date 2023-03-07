//
//  SceneDelegate.swift
//  lab-insta-parse
//
//  Created by Charlie Hieger on 10/29/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private enum Constants {
        static let loginNavigationControllerIdentifier = "LoginNavigationController"
        static let feedNavigationControllerIdentifier = "FeedNavigationController"
        static let storyboardIdentifier = "Main"
        
        static let showFeed = "showFeed"
        static let logout = "logout"
    }

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window`
        // to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be
        // initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new
        // (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }

        addObserversToNotificationCenter()
        if User.current != nil {
            showFeed()
        }
    }
    
    private func addObserversToNotificationCenter() {
        NotificationCenter.default.addObserver(
            forName: Notification.Name(Constants.showFeed),
            object: nil,
            queue: OperationQueue.main,
            using: { [weak self] _ in
                self?.showFeed()
            }
        )
        NotificationCenter.default.addObserver(
            forName: Notification.Name(Constants.logout),
            object: nil,
            queue: OperationQueue.main,
            using: { [weak self] _ in
                self?.logout()
            }
        )
    }

    private func showFeed() {
        let storyboard = UIStoryboard(
            name: Constants.storyboardIdentifier,
            bundle: nil
        )
        self.window?.rootViewController = storyboard.instantiateViewController(
            withIdentifier: Constants.feedNavigationControllerIdentifier
        )
    }
    
    private func logout() {
        User.logout { [weak self] result in
            switch result {
            case .success():
                let storyboard = UIStoryboard(
                    name: Constants.storyboardIdentifier,
                    bundle: nil
                )
                self?.window?.rootViewController = storyboard.instantiateViewController(
                    withIdentifier: Constants.loginNavigationControllerIdentifier
                )
            case .failure(let error):
                fatalError("\(error.message)")
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session
        // is discarded.
        // Release any resources associated with this scene that can be re-created the next
        // time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded
        // (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started)
        // when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough
        // scene-specific state information to restore the scene back to its current
        // state.
    }
}
