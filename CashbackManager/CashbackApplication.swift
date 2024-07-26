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
	
	private var container: ModelContainer {
		try! ModelContainer(for: Card.self, Cashback.self, Domain.Category.self)
	}
	
    var body: some Scene {
        WindowGroup {
			RootCoordinator(urlParser: appFactory.makeWidgetURLParser(with: container))
        }
		.modelContainer(container)
    }
}
