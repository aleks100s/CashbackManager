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
				"Добавь новую карту",
				"Создай новую карту"
			],
			shortTitle: "Добавь новую карту",
			systemImageName: "creditcard"
		)
		
		AppShortcut(
			intent: CreateCardIntent(),
			phrases: [
				"Какой кэшбек на карте?",
				"Какой кэшбек по карте?"
			],
			shortTitle: "Какой кэшбек на карте?",
			systemImageName: "rublesign"
		)
		
		AppShortcut(
			intent: CreateCardIntent(),
			phrases: [
				"Какой картой платить в категории?",
				"Чем платить в категории?"
			],
			shortTitle: "Какой картой платить в категории?",
			systemImageName: "creditcard.viewfinder"
		)
		
		AppShortcut(
			intent: CheckPlaceCategoryIntent(),
			phrases: [
				"Какая категория в заведении?",
				"Какая категория у заведения?"
			],
			shortTitle: "Какая категория в заведении?",
			systemImageName: "mappin.circle"
		)
		
		AppShortcut(
			intent: CheckPlaceCardIntent(),
			phrases: [
				"Какой картой платить в заведении?",
				"Чем платить в заведении?",
				"Чем платить?"
			],
			shortTitle: "Какой картой платить в заведении?",
			systemImageName: "mappin"
		)
	}
}
