//
//  AppFactory.swift
//  CashbackManager
//
//  Created by Alexander on 30.07.2024.
//

import Domain
import SwiftData

enum AppFactory {
	static func provideModelContainer() -> ModelContainer {
		try! ModelContainer(for: Card.self, Cashback.self, Domain.Category.self, Place.self)
	}
}
