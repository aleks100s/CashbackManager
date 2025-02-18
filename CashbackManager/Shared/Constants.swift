//
//  Constants.swift
//  CashbackManager
//
//  Created by Alexander on 26.07.2024.
//

import Foundation

enum Constants {
	enum SFSymbols {
		static let cashback = "creditcard"
		static let income = "rublesign.circle"
		static let places = "storefront"
		static let settings = "gear"
		static let search = "magnifyingglass"
	}
	
	enum StorageKey {
		enum AppFeature {
			static let cards = "cards"
			static let payments = "payments"
			static let places = "places"
		}
		
		static let notifications = "isMonthlyNotificationScheduled"
		static let siriTips = "areSiriTipsVisible"
		static let currentCardID = "CurrentCardID"
		static let firstLaunch = "IsFirstLaunch"
		static let notificationsAllowed = "isNotificationAllowed"
		static let isAdVisible = "isAdVisible"
	}
	
	static let resetAppNavigationNotification = Notification.Name(rawValue: "resetAppNavigationNotification")
	static let appIdentifier = "com.alextos.CashbackManager"
	static let appGroup = "group.com.alextos.cashback"
	static let cardWidgetKind = "CardWidget"
	static let favouriteCardsWidgetKind = "FavouriteCardsWidget"
	static let urlSchemeCard = "cashback://cashback/card/"
	static let urlSchemePlace = "cashback://cashback/place/"
	static let appStoreLink = URL(string: "https://apps.apple.com/app/id6517354748")
	static let ruStoreLink = URL(string: "https://www.rustore.ru/catalog/app/com.alextos.cashback")
}
