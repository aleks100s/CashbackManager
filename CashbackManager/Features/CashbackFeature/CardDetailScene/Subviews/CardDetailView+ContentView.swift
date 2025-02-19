//
//  ContentView.swift
//  CashbackManager
//
//  Created by Alexander on 19.02.2025.
//

import AppIntents
import SwiftUI
import WidgetKit

extension CardDetailView {
	struct ContentView: View {
		let card: Card
		let cardCashbackIntent: any AppIntent
		
		@Binding var isEditing: Bool
		@Binding var cardName: String
		@Binding var color: Color
		
		let onAddCashbackTap: () -> Void
		let onEditCashbackTap: (Cashback) -> Void
		
		@Environment(\.cardsService) private var cardsService
		@Environment(\.toastService) private var toastService
		
		var body: some View {
			List {
				if isEditing {
					EditModeView(
						card: card,
						cardName: $cardName,
						color: $color
					) {
						delete(cashback: $0)
					}
				} else {
					if card.isEmpty {
						EmptyView()
					} else {
						CashbackContentView(
							card: card,
							cardCashbackIntent: cardCashbackIntent,
							onEditCashbackTap: onEditCashbackTap,
							deleteCashback: {
								delete(cashback: $0)
							}
						)
					}
					
					Button("Добавить кэшбэк вручную") {
						onAddCashbackTap()
					}
					
					DetectCashbackSectionButton(card: card) {
						refreshWidget()
					}
					
					CardChartView(card: card)
				}
			}
			.scrollIndicators(.hidden)
			.scrollContentBackground(.hidden)
			.onAppear {
				refreshWidget()
			}
		}
		
		func delete(cashback: Cashback) {
			cardsService?.delete(cashback: cashback, from: card)
			toastService?.show(Toast(title: "Кэшбэк удален"))
		}
		
		func refreshWidget() {
			WidgetCenter.shared.reloadTimelines(ofKind: Constants.cardWidgetKind)
			WidgetCenter.shared.reloadTimelines(ofKind: Constants.favouriteCardsWidgetKind)
		}
	}
}
