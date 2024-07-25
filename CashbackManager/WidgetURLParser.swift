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
	let cashbackService: ICashbackService
	
	func parse(url: URL) -> [Navigation]? {
		let components = url.pathComponents
		if components.count > 2 {
			switch components[1] {
			case "card":
				if let cardId = UUID(uuidString: components[2]) {
					guard let container = try? ModelContainer(for: Card.self, Cashback.self, Domain.Category.self) else { return nil }
					
					let context = ModelContext(container)
					
					let currentCardPredicate = #Predicate<Card> { $0.id == cardId }
					let currentCardDescriptor = FetchDescriptor(predicate: currentCardPredicate)
					guard let card = (try? context.fetch(currentCardDescriptor).first) else { return nil }
					return [.cardDetail(card)]
				}
			default:
				break
			}
		}
		return nil
	}
}
