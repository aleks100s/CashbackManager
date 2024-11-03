//
//  ContentView.swift
//  CashbackManager
//
//  Created by Alexander on 26.10.2024.
//

import CashbackFeature
import CoreSpotlight
import Domain
import PaymentFeature
import PlaceFeature
import Shared
import SwiftData
import SwiftUI

struct ContentView: View {
	private enum Tab: String {
		case cashback
		case income
		case place
		case settings
	}
	
	let container: ModelContainer
	
	@AppStorage(Constants.StorageKey.AppFeature.cards)
	private var isCardsFeatureAvailable = true
	
	@AppStorage(Constants.StorageKey.AppFeature.payments)
	private var isPaymentsFeatureAvailable = true
	
	@AppStorage(Constants.StorageKey.AppFeature.places)
	private var isPlacesFeatureAvailable = true
	
	@AppStorage(Constants.StorageKey.firstLaunch)
	private var isFirstLaunch = true
	
	@Query private var categories: [Domain.Category]

	@State private var selectedTab = Tab.cashback
	
	@Environment(\.openURL) private var openURL
	
	var body: some View {
		TabView(selection: $selectedTab) {
			cashbackTab
			
			paymentsTab
			
			placesTab
			
			settingsTab
		}
		.onAppear {
			if isFirstLaunch {
				prepopulateDatabase()
			} else {
				actualizeDatabase()
			}
			isFirstLaunch = false
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
		.onContinueUserActivity(CSSearchableItemActionType) { userActivity in
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
	
	@ViewBuilder
	private var cashbackTab: some View {
		if isCardsFeatureAvailable {
			CashbackFeatureAssembly.assemble(
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
	}
	
	@ViewBuilder
	private var paymentsTab: some View {
		if isPaymentsFeatureAvailable {
			IncomeFeatureAssembly.assemble(
				createIncomeIntent: CreateIncomeIntent()
			)
			.tabItem {
				Label("Выплаты", systemImage: Constants.SFSymbols.income)
			}
			.tag(Tab.income)
		}
	}
	
	@ViewBuilder
	private var placesTab: some View {
		if isPlacesFeatureAvailable {
			PlaceFeatureAssembly.assemble(
				addPlaceIntent: CreatePlaceIntent(),
				checkPlaceIntent: CheckPlaceCategoryIntent(),
				addCategoryIntent: CreateCategoryIntent(),
				checkPlaceCardIntent: CheckPlaceCardIntent()
			)
			.tabItem {
				Label("Места", systemImage: Constants.SFSymbols.places)
			}
			.tag(Tab.place)
		}
	}
	
	private var settingsTab: some View {
		NavigationView {
			SettingsView()
		}
		.tabItem {
			Label("Настройки", systemImage: Constants.SFSymbols.settings)
		}
		.tag(Tab.settings)
	}
	
	private func prepopulateDatabase() {
		let categories = PredefinedCategory.allCases.map(\.asCategory)
		for category in categories {
			container.mainContext.insert(category)
		}
	}
	
	private func actualizeDatabase() {
		let predefinedCategories = PredefinedCategory.allCases.map(\.asCategory)
		for predefined in predefinedCategories {
			if let category = categories.first(where: { $0.name == predefined.name }) {
				category.synonyms = predefined.synonyms
			} else {
				container.mainContext.insert(predefined)
			}
		}
	}
}
