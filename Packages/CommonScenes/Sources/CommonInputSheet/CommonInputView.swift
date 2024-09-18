//
//  CommonInputView.swift
//  
//
//  Created by Alexander on 21.07.2024.
//

import AppIntents
import DesignSystem
import SwiftUI

public struct CommonInputView: View {
	private let placeholder: LocalizedStringKey
	private let keyboardType: UIKeyboardType
	private let intent: (any AppIntent)?
	private let hint: String?
	private let onSaveButtonTapped: (String) -> Void

	@State private var text: String = ""
	@FocusState private var isFocused
	
	public init(
		_ placeholder: LocalizedStringKey,
		text: String = "",
		keyboardType: UIKeyboardType = .default,
		intent: (any AppIntent)? = nil,
		hint: String? = nil,
		onSaveButtonTapped: @escaping (String) -> Void
	) {
		self.text = text
		self.placeholder = placeholder
		self.keyboardType = keyboardType
		self.intent = intent
		self.hint = hint
		self.onSaveButtonTapped = onSaveButtonTapped
	}
	
	public var body: some View {
		List {
			if let intent, let hint {
				Section {
					IntentTipView(intent: intent, text: hint)
				}
				.listRowBackground(Color.clear)
				.listRowInsets(EdgeInsets(top: .zero, leading: .zero, bottom: .zero, trailing: .zero))
			}
			
			Section {
				TextField(placeholder, text: $text)
					.keyboardType(keyboardType)
					.focused($isFocused)
			}
		}
		.onTapGesture {
			isFocused = false
		}
		.scrollDismissesKeyboard(.interactively)
		.onAppear {
			isFocused = true
		}
		.safeAreaInset(edge: .bottom) {
			Button("Сохранить") {
				onSaveButtonTapped(text)
			}
			.disabled(text.isEmpty)
			.padding()
		}
	}
}
