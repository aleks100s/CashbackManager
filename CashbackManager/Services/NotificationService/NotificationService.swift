//
//  NotificationService.swift
//  Services
//
//  Created by Alexander on 24.10.2024.
//

import UserNotifications

struct NotificationService {
	init() {}

	func scheduleMonthlyNotification() {
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
		content.body = "Не забудьте выбрать и сохранить кэшбэк в этом месяце"
		content.sound = .default

		// Создание уникального идентификатора для уведомления
		let identifier = Constants.appIdentifier

		// Создание запроса уведомления
		let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

		// Добавление запроса
		center.add(request) { _ in }
	}
	
	func unscheduleMonthlyNotification() {
		let center = UNUserNotificationCenter.current()
		center.removeAllPendingNotificationRequests()
	}
}
