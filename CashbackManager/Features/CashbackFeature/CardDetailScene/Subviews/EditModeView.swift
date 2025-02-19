//
//  EditModeView.swift
//  CashbackManager
//
//  Created by Alexander on 19.02.2025.
//

import SwiftUI

extension CardDetailView {
	struct EditModeView: View {
		let card: Card
		
		@Binding var cardName: String
		@Binding var color: Color
		
		let deleteCashback: (Cashback) -> Void
		
		@AppStorage(Constants.StorageKey.currentCardID, store: .appGroup)
		private var currentCardId: String?
		
		@State private var isDeleteCardWarningPresented = false
		@State private var isDeleteTransactionsWarningPresented = false
		
		@Environment(\.dismiss) private var dismiss
		@Environment(\.cardsService) private var cardsService
		@Environment(\.toastService) private var toastService
		@Environment(\.incomeService) private var incomeService
		
		var body: some View {
			Section("Редактировать данные карты") {
				TextField("Название карты", text: $cardName)
					.textFieldStyle(.plain)
				
				HStack {
					Text("Выплата кэшбэка")
					Spacer()
					Menu(card.currency) {
						ForEach(Currency.allCases) { currency in
							Button(currency.rawValue) {
								card.currency = currency.rawValue
								card.currencySymbol = currency.symbol
								hapticFeedback(.light)
							}
						}
					}
				}
				
				ColorPicker("Цвет карты", selection: $color)
				
				HStack {
					Text(card.isFavorite ? "В избранном" : "Добавить в избранное")
						.foregroundStyle(.secondary)
					
					Spacer()
					
					Button {
						card.isFavorite.toggle()
						cardsService?.update(card: card)
						toastService?.show(Toast(title: card.isFavorite ? "Добавлено в избранное" : "Удалено из избранного", hasFeedback: false))
					} label: {
						HeartView(isFavorite: card.isFavorite)
					}
				}
			}
			
			Section {
				if !card.isEmpty {
					Button("Удалить все кэшбэки с карты", role: .destructive) {
						for cashback in card.cashback {
							deleteCashback(cashback)
						}
					}
				}
				
				Button("Удалить все транзакции", role: .destructive) {
					isDeleteTransactionsWarningPresented = true
				}
				
				Button("Удалить карту", role: .destructive) {
					isDeleteCardWarningPresented = true
				}
			} header: {
				Text("Для отважных пользователей")
			} footer: {
				Text("Данные действия нельзя отменить")
			}
			.alert("Вы уверены?", isPresented: $isDeleteCardWarningPresented) {
				Button("Удалить только карту", role: .destructive) {
					archive(card: card)
				}
				
				Button("Удалить карту вместе с транзакциями", role: .destructive) {
					archive(card: card, shouldDeleteTransactions: true)
				}
				
				Button("Отмена", role: .cancel) {
					isDeleteCardWarningPresented = false
				}
			}
			.alert("Вы уверены?", isPresented: $isDeleteTransactionsWarningPresented) {
				Button("Удалить", role: .destructive) {
					deleteTransactions(from: card)
				}
				
				Button("Отмена", role: .cancel) {
					isDeleteTransactionsWarningPresented = false
				}
			}
		}
		
		private func deleteTransactions(from card: Card) {
			incomeService?.deleteIncomes(from: card)
			toastService?.show(Toast(title: "Транзакции успешно удалены"))
		}
		
		private func archive(card: Card, shouldDeleteTransactions: Bool = false) {
			if shouldDeleteTransactions {
				deleteTransactions(from: card)
			}
			cardsService?.archive(card: card)
			currentCardId = nil
			toastService?.show(Toast(title: "Карта удалена"))
			dismiss()
		}
	}
}
