//
//  CardTests.swift
//  DomainTests
//
//  Created by Alexander on 15.06.2024.
//

import XCTest
@testable import Domain

final class CardTests: XCTestCase {
	private var card: Card!
	
	func test_card_noCashback() {
		// Given
		let card = Card.arbitrary(cashback: [])
		
		// When
		let description = card.cashbackDescription
		
		// Then
		XCTAssertEqual(description, "Нет кэшбека")
	}
	
	func test_card_oneCashback() {
		// Given
		let percent = Int.random(in: 1...5)
		let category = PredefinedCategory.allPurchases
		let card = Card.arbitrary(cashback: [.arbitrary(predefinedCategory: category, percent: Double(percent) / 100)])
		
		// When
		let description = card.cashbackDescription
		
		// Then
		XCTAssertEqual(description, "\(percent)% \(category.name)")
	}
	
	func test_card_lotsOfCashback_differentPercent() {
		// Given
		let percent1 = Int.random(in: 1...5)
		let percent2 = Int.random(in: 6...10)
		let category1 = PredefinedCategory.allPurchases
		let category2 = PredefinedCategory.taxi
		let card = Card.arbitrary(cashback: [
			.arbitrary(predefinedCategory: category1, percent: Double(percent1) / 100),
			.arbitrary(predefinedCategory: category2, percent: Double(percent2) / 100)
		])
		
		// When
		let description = card.cashbackDescription
		
		// Then
		XCTAssertEqual(description, "\(percent1)% \(category1.name), \(percent2)% \(category2.name)")
	}
	
	func test_card_lotsOfCashback_samePercent() {
		// Given
		let percent = Int.random(in: 1...5)
		let category1 = PredefinedCategory.allPurchases
		let category2 = PredefinedCategory.taxi
		let card = Card.arbitrary(cashback: [
			.arbitrary(predefinedCategory: category1, percent: Double(percent) / 100),
			.arbitrary(predefinedCategory: category2, percent: Double(percent) / 100)
		])
		
		// When
		let description = card.cashbackDescription
		
		// Then
		XCTAssertEqual(description, "\(percent)% \(category1.name), \(percent)% \(category2.name)")
	}
}
