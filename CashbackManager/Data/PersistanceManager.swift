//
//  PersistanceManager.swift
//  CashbackManager
//
//  Created by Alexander on 29.06.2024.
//

import Foundation

struct PersistanceManager: IPersistanceManager {
	private let encoder: JSONEncoder
	private let decoder: JSONDecoder
	private let defaults: UserDefaults
	
	init(
		encoder: JSONEncoder = JSONEncoder(),
		decoder: JSONDecoder = JSONDecoder(),
		defaults: UserDefaults = .standard
	) {
		self.encoder = encoder
		self.decoder = decoder
		self.defaults = defaults
	}
	
	func save(models: [some Model], for key: PersistanceKey) {
		do {
			let data = try encoder.encode(models)
			let string = String(data: data, encoding: .utf8)
			defaults.setValue(string, forKey: key.value)
		} catch {
			print(error)
		}
	}
	
	func readModels(for key: PersistanceKey) -> [any Model] {
		guard let string = defaults.value(forKey: key.value) as? String else {
			return []
		}
		
		let data = string.data(using: .utf8) ?? Data()
		do {
			let models = try decoder.decode(key.type, from: data) as? [any Model]
			return models ?? []
		} catch {
			print(error)
			return []
		}
	}
}

private extension PersistanceKey {
	var value: String {
		switch self {
		case .banks:
			"banks"
		case .categories:
			"categories"
		}
	}
	
	var type: Decodable.Type {
		switch self {
		case .banks:
			[Bank].self
		case .categories:
			[Category].self
		}
	}
}
