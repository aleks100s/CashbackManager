//
//  File.swift
//  CommonScenes
//
//  Created by Alexander on 17.01.2025.
//

import AppIntents
import SwiftUI

struct CreateCategoryView: View {
	var isEdit: Bool = false
	let addCategoryIntent: any AppIntent
	
	@State var text = ""
	@State var emoji = ""
	@State var info = ""
	
	let onSaveButtonTapped: (String, String?, String?) -> Void

	@AppStorage(Constants.StorageKey.siriTips)
	private var areSiriTipsVisible = true

	@FocusState private var isFocused
	@Environment(\.dismiss) private var dismiss
	

	var body: some View {
		NavigationView {
			List {
				if areSiriTipsVisible, !isEdit {
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
			.navigationTitle(isEdit ? "Редактировать категорию" : "Добавить категорию")
			.navigationBarTitleDisplayMode(.inline)
		}
	}
}
