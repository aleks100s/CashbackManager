//
//  NotificationServiceKey.swift
//  Services
//
//  Created by Alexander on 12.10.2024.
//

import SwiftUI

private struct NotificationServiceKey: EnvironmentKey {
	static let defaultValue: NotificationService? = nil
}

extension EnvironmentValues {
	var notificationService: NotificationService? {
		get { self[NotificationServiceKey.self] }
		set { self[NotificationServiceKey.self] = newValue }
	}
}
