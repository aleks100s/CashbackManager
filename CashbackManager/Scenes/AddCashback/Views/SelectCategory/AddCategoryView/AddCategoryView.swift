//
//  AddCategoryView.swift
//  CashbackManager
//
//  Created by Alexander on 07.07.2024.
//

import SwiftUI
import UI

struct AddCategoryView: View {
	let onSaveButtonTapped: (String) -> Void
	
	@State private var newCategoryName = ""
	@FocusState private var isFocused
	
	var body: some View {
		ScrollView {
			VStack {
				CMTextField("Название категории", text: $newCategoryName)
					.focused($isFocused)
				
				CMProminentButton("Сохранить") {
					onSaveButtonTapped(newCategoryName)
				}
				.disabled(newCategoryName.isEmpty)
			}
			.padding()
		}
		.onTapGesture {
			isFocused = false
		}
		.scrollDismissesKeyboard(.interactively)
	}
}
