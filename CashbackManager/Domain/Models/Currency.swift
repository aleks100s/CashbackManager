//
//  File.swift
//  Domain
//
//  Created by Alexander on 08.01.2025.
//

enum Currency: String, CaseIterable, Identifiable {
	case rubles = "Рубли"
	case miles = "Мили"
	case points = "Баллы"
	
	var id: String { rawValue }
	
	var symbol: String {
		switch self {
		case .rubles: "₽"
		case .miles: "М"
		case .points: "Б"
		}
	}
}
