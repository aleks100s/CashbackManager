//
//  AppFactory.swift
//  CashbackManager
//
//  Created by Alexander on 27.06.2024.
//

import Domain
import Foundation
import CardsService
import CategoryService
import SwiftData

final class AppFactory {	
	func makeWidgetURLParser(with container: ModelContainer) -> WidgetURLParser {
		WidgetURLParser(cardsService: CardsService(context: ModelContext(container)))
	}
}
