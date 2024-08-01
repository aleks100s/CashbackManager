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
				"Добавь новую карту в \(.applicationName)",
				"Создай новую карту для \(.applicationName)",
				"Добавь новую карту",
			],
			shortTitle: "Новая карта",
			systemImageName: "creditcard"
		)
		
		AppShortcut(
			intent: CheckCardCashbackIntent(),
			phrases: [
				"Какой \(.applicationName) на карте?",
				"Какой \(.applicationName) по карте?",
				"Какие \(.applicationName) на карте?",
				"Какие \(.applicationName) по карте?",
				"Какой кэшбек на карте?",
				"Какой кэшбек по карте?",
			],
			shortTitle: "Кэшбек на карте",
			systemImageName: "rublesign"
		)
		
		AppShortcut(
			intent: CheckCategoryCardsIntent(),
			phrases: [
				"Какой картой платить в категории \(.applicationName)?",
				"Чем платить в категории \(.applicationName)?",
				"На какой карте есть категория \(.applicationName)?",
				"Какой картой платить в категории?",
				"Чем платить в категории?",
				"На какой карте есть категория?"
			],
			shortTitle: "Карта в категории",
			systemImageName: "creditcard.viewfinder"
		)
		
		AppShortcut(
			intent: CheckPlaceCategoryIntent(),
			phrases: [
				"Какая категория \(.applicationName) в заведении?",
				"Какая категория \(.applicationName) у заведения?",
				"Какая категория в заведении?",
			],
			shortTitle: "Категория в заведении",
			systemImageName: "mappin.circle"
		)
		
		AppShortcut(
			intent: CheckPlaceCardIntent(),
			phrases: [
				"Какой картой платить в заведении \(.applicationName)?",
				"Чем платить в заведении \(.applicationName)?",
				"Чем платить для \(.applicationName)",
				"Какой картой платить в заведении?",
				"Чем платить в заведении?",
				"Чем платить?",
			],
			shortTitle: "Карта в заведении",
			systemImageName: "mappin"
		)
	}
}
