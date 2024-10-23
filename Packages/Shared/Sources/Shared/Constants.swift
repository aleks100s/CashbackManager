//
//  Constants.swift
//  CashbackManager
//
//  Created by Alexander on 26.07.2024.
//

public enum Constants {
	public enum SFSymbols {
		public static let cashback = "creditcard"
		public static let income = "rublesign.circle"
		public static let places = "storefront"
		public static let settings = "gear"
	}
	
	public enum StorageKey {
		public static let notifications = "isMonthlyNotificationScheduled"
		public static let siriTips = "areSiriTipsVisible"
		public static let currentCardID = "CurrentCardID"
		public static let firstLaunch = "IsFirstLaunch"
		public static let notificationsAllowed = "isNotificationAllowed"
	}
	
	public static let appIdentifier = "com.alextos.CashbackManager"
	public static let appGroup = "group.com.alextos.cashback"
	public static let cardWidgetKind = "CardWidget"
	public static let urlSchemeCard = "cashback://cashback/card/"
	public static let urlSchemePlace = "cashback://cashback/place/"
}
