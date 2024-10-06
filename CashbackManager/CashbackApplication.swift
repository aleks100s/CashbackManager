//
//  CashbackApplication.swift
//  CashbackManager
//
//  Created by Alexander on 10.06.2024.
//

import AppIntents
import CashbackFeature
import CoreSpotlight
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
	private enum Tab: String {
		case cashback
		case place
	}
	
	private let container = AppFactory.provideModelContainer()
	private let searchService = AppFactory.provideSearchService()
	private let categoryService = AppFactory.provideCategoryService()
	private let placeService = AppFactory.providePlaceService()
	private let cardsService = AppFactory.provideCardsService()
		
	@AppStorage("isMonthlyNotificationScheduled")
	private var isMonthlyNotificationScheduled = false
	
	@State private var selectedTab = Tab.cashback
	
	@Environment(\.openURL) private var openURL
	
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
			TabView(selection: $selectedTab) {
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
				.tag(Tab.cashback)
				
				PlaceFeatureAssembly.assemble(
					addPlaceIntent: CreatePlaceIntent(),
					checkPlaceIntent: CheckPlaceCategoryIntent(),
					addCategoryIntent: CreateCategoryIntent()
				)
				.tabItem {
					Label("Места", systemImage: Constants.SFSymbols.places)
				}
				.tag(Tab.place)
			}
			.task {
				requestNotificationPermission()
			}
			.onOpenURL { url in
				switch url.host() {
				case Tab.cashback.rawValue:
					selectedTab = .cashback
				case Tab.place.rawValue:
					selectedTab = .place
				default:
					break
				}
			}
			.onContinueUserActivity(CSSearchableItemActionType){ userActivity in
				if let userinfo = userActivity.userInfo as? [String:Any] {
					let identifier = userinfo["kCSSearchableItemActivityIdentifier"] as? String ?? ""
					let queryString = userinfo["kCSSearchQueryString"] as? String ?? ""
					if let url = URL(string: "\(Constants.urlSchemeCard)\(identifier)") {
						openURL(url)
					}
					print(identifier,queryString)
				}
			}
        }
		.modelContainer(container)
		.environment(\.searchService, searchService)
		.environment(\.categoryService, categoryService)
		.environment(\.placeService, placeService)
		.environment(\.textDetectionService, AppFactory.provideTextDetectionService())
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
