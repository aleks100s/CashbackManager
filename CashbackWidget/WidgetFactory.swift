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
	static func makeCardsService() -> CardsService? {
		guard let container = try? ModelContainer(for: Card.self, Cashback.self, Domain.Category.self) else { return nil }
		
		let context = ModelContext(container)
		return CardsService(context: context)
	}
}
