//
//  WidgetURLParser.swift
//  CashbackManager
//
//  Created by Alexander on 23.07.2024.
//

import CardsService
import Domain
import Foundation
import SwiftData

struct WidgetURLParser {
	let cardsService: CardsService
	
	func parse(url: URL) -> [Navigation]? {
		let components = url.pathComponents
		if components.count > 2 {
			switch components[1] {
			case "card":
				guard let cardId = UUID(uuidString: components[2]), let card = cardsService.getCard(by: cardId) else {
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
