//
//  WidgetURLParser.swift
//  CashbackManager
//
//  Created by Alexander on 23.07.2024.
//

import Domain
import Foundation

struct WidgetURLParser {
	let cashbackService: ICashbackService
	
	func parse(url: URL) -> [Navigation]? {
		let components = url.pathComponents
		if components.count > 2 {
			switch components[1] {
			case "card":
				if let cardId = UUID(uuidString: components[2]),
				   let card = cashbackService.getCard(by: cardId) {
					return [.cardDetail(card)]
				}
			default:
				break
			}
		}
		return nil
	}
}
