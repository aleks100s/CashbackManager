//
//  WidgetURLParser.swift
//  CashbackManager
//
//  Created by Alexander on 23.07.2024.
//

import Domain
import Foundation
import SwiftData

struct WidgetURLParser {
	private let cardsService: ICardsService
	
	init(cardsService: ICardsService) {
		self.cardsService = cardsService
	}
	
	func parse(url: URL) -> [Navigation]? {
		let components = url.pathComponents
		if components.count > 2 {
			switch components[1] {
			case "card":
				guard let cardId = UUID(uuidString: components[2]), let card = cardsService.getCard(id: cardId) else {
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
