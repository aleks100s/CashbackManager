//
//  CashbackShortcuts.swift
//  CashbackManager
//
//  Created by Alexander on 30.07.2024.
//

import AppIntents
import Shared

struct CashbackShortcuts: AppShortcutsProvider {
	static var appShortcuts: [AppShortcut] {
		AppShortcut(
			intent: CreateCardIntent(),
			phrases: [
				"Добавь новую карту"
			],
			shortTitle: "Команда добавления новой карты",
			systemImageName: "rublesign.circle"
		)
	}
}
