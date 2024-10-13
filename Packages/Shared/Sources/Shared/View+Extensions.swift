//
//  View+Extensions.swift
//
//
//  Created by Alexander on 29.07.2024.
//

import SwiftUI

public extension View {
	func snapshot() -> UIImage {
		let controller = UIHostingController(rootView: self)
		let view = controller.view
		let targetSize = controller.view.intrinsicContentSize
		view?.bounds = CGRect(origin: .zero, size: targetSize)
		view?.backgroundColor = .clear
		let renderer = UIGraphicsImageRenderer(size: targetSize)
		return renderer.image { _ in
			view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
		}
	}
}

struct OnFirstAppearModifier: ViewModifier {
	@State private var hasAppeared = false
	
	let action: () -> Void

	func body(content: Content) -> some View {
		content
			.onAppear {
				if !hasAppeared {
					action()
					hasAppeared = true
				}
			}
	}
}

public extension View {
	func onFirstAppear(perform action: @escaping () -> Void) -> some View {
		self.modifier(OnFirstAppearModifier(action: action))
	}
}
