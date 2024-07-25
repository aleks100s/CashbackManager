//
//  CashbackScreen.swift
//  CashbackManager
//
//  Created by Alexander on 19.06.2024.
//

import Domain
import DesignSystem
import SwiftUI
import WidgetKit

struct CardDetailScreen: View {
	let card: Card
	let onAddCashbackTap: () -> Void
	
	@AppStorage("CurrentCardID", store: .appGroup) private var currentCardId: String?
	@Environment(\.modelContext) private var context
	
	var body: some View {
		List {
			ForEach(card.cashback) { cashback in
				CashbackView(cashback: cashback)
					.contextMenu {
						Button(role: .destructive) {
							context.delete(cashback)
							card.cashback.removeAll(where: { $0.id == cashback.id })
						} label: {
							Text("Удалить")
						}
					}
			}
			.onDelete { indexSet in
				for index in indexSet {
					context.delete(card.cashback[index])
					card.cashback.remove(at: index)
				}
			}
		}
		.navigationTitle(card.name)
		.toolbar {
			ToolbarItem(placement: .bottomBar) {
				Button("Добавить кэшбек") {
					onAddCashbackTap()
				}
			}
		}
		.onAppear {
			currentCardId = card.id.uuidString
			WidgetCenter.shared.reloadTimelines(ofKind: "CardWidget")
		}
	}
}

private extension UserDefaults {
	static let appGroup = UserDefaults(suiteName: "group.com.alextos.cashback")
}
