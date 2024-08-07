//
//  CategoryServiceTests.swift
//  CashbackManagerTests
//
//  Created by Alexander on 17.06.2024.
//

import Domain
import XCTest
@testable import CashbackManager

final class CategoryServiceTests: XCTestCase {
	private var service: CategoryService!
	private var persistanceManager: IPersistanceManagerMock!
	
	override func setUp() {
		super.setUp()
		persistanceManager = .init()
		service = .init(persistanceManager: persistanceManager)
	}
	
	override func tearDown() {
		service = nil
		persistanceManager = nil
		super.tearDown()
	}
	
	func test_getCategories_noUserCategories() {
		// Given
		setupPersistance(categories: [])
		
		// When
		let result = service.getCategories()
		
		// Then
		XCTAssertEqual(result, PredefinedCategory.allCases.map { Domain.Category(name: $0.name, emoji: $0.emoji) })
	}
	
	func test_getCategories() {
		// Given
		let userCategory = Domain.Category.arbitrary()
		setupPersistance(categories: [userCategory])
		
		// When
		let result = service.getCategories()
		
		// Then
		XCTAssertEqual(result, PredefinedCategory.allCases.map { Domain.Category(name: $0.name, emoji: $0.emoji) } + [userCategory])
	}
	
	func test_saveCategories() {
		// Given
		setupPersistance(categories: [])
		let category = Domain.Category.arbitrary()
		
		// When
		service.save(category: category)
		
		// Then
		XCTAssertEqual(service.getCategories(), PredefinedCategory.allCases.map { Domain.Category(name: $0.name, emoji: $0.emoji) } + [category])
	}
}

private extension CategoryServiceTests {
	func setupPersistance(categories: [Domain.Category]) {
		persistanceManager = .init()
		persistanceManager.readModelsReturnValue = categories
		service = .init(persistanceManager: persistanceManager)
	}
}
