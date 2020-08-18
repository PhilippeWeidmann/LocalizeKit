//
//  AppDelegate.swift
//  LocalizeKit-Example
//
//  Created by Philippe Weidmann on 17/08/2020.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import UIKit
import LocalizeKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        print("test".pluralLocalizedWith(0))
        print("test".pluralLocalizedWith(1))
        print("test".pluralLocalizedWith(10))
        return true
    }

}

