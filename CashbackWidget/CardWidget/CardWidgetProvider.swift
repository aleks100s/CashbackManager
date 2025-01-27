//
//  CardWidgetProvider.swift
//  CashbackManager
//
//  Created by Alexander on 20.07.2024.
//

import SwiftData
import WidgetKit

struct CardWidgetProvider: TimelineProvider {
	func placeholder(in context: Context) -> CardWidgetEntry {
		Entry(date: Date(), card: nil, hasMoreCards: true)
	}

	func getSnapshot(in context: Context, completion: @escaping (CardWidgetEntry) -> ()) {
		Task { @MainActor in
			let entry = Entry(date: Date(), card: AppFactory.provideCardsService().getAllCards().first, hasMoreCards: true)
			completion(entry)
		}
	}

	func getTimeline(in context: Context, completion: @escaping (Timeline<CardWidgetEntry>) -> ()) {
		Task { @MainActor in
			guard let cardIdString = UserDefaults.appGroup?.value(forKey: Constants.StorageKey.currentCardID) as? String,
				let cardId = UUID(uuidString: cardIdString)
			else { return }

			let service = AppFactory.provideCardsService()
			let allCards = service.getAllCards()
			guard let card = service.getCard(id: cardId) ?? allCards.first, !card.cashback.isEmpty else { return }
			
			let entries: [Entry] = [
				.init(date: Date(), card: card, hasMoreCards: allCards.count > 1)
			]
			let timeline = Timeline(entries: entries, policy: .atEnd)
			completion(timeline)
		}
	}
}
