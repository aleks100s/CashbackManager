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
		XCTAssertEqual(persistanceManager.readModelsReceivedKeys, [.banks])
	}
	
	func test_getCards() {
		// Given
		let bank = Card.arbitrary()
		initService(with: [bank])
		
		// When
		let result = service.getBanks()
		
		// Then
		XCTAssertEqual(result, [bank])
	}
	
	func test_updateBank_bankExists() {
		// Given
		var bank = Bank.arbitrary()
		initService(with: [bank])
		
		// When
		bank.cards.append(.arbitrary())
		service.update(bank: bank)
		
		// Then
		XCTAssertEqual(service.getBanks(), [bank])
	}
	
	func test_updateBank_bankNotExist() {
		// Given
		let bank = Bank.arbitrary()
		initService(with: [bank])
		
		// When
		service.update(bank: .arbitrary())
		
		// Then
		XCTAssertEqual(service.getBanks(), [bank])
	}
	
	func test_updateCard_cardExists() {
		// Given
		var card = Card.arbitrary(cashback: [.arbitrary(category: .arbitrary())])
		let bank = Bank.arbitrary(cards: [card])
		initService(with: [bank])
		
		// When
		card.cashback.remove(at: 0)
		service.update(card: card)
		let result = service.getBanks()
		
		// Then
		XCTAssertTrue(result[0].cards.contains(card))
	}
	
	func test_updateCard_cardNotExists() {
		// Given
		var card = Card.arbitrary(cashback: [.arbitrary(category: .arbitrary()), .arbitrary(category: .arbitrary()), .arbitrary(category: .arbitrary())])
		let bank = Bank.arbitrary(cards: [.arbitrary(), .arbitrary()])
		initService(with: [bank])
		
		// When
		card.cashback.remove(at: 1)
		service.update(card: card)
		let result = service.getBanks()
		
		// Then
		XCTAssertFalse(result[0].cards.contains(card))
	}
	
	func test_deleteCard_cardExists() {
		// Given
		let card = Card.arbitrary()
		let bank = Bank.arbitrary(cards: [card])
		initService(with: [bank])
		
		// When
		service.delete(card: card)
		let result = service.getBanks()
		
		// Then
		XCTAssertTrue(result[0].cards.isEmpty)
	}
	
	func test_deleteCard_cardNotExists() {
		// Given
		let card = Card.arbitrary()
		let bank = Bank.arbitrary(cards: [.arbitrary()])
		initService(with: [bank])
		
		// When
		service.delete(card: card)
		let result = service.getBanks()
		
		// Then
		XCTAssertFalse(result[0].cards.isEmpty)
	}
	
	func test_getCard_wrongId() {
		// Given
		let bank = Bank.arbitrary(cards: [.arbitrary(), .arbitrary(), .arbitrary()])
		initService(with: [bank])
		
		// When
		let result = service.getCard(by: UUID())
		
		// Then
		XCTAssertNil(result)
	}
	
	func test_getCard_correctId() {
		// Given
		let card = Card.arbitrary()
		let bank = Bank.arbitrary(cards: [card])
		initService(with: [bank])
		
		// When
		let result = service.getCard(by: card.id)
		
		// Then
		XCTAssertEqual(result, card)
	}
	
	func test_getBank_wrongId() {
		// Given
		let bank = Bank.arbitrary()
		initService(with: [bank])
		
		// When
		let result = service.getBank(by: UUID())
		
		// Then
		XCTAssertNil(result)
	}
	
	func test_getBank_correctId() {
		// Given
		let bank = Bank.arbitrary()
		initService(with: [bank])
		
		// When
		let result = service.getBank(by: bank.id)
		
		// Then
		XCTAssertEqual(result, bank)
	}

	func test_updateBanks() {
		// Given
		initService(with: [.arbitrary()])
		
		// When
		service.update(banks: [Bank.arbitrary()])
		
		// Then
		XCTAssertEqual(service.getBanks().count, 1)
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
		XCTAssertEqual(persistanceManager.readModelsReceivedKeys, [.banks, .widgetCurrentCard])
		XCTAssertEqual(result, card)
	}
}

private extension CashbackServiceTests {
	func initService(with banks: [Bank]) {
		persistanceManager = .init()
		persistanceManager.readModelsReturnValue = banks
		service = .init(persistanceManager: persistanceManager)
	}
}
