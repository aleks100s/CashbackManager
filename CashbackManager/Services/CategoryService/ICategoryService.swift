//
//  ICategoryService.swift
//  CashbackApp
//
//  Created by Alexander on 17.06.2024.
//

protocol ICategoryService {
	func getCategories() -> [Category]
	func save(categories: [Category])
}
