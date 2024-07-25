//
//  CardWidgetProvider.swift
//  CashbackManager
//
//  Created by Alexander on 20.07.2024.
//

import CashbackService
import Domain
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
		guard let cardIdString = UserDefaults.appGroup?.value(forKey: "CurrentCardID") as? String,
			let cardId = UUID(uuidString: cardIdString)
		else { return }
		
		guard let container = try? ModelContainer(for: Card.self, Cashback.self, Domain.Category.self) else { return }
		
		let context = ModelContext(container)
		
		let allCardsPredicate = #Predicate<Card> { !$0.cashback.isEmpty }
		let allCardsDescriptor = FetchDescriptor(predicate: allCardsPredicate)
		let allCards = (try? context.fetch(allCardsDescriptor)) ?? []
		
		let currentCardPredicate = #Predicate<Card> { $0.id == cardId && !$0.cashback.isEmpty }
		let currentCardDescriptor = FetchDescriptor(predicate: currentCardPredicate)
		guard let card = (try? context.fetch(currentCardDescriptor).first) ?? allCards.first else { return }
		
		let hasMoreCards = allCards.count > 1

		let entries: [Entry] = [
			.init(date: Date(), card: card, hasMoreCards: hasMoreCards)
		]
		let timeline = Timeline(entries: entries, policy: .atEnd)
		completion(timeline)
	}
}

private extension UserDefaults {
	static let appGroup = UserDefaults(suiteName: "group.com.alextos.cashback")
}
