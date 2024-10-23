//
//  SettingsView.swift
//  CashbackManager
//
//  Created by Alexander on 23.10.2024.
//

import Shared
import SwiftUI

struct SettingsView: View {
	private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
	private let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
	
	@AppStorage(Constants.StorageKey.siriTips)
	private var areSiriTipsVisible = true
	
	@AppStorage(Constants.StorageKey.notificationsAllowed)
	private var isNotificationAllowed = true
	
	@State private var isToastShown = false
	
	var body: some View {
		List {
			Section {
				Toggle("Подсказки Siri", isOn: $areSiriTipsVisible)
			} header: {
				Text("Настройки голосовых команд")
			} footer: {
				Text("Подсказки голосовых команд можно показать или скрыть в любой момент")
			}
			
			Section {
				Toggle("Уведомления", isOn: $isNotificationAllowed)
			} header: {
				Text("Настройки уведомлений")
			} footer: {
				Text("Приложение напомнит вам выбрать и сохранить кэшбэк каждый месяц 1 числа.\nПроверьте, что вы разрешили уведомления в настройках системы.")
			}

			Section("О приложении") {
				ItemView(title: "Версия приложения", value: appVersion, onTap: copy(value:))
				
				ItemView(title: "Версия сборки", value: buildVersion, onTap: copy(value:))
			}
			
			if let url = Constants.appStoreLink {
				ShareLink(item: url, subject: Text("Ссылка на App Store")) {
					Text("Поделиться приложением")
				}
			}
		}
		.overlay(alignment: .bottom) {
			if isToastShown {
				Text("Версия скопирована!")
					.padding()
					.background(.regularMaterial)
					.clipShape(.capsule)
					.padding(.bottom)
					.transition(.move(edge: .bottom).combined(with: .opacity))
			}
		}
		.navigationTitle("Настройки приложения")
		.navigationBarTitleDisplayMode(.inline)
		.onChange(of: isNotificationAllowed, initial: false) { _, isAllowed in
			if isAllowed {
				NotificationManager.scheduleMonthlyNotification()
			} else {
				NotificationManager.unscheduleMonthlyNotification()
			}
		}
	}
	
	private func copy(value: String?) {
		UIPasteboard.general.string = value
		withAnimation {
			isToastShown = true
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
				withAnimation {
					self.isToastShown = false
				}
			}
		}
	}
}

private struct ItemView: View {
	let title: String
	let value: String?
	let onTap: (String?) -> Void
	
	var body: some View {
		HStack {
			Text(title)
				.foregroundStyle(.secondary)
			
			Spacer()
			
			Text(value ?? "")
		}
		.contentShape(.rect)
		.onTapGesture {
			onTap(value)
		}
	}
}
