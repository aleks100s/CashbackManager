//
//  CashbackService.swift
//  CashbackManager
//
//  Created by Alexander on 30.06.2024.
//

import Domain
import Foundation
import Persistance

public final class CashbackService: ICashbackService {
	private var banks: [Bank] = [] {
		didSet {
			persistBanks()
		}
	}
	
	private let persistanceManager: IPersistanceManager
	
	public init(persistanceManager: IPersistanceManager) {
		self.persistanceManager = persistanceManager
		banks = persistanceManager.readModels(for: .banks) as? [Bank] ?? []
	}
	
	public func getBanks() -> [Bank] {
		banks
	}
	
	public func save(bank: Bank) {
		banks.append(bank)
	}
	
	public func update(bank: Bank) {
		for i in banks.indices {
			if banks[i].id == bank.id {
				banks[i] = bank
				break
			}
		}
	}
	
	public func update(card: Card) {
		for i in banks.indices {
			if banks[i].cards.contains { $0.id == card.id } {
				for j in banks[i].cards.indices {
					if banks[i].cards[j].id == card.id {
						var cards = banks[i].cards
						cards[j] = card
						banks[i].cards = cards
						break
					}
				}
				break
			}
		}
	}
	
	public func delete(card: Card) {
		for i in banks.indices {
			if banks[i].cards.contains(where: { $0.id == card.id }) {
				banks[i].cards.removeAll(where: { $0.id == card.id })
				break
			}
		}
	}
	
	public func getCard(by id: UUID) -> Card? {
		for bank in banks {
			for card in bank.cards {
				if card.id == id {
					return card
				}
			}
		}
		return nil
	}
	
	public func getBank(by id: UUID) -> Bank? {
		for bank in banks {
			if bank.id == id {
				return bank
			}
		}
		return nil
	}
	
	public func update(banks: [Bank]) {
		self.banks = banks
	}
	
	private func persistBanks() {
		persistanceManager.save(models: banks, for: .banks)
	}
}
