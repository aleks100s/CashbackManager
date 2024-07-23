//
//  CashbackWidgetEntryView.swift
//  CashbackManager
//
//  Created by Alexander on 20.07.2024.
//

import AppIntents
import SwiftUI
import DesignSystem
import WidgetKit

struct CashbackWidgetEntryView : View {
	var entry: CardWidgetProvider.Entry

	var body: some View {
		if let card = entry.card {
			CardView(card: card)
				.viewClass(.widget)
				.overlay(alignment: .topTrailing) {
					Button("Другая", systemImage: "arrow.circlepath", intent: ChangeCurrentCardIntent(cardId: card.id.uuidString))
						.font(.caption)
						.tint(.orange)
						.controlSize(.small)
				}
				.widgetURL(URL(string: "app://cashback/card/\(card.id.uuidString)"))
		} else {
			Text("Пока нет добавленных карт с кэшбеком")
		}
	}
}

#Preview(as: .systemMedium) {
	CardWidget()
} timeline: {
	CardWidgetEntry(date: .now, card: .sberCard)
	CardWidgetEntry(date: .now, card: nil)
}
