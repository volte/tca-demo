import UIKit
import SwiftUI
import ComposableArchitecture

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        self.window = (scene as? UIWindowScene).map(UIWindow.init(windowScene:))
        self.window?.rootViewController = UIHostingController(rootView: RootView())
        self.window?.makeKeyAndVisible()
    }
}
