//
//  File.swift
//  Services
//
//  Created by Alexander on 07.11.2024.
//

import SwiftUI

private struct ToastServiceKey: EnvironmentKey {
	static let defaultValue: ToastService? = nil
}

extension EnvironmentValues {
	var toastService: ToastService? {
		get { self[ToastServiceKey.self] }
		set { self[ToastServiceKey.self] = newValue }
	}
}
