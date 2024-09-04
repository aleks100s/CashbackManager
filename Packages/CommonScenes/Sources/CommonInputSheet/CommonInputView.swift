//
//  CommonInputView.swift
//  
//
//  Created by Alexander on 21.07.2024.
//

import SwiftUI
import DesignSystem

public struct CommonInputView: View {
	private let placeholder: LocalizedStringKey
	private let keyboardType: UIKeyboardType
	private let onSaveButtonTapped: (String) -> Void

	@State private var text: String = ""
	@FocusState private var isFocused
	
	public init(
		_ placeholder: LocalizedStringKey,
		text: String = "",
		keyboardType: UIKeyboardType = .default,
		onSaveButtonTapped: @escaping (String) -> Void
	) {
		self.text = text
		self.placeholder = placeholder
		self.keyboardType = keyboardType
		self.onSaveButtonTapped = onSaveButtonTapped
	}
	
	public var body: some View {
		ScrollView {
			VStack(alignment: .center, spacing: 32) {
				CMTextField(placeholder, text: $text)
					.keyboardType(keyboardType)
					.focused($isFocused)
				
				CMProminentButton("Сохранить") {
					onSaveButtonTapped(text)
				}
				.disabled(text.isEmpty)
			}
			.padding()
		}
		.onTapGesture {
			isFocused = false
		}
		.scrollDismissesKeyboard(.interactively)
		.onAppear {
			isFocused = true
		}
	}
}
