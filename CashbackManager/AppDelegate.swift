//
//  AppDelegate.swift
//  CashbackManager
//
//  Created by Alexander on 25.01.2025.
//

import UIKit
import YandexMobileAds

final class AppDelegate: UIResponder, UIApplicationDelegate {
	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		MobileAds.initializeSDK()
		return true
	}
}
