//
//  AppFactory.swift
//  CashbackManager
//
//  Created by Alexander on 27.06.2024.
//

import Foundation
import CashbackService
import CategoryService
import PersistanceManager

final class AppFactory {
	private lazy var persistanceManager = PersistanceManager(defaults: UserDefaults(suiteName: "group.com.alextos.cashback"))
	private lazy var cashbackService = CashbackService(persistanceManager: persistanceManager)
	private lazy var categoryService = CategoryService(persistanceManager: persistanceManager)
	
	func makeServiceContainer() -> ServiceContainer {
		ServiceContainerImpl(cashbackService: cashbackService, categoryService: categoryService)
	}
}
