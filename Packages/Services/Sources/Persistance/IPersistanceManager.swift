//
//  IPersistanceManager.swift
//  CashbackManager
//
//  Created by Alexander on 29.06.2024.
//

import Domain
import Foundation

public protocol IPersistanceManager {
	func save(models: [some Model], for key: PersistanceKey)
	func readModels(for key: PersistanceKey) -> [any Model]
}
