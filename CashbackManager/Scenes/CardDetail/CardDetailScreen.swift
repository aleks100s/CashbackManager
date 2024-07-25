//
//  CashbackScreen.swift
//  CashbackManager
//
//  Created by Alexander on 19.06.2024.
//

import Domain
import DesignSystem
import SwiftUI

struct CardDetailScreen: View {
	let card: Card
	let onAddCashbackTap: () -> Void
	
	@Environment(\.modelContext) private var context
	
	var body: some View {
		List {
			ForEach(card.cashback) { cashback in
				CashbackView(cashback: cashback)
					.contextMenu {
						Button(role: .destructive) {
							context.delete(cashback)
							try! context.save()
						} label: {
							Text("Удалить")
						}
					}
			}
			.onDelete { indexSet in
				for index in indexSet {
					context.delete(card.cashback[index])
					try! context.save()
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
	}
}
