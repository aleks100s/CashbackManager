//
//  ServiceContainer.swift
//  CashbackManager
//
//  Created by Alexander on 20.06.2024.
//

import Foundation

protocol ServiceContainer {
	var cashbackService: ICashbackService { get }
	var categoryService: ICategoryService { get }
}

@Observable
final class ServiceContainerImpl: ServiceContainer {
	let cashbackService: ICashbackService
	let categoryService: ICategoryService
	
	init(cashbackService: ICashbackService, categoryService: ICategoryService) {
		self.cashbackService = cashbackService
		self.categoryService = categoryService
	}
}
