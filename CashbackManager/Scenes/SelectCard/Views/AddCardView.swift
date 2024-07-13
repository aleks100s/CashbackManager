//
//  AddCardView.swift
//  CashbackManager
//
//  Created by Alexander on 29.06.2024.
//

import SwiftUI
import UI

struct AddCardView: View {
	@State var cardName = ""
	let onSaveButtonTapped: (String) -> Void
	
	@FocusState private var isFocused
	
	var body: some View {
		ScrollView {
			VStack(alignment: .center, spacing: 16) {
				CMTextField("Название карты", text: $cardName)
					.focused($isFocused)

				CMProminentButton("Сохранить") {
					onSaveButtonTapped(cardName)
				}
				.disabled(cardName.isEmpty)
			}
			.padding()
		}
		.onTapGesture {
			isFocused = false
		}
		.scrollDismissesKeyboard(.interactively)
	}
}
