//
//  File.swift
//  Domain
//
//  Created by Alexander on 08.01.2025.
//

public enum Currency: String, CaseIterable, Identifiable {
	case rubles = "Рубли"
	case miles = "Мили"
	case points = "Баллы"
	
	public var id: String { rawValue }
	
	public var symbol: String {
		switch self {
		case .rubles: "₽"
		case .miles: "М"
		case .points: "Б"
		}
	}
}
