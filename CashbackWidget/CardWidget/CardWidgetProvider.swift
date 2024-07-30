//
//  CardWidgetProvider.swift
//  CashbackManager
//
//  Created by Alexander on 20.07.2024.
//

import CardsService
import Domain
import Shared
import SwiftData
import WidgetKit

struct CardWidgetProvider: TimelineProvider {
	func placeholder(in context: Context) -> CardWidgetEntry {
		Entry(date: Date(), card: nil, hasMoreCards: true)
	}

	func getSnapshot(in context: Context, completion: @escaping (CardWidgetEntry) -> ()) {
		let entry = Entry(date: Date(), card: nil, hasMoreCards: true)
		completion(entry)
	}

	func getTimeline(in context: Context, completion: @escaping (Timeline<CardWidgetEntry>) -> ()) {
		guard let cardIdString = UserDefaults.appGroup?.value(forKey: Constants.currentCardID) as? String,
			let cardId = UUID(uuidString: cardIdString),
			let service = WidgetFactory.makeCardsService()
		else { return }

		let allCards = service.getAllCards()
		guard let card = service.getCard(id: cardId) ?? allCards.first, !card.cashback.isEmpty else { return }
		
		let entries: [Entry] = [
			.init(date: Date(), card: card, hasMoreCards: allCards.count > 1)
		]
		let timeline = Timeline(entries: entries, policy: .atEnd)
		completion(timeline)
	}
}
