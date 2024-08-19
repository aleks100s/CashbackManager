//
//  ICategoryService.swift
//
//
//  Created by Alexander on 20.08.2024.
//

public protocol ICategoryService {
	func getAllCategories() -> [Category]
	func getCategory(by name: String) -> Category?
	@discardableResult
	func createCategory(name: String) -> Category
}
