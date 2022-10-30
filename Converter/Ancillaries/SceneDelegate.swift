//
//  SceneDelegate.swift
//  Converter
//
//  Created by Misha Causur on 28.10.2022.
//
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        guard let window = window else { return }
        let coordinator = Coordinator(window)
        coordinator.start()
    }
}
