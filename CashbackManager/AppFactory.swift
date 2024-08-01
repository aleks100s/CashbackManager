//
//  AppFactory.swift
//  CashbackManager
//
//  Created by Alexander on 30.07.2024.
//

import Domain
import SwiftData

enum AppFactory {
	private static var container = try! ModelContainer(for: Card.self, Cashback.self, Domain.Category.self, Place.self)
	
	static func provideModelContainer() -> ModelContainer {
		container
	}
}
