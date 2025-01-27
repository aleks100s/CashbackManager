//
//  File.swift
//  Services
//
//  Created by Alexander on 07.11.2024.
//

import Combine

final class ToastService {
	var toastPublisher: AnyPublisher<Toast?, Never> {
		toastSubject.eraseToAnyPublisher()
	}
	
	private let toastSubject = PassthroughSubject<Toast?, Never>()
	
	init() {}
	
	func show(_ toast: Toast) {
		toastSubject.send(toast)
	}
}
