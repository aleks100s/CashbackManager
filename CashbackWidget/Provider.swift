//
//  Provider.swift
//  CashbackManager
//
//  Created by Alexander on 20.07.2024.
//

import CashbackService
import PersistanceManager
import WidgetKit

struct Provider: TimelineProvider {
	func placeholder(in context: Context) -> Entry {
		Entry(date: Date(), card: .sberCard)
	}

	func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
		let entry = Entry(date: Date(), card: .sberCard)
		completion(entry)
	}

	func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		let service = CashbackService(persistanceManager: PersistanceManager(defaults: UserDefaults(suiteName: "group.com.alextos.cashback")))
		let card = service.getCurrentCard()
		var entries: [Entry] = [
			.init(date: Date(), card: card)
		]
		let timeline = Timeline(entries: entries, policy: .atEnd)
		completion(timeline)
	}
}

