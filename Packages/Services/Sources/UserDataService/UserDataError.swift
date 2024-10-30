//
//  File.swift
//  Services
//
//  Created by Alexander on 27.10.2024.
//

import Foundation

enum UserDataError: LocalizedError {
	case cachesDirectoryNotFound
	case noPermission
	
	var localizedDescription: String? {
		switch self {
		case .cachesDirectoryNotFound:
			"Не удалось открыть файл (директория кэша не найдена)"
		case .noPermission:
			"Нет прав на чтение/запись"
		}
	}
}
