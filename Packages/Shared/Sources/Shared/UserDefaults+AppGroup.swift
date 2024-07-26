//
//  UserDefaults+AppGroup.swift
//  CashbackManager
//
//  Created by Alexander on 26.07.2024.
//

import Foundation

public extension UserDefaults {
	static let appGroup = UserDefaults(suiteName: Constants.appGroup)
}
