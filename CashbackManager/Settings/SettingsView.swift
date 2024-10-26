//
//  SettingsView.swift
//  CashbackManager
//
//  Created by Alexander on 23.10.2024.
//

import DesignSystem
import NotificationService
import Shared
import SwiftUI

struct SettingsView: View {
	private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
	private let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
	
	@AppStorage(Constants.StorageKey.siriTips)
	private var areSiriTipsVisible = true
	
	@AppStorage(Constants.StorageKey.notificationsAllowed)
	private var isNotificationAllowed = true
	
	@AppStorage(Constants.StorageKey.AppFeature.cards)
	private var isCardsFeatureAvailable = true
	
	@AppStorage(Constants.StorageKey.AppFeature.payments)
	private var isPaymentsFeatureAvailable = true
	
	@AppStorage(Constants.StorageKey.AppFeature.places)
	private var isPlacesFeatureAvailable = true
	
	@State private var toast: Toast?
	@State private var exportUrl: URL?
	@State private var isBusy = false
	
	@Environment(\.notificationService)
	private var notificationService
	
	@Environment(\.userDataService)
	private var userDataService
	
	var body: some View {
		List {
			Section {
				Toggle("Подсказки Siri", isOn: $areSiriTipsVisible)
					.onChange(of: areSiriTipsVisible) { _, newValue in
						toast = Toast(title: newValue ? "Подсказки включены" : "Подсказки отключены")
					}
			} header: {
				Text("Настройка голосовых команд")
			} footer: {
				Text("Подсказки голосовых команд можно показать или скрыть в любой момент")
			}
			
			Section {
				Toggle("Уведомления", isOn: $isNotificationAllowed)
					.onChange(of: isNotificationAllowed) { _, newValue in
						toast = Toast(title: newValue ? "Уведомления включены" : "Уведомления отключены")
					}
			} header: {
				Text("Настройка уведомлений")
			} footer: {
				Text("Приложение напомнит вам выбрать и сохранить кэшбэк каждый месяц 1 числа.\nПроверьте, что вы разрешили уведомления в настройках системы.")
			}
			
			Section {
				Toggle("Карты", isOn: $isCardsFeatureAvailable)
					.onChange(of: isCardsFeatureAvailable) { _, newValue in
						toast = Toast(title: newValue ? "Раздел активен" : "Раздел скрыт")
					}
				Toggle("Выплаты", isOn: $isPaymentsFeatureAvailable)
					.onChange(of: isPaymentsFeatureAvailable) { _, newValue in
						toast = Toast(title: newValue ? "Раздел активен" : "Раздел скрыт")
					}
				Toggle("Места", isOn: $isPlacesFeatureAvailable)
					.onChange(of: isPlacesFeatureAvailable) { _, newValue in
						toast = Toast(title: newValue ? "Раздел активен" : "Раздел скрыт")
					}
			} header: {
				Text("Настройки разделов приложения")
			} footer: {
				Text("Отключение разделов позволит сфокусироваться только на необходимом Вам функционале. Разделы можно включить или отключить в любое время без потери данных.")
			}

			Section {
				if let exportUrl {
					ShareLink("Отправить файл", item: exportUrl)
				} else {
					Button("Подготовить данные для переноса") {
						prepareExportData()
					}
				}
			} header: {
				Text("Перенос данных на другое устройство")
			} footer: {
				Text("Экспортируйте данные с одного устройства и откройте файл в приложении на новом девайсе")
			}

			Section("О приложении") {
				ItemView(title: "Версия приложения", value: appVersion, onTap: copy)
				
				ItemView(title: "Версия сборки", value: buildVersion, onTap: copy)
			}
			
			if let url = Constants.appStoreLink {
				ShareLink(item: url, subject: Text("Ссылка на App Store")) {
					Text("Поделиться приложением")
				}
			}
		}
		.toast(item: $toast)
		.navigationTitle("Настройки приложения")
		.navigationBarTitleDisplayMode(.inline)
		.onChange(of: isNotificationAllowed, initial: false) { _, isAllowed in
			if isAllowed {
				notificationService?.scheduleMonthlyNotification()
			} else {
				notificationService?.unscheduleMonthlyNotification()
			}
		}
		.disabled(isBusy)
		.overlay {
			if isBusy {
				Color.gray.opacity(0.2)
				ProgressView()
			}
		}
	}
	
	private func prepareExportData() {
		isBusy = true
		Task.detached {
			let url = try await userDataService?.generateExportFile()
			await MainActor.run {
				exportUrl = url
				isBusy = false
			}
		}
	}
	
	private func copy(value: String?) {
		toast = Toast(title: "Значение скопировано")
		UIPasteboard.general.string = value
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
