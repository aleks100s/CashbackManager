//
//  File.swift
//  Services
//
//  Created by Alexander on 27.10.2024.
//

import SwiftUI

private struct UserDataServiceKey: EnvironmentKey {
	static let defaultValue: UserDataService? = nil
}

public extension EnvironmentValues {
	var userDataService: UserDataService? {
		get { self[UserDataServiceKey.self] }
		set { self[UserDataServiceKey.self] = newValue }
	}
}
