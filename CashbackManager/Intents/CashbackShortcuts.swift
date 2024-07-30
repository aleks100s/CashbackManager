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
			shortTitle: "Добавь новую карту",
			systemImageName: "creditcard"
		)
		
		AppShortcut(
			intent: CreateCardIntent(),
			phrases: [
				"Какой кэшбек на карте?"
			],
			shortTitle: "Какой кэшбек на карте?",
			systemImageName: "rublesign"
		)
		
		AppShortcut(
			intent: CreateCardIntent(),
			phrases: [
				"Какой картой платить в категории?"
			],
			shortTitle: "Какой картой платить в категории?",
			systemImageName: "creditcard.viewfinder"
		)
		
		AppShortcut(
			intent: CheckPlaceCategoryIntent(),
			phrases: [
				"Какая категория в заведении?"
			],
			shortTitle: "Какая категория в заведении?",
			systemImageName: "mappin.circle"
		)
		
		AppShortcut(
			intent: CheckPlaceCardIntent(),
			phrases: [
				"Какой картой платить в заведении?"
			],
			shortTitle: "Какой картой платить в заведении?",
			systemImageName: "mappin"
		)
	}
}
