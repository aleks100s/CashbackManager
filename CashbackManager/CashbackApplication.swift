//
//  CashbackApplication.swift
//  CashbackManager
//
//  Created by Alexander on 10.06.2024.
//

import AppIntents
import SwiftData
import SwiftUI
import TipKit

@main
@MainActor
struct CashbackApplication: App {
	private let container = AppFactory.provideModelContainer()
	private let searchService = AppFactory.provideSearchService()
	private let categoryService = AppFactory.provideCategoryService()
	private let placeService = AppFactory.providePlaceService()
	private let cardsService = AppFactory.provideCardsService()
	private let incomeService = AppFactory.provideIncomeService()
	private let notificationService = AppFactory.provideNotificationService()
	private let userDataService = AppFactory.provideUserDataService()
	private let toastService = AppFactory.provideToastService()
	
	@AppStorage(Constants.StorageKey.notifications)
	private var isMonthlyNotificationScheduled = false
	
	@AppStorage(Constants.StorageKey.notificationsAllowed)
	private var isNotificationAllowed = true
	
	@UIApplicationDelegateAdaptor(AppDelegate.self)
	private var appDelegate
	
	init() {
		let searchService = self.searchService
		let categoryService = self.categoryService
		let placeService = self.placeService
		let cardsService = self.cardsService
		let incomeService = self.incomeService
		AppDependencyManager.shared.add(dependency: searchService)
		AppDependencyManager.shared.add(dependency: categoryService)
		AppDependencyManager.shared.add(dependency: placeService)
		AppDependencyManager.shared.add(dependency: cardsService)
		AppDependencyManager.shared.add(dependency: incomeService)
	}

    var body: some Scene {
        WindowGroup {
			ContentView(container: container)
				.task {
					requestNotificationPermission()
					try? Tips.configure([
						.displayFrequency(.daily),
						.datastoreLocation(.applicationDefault)
					])
				}
        }
		.modelContainer(container)
		.environment(\.cardsService, cardsService)
		.environment(\.searchService, searchService)
		.environment(\.categoryService, categoryService)
		.environment(\.placeService, placeService)
		.environment(\.textDetectionService, AppFactory.provideTextDetectionService())
		.environment(\.incomeService, incomeService)
		.environment(\.notificationService, notificationService)
		.environment(\.userDataService, userDataService)
		.environment(\.toastService, toastService)
		.environment(\.widgetURLParser, AppFactory.provideWidgetURLParser())
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
		guard !isMonthlyNotificationScheduled, isNotificationAllowed else {
			return
		}
		
		notificationService.scheduleMonthlyNotification()
		isMonthlyNotificationScheduled = true
	}
}
