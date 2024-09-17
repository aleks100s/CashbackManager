//
//  CashbackApplication.swift
//  CashbackManager
//
//  Created by Alexander on 10.06.2024.
//

import AppIntents
import CashbackFeature
import Domain
import PlaceFeature
import SearchService
import Shared
import SwiftData
import SwiftUI
import UserNotifications

@main
@MainActor
struct CashbackApplication: App {
	private let container = AppFactory.provideModelContainer()
	private let searchService = AppFactory.provideSearchService()
	private let categoryService = AppFactory.provideCategoryService()
	private let placeService = AppFactory.providePlaceService()
	private let cardsService = AppFactory.provideCardsService()
	
	@AppStorage("isMonthlyNotificationScheduled")
	private var isMonthlyNotificationScheduled = false
	
	init() {
		let searchService = self.searchService
		let categoryService = self.categoryService
		let placeService = self.placeService
		let cardsService = self.cardsService
		AppDependencyManager.shared.add(dependency: searchService)
		AppDependencyManager.shared.add(dependency: categoryService)
		AppDependencyManager.shared.add(dependency: placeService)
		AppDependencyManager.shared.add(dependency: cardsService)
	}

    var body: some Scene {
        WindowGroup {
			TabView {
				CashbackFeatureAssembly.assemble(
					container: container,
					addCardIntent: CreateCardIntent(),
					checkCategoryCardIntent: CheckCategoryCardsIntent(),
					cardCashbackIntent: CheckCardCashbackIntent(),
					addCategoryIntent: CreateCategoryIntent(),
					addCashbackIntent: CreateCashbackIntent()
				)
				.tabItem {
					Label("Кэшбэк", systemImage: Constants.SFSymbols.cashback)
				}
				
				PlaceFeatureAssembly.assemble(
					addPlaceIntent: CreatePlaceIntent(),
					checkPlaceIntent: CheckPlaceCategoryIntent(),
					addCategoryIntent: CreateCategoryIntent()
				)
				.tabItem {
					Label("Места", systemImage: Constants.SFSymbols.places)
				}
			}
			.task {
				requestNotificationPermission()
			}
        }
		.modelContainer(container)
		.environment(\.searchService, searchService)
		.environment(\.categoryService, categoryService)
		.environment(\.placeService, placeService)
    }

	private func requestNotificationPermission() {
		let center = UNUserNotificationCenter.current()
		center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
			if granted {
				scheduleMonthlyNotificationIfNeeded()
			}
		}
	}
	
	private func scheduleMonthlyNotificationIfNeeded() {
		guard !isMonthlyNotificationScheduled else {
			return
		}
		
		let center = UNUserNotificationCenter.current()

		// Определение компонента времени для первого числа каждого месяца в 10:00 утра, например
		var dateComponents = DateComponents()
		dateComponents.day = 1
		dateComponents.hour = 10

		// Создание триггера с повторением каждый месяц
		let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

		// Создание содержимого уведомления
		let content = UNMutableNotificationContent()
		content.title = "Пора добавить кэшбэк"
		content.body = "Не забудьте выбрать кэшбэк в этом месяце"
		content.sound = .default

		// Создание уникального идентификатора для уведомления
		let identifier = Constants.appIdentifier

		// Создание запроса уведомления
		let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

		// Добавление запроса
		center.add(request) { _ in }
		
		isMonthlyNotificationScheduled = true
	}
}
