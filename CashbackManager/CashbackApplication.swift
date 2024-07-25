//
//  CashbackApplication.swift
//  CashbackManager
//
//  Created by Alexander on 10.06.2024.
//

import Domain
import SwiftData
import SwiftUI

@main
struct CashbackApplication: App {
	private let appFactory = AppFactory()
	
    var body: some Scene {
        WindowGroup {
			RootCoordinator(
				serviceContainer: appFactory.makeServiceContainer(),
				urlParser: appFactory.makeWidgetURLParser()
			)
        }
		.modelContainer(for: [Card.self, Cashback.self, Domain.Category.self])
    }
}
