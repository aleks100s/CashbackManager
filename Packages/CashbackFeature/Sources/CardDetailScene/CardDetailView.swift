//
//  CashbackView.swift
//  CashbackManager
//
//  Created by Alexander on 19.06.2024.
//

import Domain
import DesignSystem
import SearchService
import Shared
import SwiftData
import SwiftUI
import WidgetKit

public struct CardDetailView: View {
	private let card: Card
	private let onAddCashbackTap: () -> Void
	
	@AppStorage("CurrentCardID", store: .appGroup) private var currentCardId: String?

	@Environment(\.modelContext) private var context
	@Environment(\.searchService) private var searchService

	public init(card: Card, onAddCashbackTap: @escaping () -> Void) {
		self.card = card
		self.onAddCashbackTap = onAddCashbackTap
	}
	
	public var body: some View {
		contentView
			.background(Color.cmScreenBackground)
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
	
	@ViewBuilder
	private var contentView: some View {
		if card.cashback.isEmpty {
			ContentUnavailableView("Нет сохраненных кэшбеков", systemImage: "rublesign.circle")
		} else {
			List {
				ForEach(card.cashback) { cashback in
					CashbackView(cashback: cashback)
						.contextMenu {
							Button(role: .destructive) {
								delete(cashback: cashback)
							} label: {
								Text("Удалить")
							}
						}
				}
				.onDelete { indexSet in
					for index in indexSet {
						deleteCashback(index: index)
					}
				}
			}
		}
	}
	
	private func deleteCashback(index: Int) {
		delete(cashback: card.cashback[index])
	}
	
	private func delete(cashback: Cashback) {
		searchService?.deindex(cashback: cashback)
		context.delete(cashback)
		card.cashback.removeAll(where: { $0.id == cashback.id })
		searchService?.index(card: card)
	}
}
