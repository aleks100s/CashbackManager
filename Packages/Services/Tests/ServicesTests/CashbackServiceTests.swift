//
//  CashbackServiceTests.swift
//  ServicesTests
//
//  Created by Alexander on 17.06.2024.
//

import Domain
import XCTest
@testable import CashbackService

final class CashbackServiceTests: XCTestCase {
	private var service: CashbackService!
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
	
	func test_init() {
		XCTAssertEqual(persistanceManager.readModelsCallsCount, 1)
		XCTAssertEqual(persistanceManager.readModelsReceivedKeys, [.cards])
	}
	
	func test_getCards() {
		// Given
		let card = Card.arbitrary()
		initService(with: [card])
		
		// When
		let result = service.getCards()
		
		// Then
		XCTAssertEqual(result, [card])
	}
	
	func test_saveCard() {
		// Given
		let card = Card.arbitrary()
		
		// When
		service.save(card: card)
		
		// Then
		XCTAssertEqual(persistanceManager.saveModelsReceivedKeys, [.cards])
		XCTAssertEqual(persistanceManager.saveModelsReceivedModels as? [[Card]], [[card]])
	}
	
	func test_updateCard_cardExists() {
		// Given
		var card = Card.arbitrary(cashback: [.arbitrary(category: .arbitrary())])
		initService(with: [card])
		
		// When
		card.cashback.remove(at: 0)
		service.update(card: card)
		let result = service.getCards()
		
		// Then
		XCTAssertTrue(result.contains(card))
	}
	
	func test_updateCard_cardNotExists() {
		// Given
		var card = Card.arbitrary(cashback: [.arbitrary(category: .arbitrary()), .arbitrary(category: .arbitrary()), .arbitrary(category: .arbitrary())])
		initService(with: [card])
		
		// When
		card.cashback.remove(at: 1)
		service.update(card: Card.arbitrary())
		let result = service.getCards()
		
		// Then
		XCTAssertFalse(result.contains(card))
	}
	
	func test_deleteCard_cardExists() {
		// Given
		let card = Card.arbitrary()
		initService(with: [card])
		
		// When
		service.delete(card: card)
		let result = service.getCards()
		
		// Then
		XCTAssertTrue(result.isEmpty)
	}
	
	func test_deleteCard_cardNotExists() {
		// Given
		initService(with: [Card.arbitrary()])
		
		// When
		service.delete(card: Card.arbitrary())
		let result = service.getCards()
		
		// Then
		XCTAssertFalse(result.isEmpty)
	}
	
	func test_getCard_wrongId() {
		// Given
		initService(with: [Card.arbitrary()])
		
		// When
		let result = service.getCard(by: UUID())
		
		// Then
		XCTAssertNil(result)
	}
	
	func test_getCard_correctId() {
		// Given
		let card = Card.arbitrary()
		initService(with: [card])
		
		// When
		let result = service.getCard(by: card.id)
		
		// Then
		XCTAssertEqual(result, card)
	}
	
	func test_saveCurrentCard() {
		// Given
		let card = Card.arbitrary()
		
		// When
		service.save(currentCard: card)
		
		// Then
		XCTAssertEqual(persistanceManager.saveModelsReceivedModels as? [[Card]], [[card]])
	}
	
	func test_getCurrentCard() {
		// Given
		let card = Card.arbitrary()
		persistanceManager.readModelsReturnValue = [card]
		
		// When
		let result = service.getCurrentCard()
		
		// Then
		XCTAssertEqual(persistanceManager.readModelsReceivedKeys, [.cards, .widgetCurrentCard])
		XCTAssertEqual(result, card)
	}
}

private extension CashbackServiceTests {
	func initService(with cards: [Card]) {
		persistanceManager = .init()
		persistanceManager.readModelsReturnValue = cards
		service = .init(persistanceManager: persistanceManager)
	}
}
