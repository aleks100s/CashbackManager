//
//  BankTests.swift
//  DomainTests
//
//  Created by Alexander on 19.06.2024.
//

import XCTest
@testable import Domain

final class BankTests: XCTestCase {
	func test_cardsList_noCards() {
		// Given
		let bank = Bank.arbitrary(cards: [])
		
		// Then
		XCTAssertEqual(bank.cardsList, "")
	}
	
	func test_cardsList_oneCards() {
		// Given
		let card = Card.arbitrary()
		let bank = Bank.arbitrary(cards: [card])
		
		// Then
		XCTAssertEqual(bank.cardsList, card.name)
	}
	
	func test_cardsList_manyCards() {
		// Given
		let cards: [Card] = [.arbitrary(), .arbitrary(), .arbitrary()]
		let bank = Bank.arbitrary(cards: cards)
		
		// Then
		XCTAssertEqual(bank.cardsList, cards.map(\.name).joined(separator: ", "))
	}
}
