//
//  PersistanceManager.swift
//  CashbackManager
//
//  Created by Alexander on 29.06.2024.
//

import Domain
import Foundation
import Persistance

public struct PersistanceManager: IPersistanceManager {
	private let encoder: JSONEncoder
	private let decoder: JSONDecoder
	private let defaults: UserDefaults
	
	public init(
		encoder: JSONEncoder = JSONEncoder(),
		decoder: JSONDecoder = JSONDecoder(),
		defaults: UserDefaults?
	) {
		self.encoder = encoder
		self.decoder = decoder
		self.defaults = defaults ?? .standard
	}
	
	public func save(models: [some Model], for key: PersistanceKey) {
		do {
			let data = try encoder.encode(models)
			let string = String(data: data, encoding: .utf8)
			defaults.setValue(string, forKey: key.value)
		} catch {
			print(error)
		}
	}
	
	public func readModels(for key: PersistanceKey) -> [any Model] {
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
		case .cards:
			"cards"
		case .categories:
			"categories"
		case .widgetCurrentCard:
			"widgetCurrentCard"
		}
	}
	
	var type: Decodable.Type {
		switch self {
		case .cards:
			[Card].self
		case .categories:
			[Domain.Category].self
		case .widgetCurrentCard:
			[Card].self
		}
	}
}
