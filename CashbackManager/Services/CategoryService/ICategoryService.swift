//
//  ICategoryService.swift
//  CashbackManager
//
//  Created by Alexander on 17.06.2024.
//

import Domain

protocol ICategoryService {
	func getCategories() -> [Domain.Category]
	func save(category: Domain.Category)
}
