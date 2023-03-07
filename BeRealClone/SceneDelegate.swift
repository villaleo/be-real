//
//  SceneDelegate.swift
//  lab-insta-parse
//
// Created by Leonardo Villalobos on 3/5/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    public enum Scenes: String {
        typealias RawValue = String
        
        /// Switch to the feed Navigation Controller
        case feed = "showFeed"
        /// Switch to the login Navigation Controller
        case login = "showLogin"
    }
    
    private enum Constants {
        static let loginNavigationControllerIdentifier = "LoginNavigationController"
        static let feedNavigationControllerIdentifier = "FeedNavigationController"
        static let storyboardIdentifier = "Main"
    }

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let _ = (scene as? UIWindowScene) else { return }

        addObserversToNotificationCenter()
        if User.current != nil {
            showFeed()
        }
    }
    
    private func addObserversToNotificationCenter() {
        NotificationCenter.default.addObserver(
            forName: Notification.Name(Scenes.feed.rawValue),
            object: nil,
            queue: OperationQueue.main,
            using: { [weak self] _ in
                self?.showFeed()
            }
        )
        NotificationCenter.default.addObserver(
            forName: Notification.Name(Scenes.login.rawValue),
            object: nil,
            queue: OperationQueue.main,
            using: { [weak self] _ in
                self?.showLogin()
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
    
    private func showLogin() {
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
    
    static func showScene(named: Scenes, withData: Any? = nil) {
        NotificationCenter.default.post(
            name: Notification.Name(named.rawValue),
            object: withData
        )
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
