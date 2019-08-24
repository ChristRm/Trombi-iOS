//
//  AppDelegate.swift
//  Trombi
//
//  Created by Christian Rusin  on 22/11/2018.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainViewModel = MainTabBarViewViewModel()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        prepareUIelementsBarProxies()
        prepareTabBarProxy()

        guard let mainTabBarViewController =
            UIStoryboard.main.instantiateInitialViewController() as? MainTabBarViewController else {
                fatalError("Could not load MainTabBarViewViewModel")
        }

        window = UIWindow(frame: UIScreen.main.bounds)

        mainTabBarViewController.viewModel = mainViewModel
        window?.rootViewController = mainTabBarViewController
        window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }

    // MARK: - Private
    private func prepareUIelementsBarProxies() {
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = UIColor.mainWhiteColor
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        UINavigationBar.appearance().titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.mainBlackColor,
             NSAttributedString.Key.font: UIFont.semiBoldAppFontOf(size: 17)]

        UITabBar.appearance().backgroundColor = UIColor.mainWhiteColor

        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes =
                [NSAttributedString.Key.foregroundColor: UIColor.mainBlackColor,
                 NSAttributedString.Key.font: UIFont.semiBoldAppFontOf(size: 28)]
        } else {
            // Fallback on earlier versions
        }
    }

    private func prepareTabBarProxy() {
        let normalTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(redInt: 142, greenInt: 142, blueInt: 147, alpha: 1.0),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10.0)
        ]
        let selectedTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(redInt: 33, greenInt: 33, blueInt: 33, alpha: 1.0),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10.0)
        ]

        UITabBarItem.appearance().setTitleTextAttributes(normalTextAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(selectedTextAttributes, for: .selected)
    }
}
