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
import ToastService

struct AddIncomeView: View {
	let createIncomeIntent: any AppIntent
	
	var income: Income?
	
	@AppStorage(Constants.StorageKey.siriTips)
	private var areSiriTipsVisible = true
	
	@AppStorage(Constants.StorageKey.isAdVisible)
	private var isAdVisible: Bool = false
	
	@Environment(\.dismiss) private var dismiss
	@Environment(\.incomeService) private var incomeService
	@Environment(\.toastService) private var toastService
	
	@Query(filter: #Predicate<Card> { !$0.isArchived })
	private var cards: [Card]
	
	@State private var source: Card?
	@State private var amount: String = "0"
	@State private var date: Date = .now
	
	@FocusState private var isFocused
	
	private var isInputValid: Bool {
		Int(amount) ?? .zero > .zero
	}
	
	var body: some View {
		contentView
			.navigationTitle(income == nil ? "Добавить выплату" : "Редактировать выплату")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					if income == nil {
						Button("Отмена") {
							dismiss()
						}
					} else {
						saveButton
					}
				}
			}
			.safeAreaInset(edge: .bottom) {
				if isAdVisible {
					AdBannerView(bannerId: bannerId)
						.fixedSize()
						.padding(.top, 100)
				}
			}
			.onAppear {
				source = income?.source
				amount = String(income?.amount ?? .zero)
				date = income?.date ?? .now
				isFocused = true
			}
			.scrollDismissesKeyboard(.automatic)
	}
	
	private var contentView: some View {
		List {
			if areSiriTipsVisible, income == nil {
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
				Text("Сумма выплаты в рублях/милях/баллах")
			}
		}
	}
	
	private var saveButton: some View {
		Button("Сохранить") {
			if let income {
				income.source = source
				income.amount = Int(amount) ?? .zero
				income.date = date
				incomeService?.updateIncome(income)
				toastService?.show(Toast(title: "Выплата изменена"))
			} else {
				createIncome()
				toastService?.show(Toast(title: "Выплата добавлена"))
			}
			dismiss()
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

#if DEBUG
private let bannerId = "demo-banner-yandex"
#else
private let bannerId = "R-M-12709149-4"
#endif
