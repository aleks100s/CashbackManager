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
		Entry(date: Date(), card: .sberCard)
	}

	func getSnapshot(in context: Context, completion: @escaping (CardWidgetEntry) -> ()) {
		let entry = Entry(date: Date(), card: .sberCard)
		completion(entry)
	}

	func getTimeline(in context: Context, completion: @escaping (Timeline<CardWidgetEntry>) -> ()) {
		let service = CashbackService(persistanceManager: PersistanceManager(defaults: UserDefaults(suiteName: "group.com.alextos.cashback")))
		let card = service.getCurrentCard()
		let entries: [Entry] = [
			.init(date: Date(), card: card)
		]
		let timeline = Timeline(entries: entries, policy: .atEnd)
		completion(timeline)
	}
}

