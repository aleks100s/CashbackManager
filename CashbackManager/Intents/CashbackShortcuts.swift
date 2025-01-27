//
//  CashbackShortcuts.swift
//  CashbackManager
//
//  Created by Alexander on 30.07.2024.
//

import AppIntents

struct CashbackShortcuts: AppShortcutsProvider {
	static var appShortcuts: [AppShortcut] {
		AppShortcut(
			intent: CreateCardIntent(),
			phrases: [
				"Добавь карту в \(.applicationName)",
				"Добавь новую карту в \(.applicationName)",
				"Создай новую карту для \(.applicationName)",
				"Создай карту для \(.applicationName)",
			],
			shortTitle: "Новая карта",
			systemImageName: "plus"
		)
		
		AppShortcut(
			intent: CheckCardCashbackIntent(),
			phrases: [
				"Какой \(.applicationName) на карте?",
				"Какие \(.applicationName)и на карте?",
				"Какой \(.applicationName) по карте?",
				"Какие \(.applicationName)и по карте?",
				"Какой \(.applicationName) у карты?",
				"Какие \(.applicationName)и у карты?",
				"\(.applicationName) на карте?",
				"\(.applicationName) по карте?",
				"\(.applicationName) у карты?",
				"\(.applicationName)и на карте?",
				"\(.applicationName)и по карте?",
				"\(.applicationName)и у карты?",
				"Что за \(.applicationName) на карте?",
				"Что за \(.applicationName) по карте?",
				"Что за \(.applicationName) у карты?",
				"Что за \(.applicationName)и на карте?",
				"Что за \(.applicationName)и по карте?",
				"Что за \(.applicationName)и у карты?",
			],
			shortTitle: "Кэшбэк на карте",
			systemImageName: "creditcard.viewfinder"
		)
		
		AppShortcut(
			intent: CheckCategoryCardsIntent(),
			phrases: [
				"На какой карте есть \(.applicationName)?",
				"На какой карте \(.applicationName)?",
				"Чем платить в категории \(.applicationName)а?",
				"Какой картой платить в категории \(.applicationName)а?",
				"На какой карте есть категория \(.applicationName)а?",
				"Где есть категория \(.applicationName)а?",
				"У какой карты есть категория \(.applicationName)а?",
				"Какой картой платить для \(.applicationName)а?",
				"Какой картой платить с \(.applicationName)ом?",
				"Чем платить для \(.applicationName)а?",
				"Чем платить с \(.applicationName)ом?",
				"На какой карте есть \(.applicationName)?",
				"Где есть \(.applicationName)?",
				"У какой карты есть \(.applicationName)?",
				"Что за карта в категории \(.applicationName)а",
				"Что за карта с \(.applicationName)ом"
			],
			shortTitle: "Карта в категории",
			systemImageName: "creditcard.viewfinder"
		)
		
		AppShortcut(
			intent: CheckPlaceCategoryIntent(),
			phrases: [
				"Какой \(.applicationName) в заведении?",
				"Какие \(.applicationName)и в заведении?",
				"Какая категория \(.applicationName)а в заведении?",
				"Какая категория \(.applicationName)а у заведения?",
				"Что за категория \(.applicationName)а в заведении?",
				"Что за категория \(.applicationName)а у заведения?",
				"Какой \(.applicationName) у заведения?",
				"Что за \(.applicationName) в заведении?",
				"Что за \(.applicationName) у заведения?",
				"Какая категория \(.applicationName)ов у места?",
				"Что за категория \(.applicationName)ов у места?",
				"Какой \(.applicationName) у места?",
				"Что за \(.applicationName) у места?",
			],
			shortTitle: "Категория в заведении",
			systemImageName: "storefront"
		)
		
		AppShortcut(
			intent: CheckPlaceCardIntent(),
			phrases: [
				"Оплата в заведении с \(.applicationName)ом",
				"Какой картой платить в заведении с \(.applicationName)ом?",
				"Чем платить для \(.applicationName)а в заведении",
				"Какой картой платить в месте с \(.applicationName)ом?",
				"Чем платить в месте с \(.applicationName)ом?",
				"Чем платить с \(.applicationName)ом в заведении",
				"Карта для \(.applicationName)а в заведении",
				"Какой картой платить в заведении для \(.applicationName)а?",
				"Чем платить в заведении для \(.applicationName)а?",
				"Какой картой платить в месте для \(.applicationName)а?",
				"Чем платить в месте для \(.applicationName)а?",
				"Чем платить для \(.applicationName)а в заведении",
			],
			shortTitle: "Карта в заведении",
			systemImageName: "storefront"
		)
		
		AppShortcut(
			intent: CreatePlaceIntent(),
			phrases: [
				"Добавь место в \(.applicationName)",
				"Добавь новое место в \(.applicationName)",
				"Добавь новое место для \(.applicationName)а",
				"Создай место для \(.applicationName)а",
				"Добавь новое заведение в \(.applicationName)",
				"Добавь новое заведение для \(.applicationName)а",
				"Добавь заведение в \(.applicationName)",
				"Создай заведение для \(.applicationName)а",
			],
			shortTitle: "Новое место",
			systemImageName: "plus"
		)
		
		AppShortcut(
			intent: CreateCategoryIntent(),
			phrases: [
				"Добавь категорию в \(.applicationName)",
				"Добавь новую категорию \(.applicationName)",
				"Добавь новую категорию для \(.applicationName)а",
				"Создай категорию \(.applicationName)",
				"Добавь новую категорию в \(.applicationName)",
				"Добавь новую категорию для \(.applicationName)а",
				"Создай категорию для \(.applicationName)а",
			],
			shortTitle: "Новая категория",
			systemImageName: "plus"
		)
		
		AppShortcut(
			intent: CreateCashbackIntent(),
			phrases: [
				"Добавь \(.applicationName)",
				"Добавь новый \(.applicationName)",
				"Создай новый \(.applicationName)",
				"Создай \(.applicationName)",
				"Добавь новый \(.applicationName) на карту",
				"Добавь \(.applicationName) на карту",
				"Создай новый \(.applicationName) для карты",
				"Создай \(.applicationName) для карты",
			],
			shortTitle: "Новый кэшбэк",
			systemImageName: "plus"
		)
		
		AppShortcut(
			intent: DeleteCardIntent(),
			phrases: [
				"Удали карту с \(.applicationName)",
				"Удали карту \(.applicationName)",
			],
			shortTitle: "Удалить карту",
			systemImageName: "trash"
		)
		
		AppShortcut(
			intent: CreateIncomeIntent(),
			phrases: [
				"Добавь выплату \(.applicationName)а",
				"Создай выплату \(.applicationName)а",
				"Запиши выплату \(.applicationName)а",
				"Сохрани выплату \(.applicationName)а",
				"Запомни выплату \(.applicationName)а",
			],
			shortTitle: "Выплата кэшбэка",
			systemImageName: "rublesign"
		)
	}
}
