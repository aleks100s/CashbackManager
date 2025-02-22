//
//  AddCardView.swift
//  
//
//  Created by Alexander on 21.07.2024.
//

import AppIntents
import SwiftUI

struct AddCardView: View {
	private let placeholder: LocalizedStringKey
	private let keyboardType: UIKeyboardType
	private let intent: (any AppIntent)?
	private let hint: String?
	private let onSaveButtonTapped: (String, Color, Currency) -> Void
	
	@AppStorage(Constants.StorageKey.siriTips)
	private var areSiriTipsVisible = true

	@State private var text: String = ""
	@State private var color: Color = .red
	@State private var currency: Currency = .rubles
	
	@FocusState private var isFocused
	
	@Environment(\.dismiss) private var dismiss
	
	init(
		_ placeholder: LocalizedStringKey,
		text: String = "",
		keyboardType: UIKeyboardType = .default,
		intent: (any AppIntent)? = nil,
		hint: String? = nil,
		onSaveButtonTapped: @escaping (String, Color, Currency) -> Void
	) {
		self.text = text
		self.placeholder = placeholder
		self.keyboardType = keyboardType
		self.intent = intent
		self.hint = hint
		self.onSaveButtonTapped = onSaveButtonTapped
	}
	
	var body: some View {
		List {
			if let intent, let hint, areSiriTipsVisible {
				IntentTipView(intent: intent, text: hint)
			}
			
			Section {
				TextField(placeholder, text: $text)
					.keyboardType(keyboardType)
					.focused($isFocused)
			} footer: {
				Text("Это может быть название банка или что угодно другое")
			}
			
			Section {
				ColorPicker("Цвет карты", selection: $color)
			} footer: {
				Text("Цвет карты позволит проще отличать её")
			}
			
			Section {
				HStack {
					Text("Форма выплаты кэшбэка")
					Spacer()
					Menu(currency.rawValue) {
						ForEach(Currency.allCases) { currency in
							Button(currency.rawValue) {
								self.currency = currency
								hapticFeedback(.light)
							}
						}
					}
				}
			}
		}
		.scrollDismissesKeyboard(.interactively)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button("Отмена") {
					dismiss()
				}
			}
		}
		.safeAreaInset(edge: .bottom) {
			Button("Сохранить") {
				onSaveButtonTapped(text, color, currency)
			}
			.disabled(text.isEmpty)
			.padding()
		}
		.onAppear {
			isFocused = true
		}
		.onTapGesture {
			isFocused = false
		}
	}
}
