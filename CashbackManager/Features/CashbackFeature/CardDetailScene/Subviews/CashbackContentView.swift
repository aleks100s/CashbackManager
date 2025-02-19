//
//  CashbackContentView.swift
//  CashbackManager
//
//  Created by Alexander on 19.02.2025.
//

import AppIntents
import SwiftUI
import TipKit

extension CardDetailView {
	struct CashbackContentView: View {
		let card: Card
		let cardCashbackIntent: any AppIntent
		let onEditCashbackTap: (Cashback) -> Void
		let deleteCashback: (Cashback) -> Void
		
		@AppStorage(Constants.StorageKey.siriTips)
		private var areSiriTipsVisible = true
		
		@Environment(\.cardsService) private var cardsService
		
		var body: some View {
			if areSiriTipsVisible {
				IntentTipView(intent: cardCashbackIntent, text: "Чтобы быстро проверить кэшбэки на карте")
			}
			
			Section {
				ForEach(card.orderedCashback) { cashback in
					HStack {
						Image(systemName: "line.3.horizontal") // Иконка перетаскивания
							.foregroundColor(.gray)
						
						CashbackView(cashback: cashback, color: Color(hex: card.color ?? "#E7E7E7"))
							.contentShape(.rect)
							.onTapGesture {
								onEditCashbackTap(cashback)
							}
					}
					.swipeActions(edge: .leading, allowsFullSwipe: true) {
						Button("Редактировать кэшбэк") {
							onEditCashbackTap(cashback)
						}
						.tint(.green)
					}
				}
				.onDelete { indexSet in
					for index in indexSet {
						deleteCashback(card.orderedCashback[index])
					}
				}
				.onMove { source, destination in
					var cashback = card.orderedCashback
					cashback.move(fromOffsets: source, toOffset: destination)
					cashback.indices.forEach { index in
						cashback[index].order = index
					}
					card.cashback = cashback
					cardsService?.update(card: card)
				}
				
				TipView(HowToDeleteCashbackTip())
			} header: {
				Text("Кэшбэки на карте")
			} footer: {
				Text("Форма выплаты кэшбэка: \(card.currency)")
			}
		}
	}
}
