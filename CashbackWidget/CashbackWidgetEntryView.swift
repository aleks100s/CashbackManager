//
//  CashbackWidgetEntryView.swift
//  CashbackManager
//
//  Created by Alexander on 20.07.2024.
//

import AppIntents
import SwiftUI

struct CashbackWidgetEntryView : View {
	var entry: Provider.Entry

	var body: some View {
		if let card = entry.card {
			VStack {
				Text(card.cashbackDescription)
				
				Button("Другая", systemImage: "arrow.circlepath", intent: ChangeCurrentCardIntent(cardId: card.id.uuidString))
					.font(.caption)
					.tint(.orange)
					.controlSize(.small)
			}
		} else {
			Text("Пока нет добавленных карт с кэшбеком")
		}
	}
}
