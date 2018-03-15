//
//  AppDelegate.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 2/24/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit
import SwiftyBeaver
let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let cloud = SBPlatformDestination(appID: "2kYevm", appSecret: "14YRoe6w9Izu4cetuIpib1lGf4CSAshg", encryptionKey: "7pjnpc0vdxnhfoewzoSQpVUoTbGuwVsr") // to cloud
        
        log.addDestination(cloud)
        
        return true
    }

}

