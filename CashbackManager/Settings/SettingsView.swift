//
//  SettingsView.swift
//  CashbackManager
//
//  Created by Alexander on 23.10.2024.
//

import Shared
import SwiftUI

struct SettingsView: View {
	@AppStorage(Constants.StorageKey.siriTips)
	private var areSiriTipsVisible = true
	
	var body: some View {
		List {
			Section {
				Toggle("Подсказки Siri", isOn: $areSiriTipsVisible)
			} footer: {
				Text("Подсказки голосовых команд можно показать или скрыть в любой момент")
			}

		}
		.navigationTitle("Настройки приложения")
		.navigationBarTitleDisplayMode(.inline)
	}
}
