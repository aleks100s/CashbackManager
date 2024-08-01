//
//  WidgetFactory.swift
//  CashbackManager
//
//  Created by Alexander on 26.07.2024.
//

import CardsService
import Domain
import SwiftData

enum WidgetFactory {
	static func makeCardsService() -> ICardsService? {
		let container = AppFactory.provideModelContainer()
		let context = ModelContext(container)
		return CardsService(context: context)
	}
}
