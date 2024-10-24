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
import IncomeService
import PaymentFeature
import PlaceFeature
import SearchService
import Shared
import SwiftData
import SwiftUI

@main
@MainActor
struct CashbackApplication: App {
	private enum Tab: String {
		case cashback
		case income
		case place
		case settings
	}
	
	private let container = AppFactory.provideModelContainer()
	private let searchService = AppFactory.provideSearchService()
	private let categoryService = AppFactory.provideCategoryService()
	private let placeService = AppFactory.providePlaceService()
	private let cardsService = AppFactory.provideCardsService()
	private let incomeService = AppFactory.provideIncomeService()
	private let notificationService = AppFactory.provideNotificationService()
		
	@AppStorage(Constants.StorageKey.notifications)
	private var isMonthlyNotificationScheduled = false
	
	@AppStorage(Constants.StorageKey.notificationsAllowed)
	private var isNotificationAllowed = true
	
	@AppStorage(Constants.StorageKey.AppFeature.cards)
	private var isCardsFeatureAvailable = true
	
	@AppStorage(Constants.StorageKey.AppFeature.payments)
	private var isPaymentsFeatureAvailable = true
	
	@AppStorage(Constants.StorageKey.AppFeature.places)
	private var isPlacesFeatureAvailable = true
	
	@State private var selectedTab = Tab.cashback
	
	@Environment(\.openURL) private var openURL
	
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
			TabView(selection: $selectedTab) {
				if isCardsFeatureAvailable {
					CashbackFeatureAssembly.assemble(
						container: container,
						addCardIntent: CreateCardIntent(),
						checkCategoryCardIntent: CheckCategoryCardsIntent(),
						cardCashbackIntent: CheckCardCashbackIntent(),
						addCategoryIntent: CreateCategoryIntent(),
						addCashbackIntent: CreateCashbackIntent()
					)
					.tabItem {
						Label("Карты", systemImage: Constants.SFSymbols.cashback)
					}
					.tag(Tab.cashback)
				}
				
				if isPaymentsFeatureAvailable {
					IncomeFeatureAssembly.assemble(
						createIncomeIntent: CreateIncomeIntent()
					)
					.tabItem {
						Label("Выплаты", systemImage: Constants.SFSymbols.income)
					}
					.tag(Tab.income)
				}
				
				if isPlacesFeatureAvailable {
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
				
				NavigationView {
					SettingsView()
				}
				.tabItem {
					Label("Настройки", systemImage: Constants.SFSymbols.settings)
				}
				.tag(Tab.settings)
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
		.environment(\.incomeService, incomeService)
		.environment(\.notificationService, notificationService)
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
