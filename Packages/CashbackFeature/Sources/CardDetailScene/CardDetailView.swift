//
//  CashbackView.swift
//  CashbackManager
//
//  Created by Alexander on 19.06.2024.
//

import CoreSpotlight
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
	
	private func delete(cashback: Cashback) {
		deindex(cashback: cashback)
		context.delete(cashback)
		card.cashback.removeAll(where: { $0.id == cashback.id })
		Task { @MainActor in
			index(card: card)
		}
	}
	
	private func deleteCashback(index: Int) {
		deindex(cashback: card.cashback[index])
		context.delete(card.cashback[index])
		card.cashback.remove(at: index)
	}
	
	private func deindex(cashback: Cashback) {
		CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [cashback.id.uuidString]) { error in
			if let error = error {
				print("Deindexing error: \(error.localizedDescription)")
			} else {
				print("Search item successfully removed!")
			}
		}
	}
	
	@MainActor
	private func index(card: Card) {
		let attributeSet = CSSearchableItemAttributeSet(itemContentType: UTType.text.identifier)
		attributeSet.title = card.name
		attributeSet.contentDescription = card.cashbackDescription
		let image = UIImage(named: "AppIcon", in: .main, with: nil)
		attributeSet.thumbnailData = image?.pngData()

		let item = CSSearchableItem(uniqueIdentifier: card.id.uuidString, domainIdentifier: "com.alextos.CashbackManager", attributeSet: attributeSet)
		CSSearchableIndex.default().indexSearchableItems([item]) { error in
			if let error = error {
				print("Indexing error: \(error.localizedDescription)")
			} else {
				print("Search item successfully indexed!")
			}
		}
	}
}
