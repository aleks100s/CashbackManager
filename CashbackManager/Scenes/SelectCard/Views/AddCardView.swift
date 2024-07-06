//
//  AddCardView.swift
//  CashbackManager
//
//  Created by Alexander on 29.06.2024.
//

import SwiftUI

struct AddCardView: View {
	@State var cardName = ""
	let onSaveButtonTapped: (String) -> Void
	
	@FocusState private var isFocused
	
	var body: some View {
		ScrollView {
			VStack(alignment: .center, spacing: 16) {
				TextField("Название карты", text: $cardName)
					.textFieldStyle(RoundedBorderTextFieldStyle())
					.focused($isFocused)

				Button("Сохранить") {
					onSaveButtonTapped(cardName)
				}
				.disabled(cardName.isEmpty)
				.buttonStyle(BorderedProminentButtonStyle())
			}
			.padding()
		}
		.onTapGesture {
			isFocused = false
		}
		.scrollDismissesKeyboard(.interactively)
		.background(Color(UIColor.secondarySystemBackground))
	}
}
