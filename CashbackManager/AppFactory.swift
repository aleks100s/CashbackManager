//
//  AppFactory.swift
//  CashbackManager
//
//  Created by Alexander on 27.06.2024.
//

import Foundation
import CashbackService
import CategoryService

final class AppFactory {
	private lazy var cashbackService = CashbackService()
	private lazy var categoryService = CategoryService()
	
	func makeServiceContainer() -> ServiceContainer {
		ServiceContainerImpl(cashbackService: cashbackService, categoryService: categoryService)
	}
	
	func makeWidgetURLParser() -> WidgetURLParser {
		WidgetURLParser(cashbackService: cashbackService)
	}
}
