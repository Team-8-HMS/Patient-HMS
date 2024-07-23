//
//  Patient_HMSApp.swift
//  Patient-HMS
//
//  Created by Krsna Sharma on 04/07/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct Patient_HMSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            LogInView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
