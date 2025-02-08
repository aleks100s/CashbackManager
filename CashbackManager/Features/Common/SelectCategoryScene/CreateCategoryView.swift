//
//  File.swift
//  CommonScenes
//
//  Created by Alexander on 17.01.2025.
//

import AppIntents
import SwiftUI

struct CreateCategoryView: View {
	let addCategoryIntent: any AppIntent
	
	@State var text = ""
	
	let onSaveButtonTapped: (String, String?, String?) -> Void

	@AppStorage(Constants.StorageKey.siriTips)
	private var areSiriTipsVisible = true

	@FocusState private var isFocused
	@Environment(\.dismiss) private var dismiss
	
	@State private var emoji = ""
	@State private var info = ""

	var body: some View {
		NavigationView {
			List {
				if areSiriTipsVisible {
					IntentTipView(
						intent: addCategoryIntent,
						text:  "Чтобы быстро добавить категорию"
					)
					.padding(.bottom, 24)
				}
				
				Section {
					TextField("Название категории", text: $text)
						.focused($isFocused)
				}
				
				Section {
					TextField("Символ категории", text: $emoji)
						.onChange(of: emoji) { emoji in
							self.emoji = String(emoji.prefix(1))
						}
				} footer: {
					Text("Необязательно")
				}
				
				Section {
					TextField("Описание", text: $info)
				} footer: {
					Text("Необязательно")
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
					onSaveButtonTapped(text, emoji.isEmpty ?  nil : emoji, info.isEmpty ? nil : info)
				}
				.disabled(text.isEmpty)
				.padding()
			}
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Отмена") {
						dismiss()
					}
				}
			}
			.navigationTitle("Добавить категорию")
			.navigationBarTitleDisplayMode(.inline)
		}
	}
}
