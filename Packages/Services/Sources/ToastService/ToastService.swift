//
//  File.swift
//  Services
//
//  Created by Alexander on 07.11.2024.
//

import Combine
import Domain

public final class ToastService {
	public var toastPublisher: AnyPublisher<Toast?, Never> {
		toastSubject.eraseToAnyPublisher()
	}
	
	private let toastSubject = PassthroughSubject<Toast?, Never>()
	
	public init() {}
	
	public func show(_ toast: Toast) {
		toastSubject.send(toast)
	}
}
