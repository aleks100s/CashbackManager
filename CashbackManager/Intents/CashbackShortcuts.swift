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
				"Добавь карту в \(.applicationName)",
				"Создай карту для \(.applicationName)",
			],
			shortTitle: "Новая карта",
			systemImageName: "creditcard"
		)
		
		AppShortcut(
			intent: CheckCardCashbackIntent(),
			phrases: [
				"Какой \(.applicationName) на карте?",
				"Какой \(.applicationName) по карте?",
				"Какой \(.applicationName) у карты?",
				"Какие \(.applicationName) на карте?",
				"Какие \(.applicationName) по карте?",
				"Какие \(.applicationName) у карты?",
				"\(.applicationName) на карте?",
				"\(.applicationName) по карте?",
				"\(.applicationName) у карты?",
				"\(.applicationName) на карте?",
				"\(.applicationName) по карте?",
				"\(.applicationName) у карты?",
				"Что за \(.applicationName) на карте?",
				"Что за \(.applicationName) по карте?",
				"Что за \(.applicationName) у карты?",
				"Что за \(.applicationName) на карте?",
				"Что за \(.applicationName) по карте?",
				"Что за \(.applicationName) у карты?",
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
				"Где есть категория \(.applicationName)?",
				"У какой карты есть категория \(.applicationName)?",
				"Какой картой платить для \(.applicationName)?",
				"Какой картой платить с \(.applicationName)?",
				"Чем платить для \(.applicationName)?",
				"Чем платить с \(.applicationName)?",
				"На какой карте есть \(.applicationName)?",
				"Где есть \(.applicationName)?",
				"У какой карты есть \(.applicationName)?",
				"Что за карта в категории \(.applicationName)",
				"Что за карта с \(.applicationName)"
			],
			shortTitle: "Карта в категории",
			systemImageName: "creditcard.viewfinder"
		)
		
		AppShortcut(
			intent: CheckPlaceCategoryIntent(),
			phrases: [
				"Какая категория \(.applicationName) в заведении?",
				"Какая категория \(.applicationName) у заведения?",
				"Что за категория \(.applicationName) в заведении?",
				"Что за категория \(.applicationName) у заведения?",
				"Какой \(.applicationName) в заведении?",
				"Какой \(.applicationName) у заведения?",
				"Что за \(.applicationName) в заведении?",
				"Что за \(.applicationName) у заведения?",
				"Какая категория \(.applicationName) в месте?",
				"Какая категория \(.applicationName) у места?",
				"Что за категория \(.applicationName) в месте?",
				"Что за категория \(.applicationName) у места?",
				"Какой \(.applicationName) в места?",
				"Какой \(.applicationName) у места?",
				"Что за \(.applicationName) в месте?",
				"Что за \(.applicationName) у места?",
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
				"Какой картой платить в месте \(.applicationName)?",
				"Чем платить в месте \(.applicationName)?",
				"Чем платить с \(.applicationName)",
				"Карта для \(.applicationName)",
			],
			shortTitle: "Карта в заведении",
			systemImageName: "mappin"
		)
		
		AppShortcut(
			intent: CreatePlaceIntent(),
			phrases: [
				"Добавь новое место в \(.applicationName)",
				"Добавь новое место для \(.applicationName)",
				"Добавь место в \(.applicationName)",
				"Создай место для \(.applicationName)",
				"Добавь новое заведение в \(.applicationName)",
				"Добавь новое заведение для \(.applicationName)",
				"Добавь заведение в \(.applicationName)",
				"Создай заведение для \(.applicationName)",
			],
			shortTitle: "Новое место",
			systemImageName: "storefront"
		)
		
		AppShortcut(
			intent: CreateCategoryIntent(),
			phrases: [
				"Добавь новую категорию \(.applicationName)",
				"Добавь новую категорию для \(.applicationName)",
				"Добавь категорию \(.applicationName)",
				"Создай категорию \(.applicationName)",
				"Добавь новую категорию в \(.applicationName)",
				"Добавь новую категорию для \(.applicationName)",
				"Добавь категорию в \(.applicationName)",
				"Создай категорию для \(.applicationName)",
			],
			shortTitle: "Новая категория",
			systemImageName: "list.bullet"
		)
		
		AppShortcut(
			intent: CreateCashbackIntent(),
			phrases: [
				"Добавь новый \(.applicationName)",
				"Добавь \(.applicationName)",
				"Создай новый \(.applicationName)",
				"Создай \(.applicationName)",
			],
			shortTitle: "Новый кэшбек",
			systemImageName: "plus"
		)
	}
}
