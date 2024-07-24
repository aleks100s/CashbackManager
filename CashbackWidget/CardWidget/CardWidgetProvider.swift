//
//  CardWidgetProvider.swift
//  CashbackManager
//
//  Created by Alexander on 20.07.2024.
//

import CashbackService
import PersistanceManager
import WidgetKit

struct CardWidgetProvider: TimelineProvider {
	func placeholder(in context: Context) -> CardWidgetEntry {
		Entry(date: Date(), card: .sberCard, hasMoreCards: true)
	}

	func getSnapshot(in context: Context, completion: @escaping (CardWidgetEntry) -> ()) {
		let entry = Entry(date: Date(), card: .sberCard, hasMoreCards: true)
		completion(entry)
	}

	func getTimeline(in context: Context, completion: @escaping (Timeline<CardWidgetEntry>) -> ()) {
		let service = CashbackService(persistanceManager: PersistanceManager(defaults: UserDefaults(suiteName: "group.com.alextos.cashback")))
		let card = service.getCurrentCard()
		let hasMoreCards = service.getCards().filter { !$0.cashback.isEmpty }.count > 1
		let entries: [Entry] = [
			.init(date: Date(), card: card, hasMoreCards: hasMoreCards)
		]
		let timeline = Timeline(entries: entries, policy: .atEnd)
		completion(timeline)
	}
}

