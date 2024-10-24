//
//  File.swift
//  PaymentFeature
//
//  Created by Alexander on 11.10.2024.
//

import AppIntents
import DesignSystem
import Domain
import IncomeService
import Shared
import SwiftData
import SwiftUI

struct AddIncomeView: View {
	let createIncomeIntent: any AppIntent
	
	@AppStorage(Constants.StorageKey.siriTips)
	private var areSiriTipsVisible = true
	
	@Environment(\.dismiss) private var dismiss
	@Environment(\.incomeService) private var incomeService
	
	@Query private var cards: [Card]
	
	@State private var source: Card?
	@State private var amount: String = "0"
	@State private var date: Date = .now
	
	@FocusState private var isFocused
	
	private var isInputValid: Bool {
		Int(amount) ?? .zero > .zero
	}
	
	var body: some View {
		contentView
			.navigationTitle("Добавить выплату")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Отмена") {
						dismiss()
					}
				}
			}
			.safeAreaInset(edge: .bottom) {
				saveButton
			}
			.onAppear {
				isFocused = true
			}
			.scrollDismissesKeyboard(.automatic)
	}
	
	private var contentView: some View {
		List {
			if areSiriTipsVisible {
				IntentTipView(intent: createIncomeIntent, text: "Чтобы добавить выплату")
			}
			
			Section {
				Menu(source?.name ?? "Не выбрано") {
					ForEach(cards) { card in
						Button(card.name) {
							source = card
							hapticFeedback(.light)
						}
					}
				}
			} header: {
				Text("Откуда получена выплата кэшбэка")
			} footer: {
				Text("Не обязательно")
			}
			
			Section {
				DatePicker("Дата выплаты", selection: $date, in: ...Date(), displayedComponents: [.date])
					.datePickerStyle(.compact)
			} header: {
				Text("Дата выплаты")
			} footer: {
				Text("Не обязательно")
			}
			
			Section {
				TextField("Размер выплаты", text: $amount)
					.keyboardType(.numberPad)
					.focused($isFocused)
					.onChange(of: amount) {
						formatAmount()
					}
			} header: {
				Text("Сумма выплаты в рублях")
			}
		}
	}
	
	private var saveButton: some View {
		Button("Сохранить") {
			createIncome()
			dismiss()
			hapticFeedback(.light)
		}
		.frame(maxWidth: .infinity)
		.padding()
		.background(.background)
		.disabled(!isInputValid)
	}
	
	private func createIncome() {
		incomeService?.createIncome(amount: Int(amount) ?? .zero, date: date, source: source)
	}
	
	private func formatAmount() {
		if amount.hasPrefix("0") {
			amount = String(amount.dropFirst())
		}
		
		amount = amount.filter { "0123456789".contains($0) }
	}
}
