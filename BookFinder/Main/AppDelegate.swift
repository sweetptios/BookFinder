//
//  AppDelegate.swift
// BookFinder
//
//  Created by mine on 2020/02/03.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    weak var window: UIWindow?
    var dependency: AppDependency?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        dependency = AppDependency.resolve()
        window = dependency?.window
        window?.makeKeyAndVisible()
        return true
    }
}

