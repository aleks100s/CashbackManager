//
//  CashbackView.swift
//  CashbackManager
//
//  Created by Alexander on 19.06.2024.
//

import Domain
import DesignSystem
import Shared
import SwiftData
import SwiftUI
import WidgetKit

public struct CardDetailView: View {
	private let card: Card
	private let onAddCashbackTap: () -> Void
	
	@AppStorage("CurrentCardID", store: .appGroup) private var currentCardId: String?
	@Environment(\.modelContext) private var context
	
	public init(card: Card, onAddCashbackTap: @escaping () -> Void) {
		self.card = card
		self.onAddCashbackTap = onAddCashbackTap
	}
	
	public var body: some View {
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
			WidgetCenter.shared.reloadTimelines(ofKind: Constants.cardWidgetKind)
		}
	}
}
