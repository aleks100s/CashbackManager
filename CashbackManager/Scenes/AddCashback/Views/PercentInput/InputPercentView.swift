//
//  InputPercentView.swift
//  CashbackManager
//
//  Created by Alexander on 07.07.2024.
//

import SwiftUI

struct InputPercentView: View {
	@State var percentString: String
	let onSaveButtonTapped: (String) -> Void
	
	@FocusState private var isFocused
	
	var body: some View {
		ScrollView {
			VStack {
				CMTextField("Процент", text: $percentString)
					.keyboardType(.decimalPad)
					.focused($isFocused)
				
				CMProminentButton("Сохранить") {
					onSaveButtonTapped(percentString)
				}
				.disabled(percentString.isEmpty)
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
