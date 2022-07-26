//
//  SceneDelegate.swift
//  Test
//
//  Created by wei on 2021/7/28.
//
import UIKit
import Foundation

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var photoViewController = PhotoViewController()
    
    var photoWithCollectionViewController = PhotoWithCollectionViewController()
    
    let myTabBar = UITabBarController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        
        self.window?.backgroundColor = UIColor(red: 236/255, green: 238/255, blue: 241/255, alpha: 1.0)
        
       
        let photoNavigationController = UINavigationController(rootViewController: photoViewController)
        
        
        let photoWithCollectionNavigationController = UINavigationController(rootViewController: photoWithCollectionViewController)
        photoNavigationController.tabBarItem =
        UITabBarItem(tabBarSystemItem: .bookmarks, tag: 100)
        photoWithCollectionNavigationController.tabBarItem =
        UITabBarItem(tabBarSystemItem: .favorites, tag: 100)
        
   
        myTabBar.viewControllers = [photoNavigationController, photoWithCollectionNavigationController]
        myTabBar.selectedIndex = 0
      
        self.window?.rootViewController = myTabBar
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
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
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

