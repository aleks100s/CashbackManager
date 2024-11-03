//
//  WidgetURLParser.swift
//  CashbackManager
//
//  Created by Alexander on 23.07.2024.
//

import CardsService
import Foundation
import SwiftData

@MainActor
struct WidgetURLParser {
	private let cardsService: CardsService
	
	init(cardsService: CardsService) {
		self.cardsService = cardsService
	}
	
	func parse(url: URL) -> [Navigation]? {
		let components = url.pathComponents
		if components.count > 2 {
			switch components[1] {
			case "card":
				guard let id = UUID(uuidString: components[2]), let card = cardsService.getCard(id: id) ?? cardsService.getCard(cashbackId: id) else {
					return nil
				}
				
				return [.cardDetail(card)]
			default:
				break
			}
		}
		return nil
	}
}
