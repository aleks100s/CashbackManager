//
//  CashbackAppApplication.swift
//  CashbackApp
//
//  Created by Alexander on 10.06.2024.
//

import SwiftUI

@main
struct CashbackApplication: App {
	private let appFactory = AppFactory()
	
    var body: some Scene {
        WindowGroup {
			RootCoordinator(serviceContainer: appFactory.makeServiceContainer())
        }
    }
}
