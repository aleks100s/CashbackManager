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
	let entry: CardWidgetProvider.Entry

	var body: some View {
		if let card = entry.card {
			CardView(card: card) {
				Group {
					if entry.hasMoreCards {
						Button("Другая", systemImage: "arrow.circlepath", intent: ChangeCurrentCardIntent(cardId: card.id.uuidString))
							.buttonStyle(BorderedProminentButtonStyle())
							.font(.caption)
							.tint(.orange)
							.controlSize(.small)
					} else {
						EmptyView()
					}
				}
			}
			.viewClass(.widget)
			.widgetURL(URL(string: "app://cashback/card/\(card.id.uuidString)"))
		} else {
			Text("Пока нет добавленных карт с кэшбеком")
		}
	}
}
