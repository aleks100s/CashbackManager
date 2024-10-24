//
//  File.swift
//  DesignSystem
//
//  Created by Alexander on 23.10.2024.
//

import SwiftUI

struct ToastModifier: ViewModifier {
	@Binding var toast: Toast?

	func body(content: Content) -> some View {
		content.overlay(alignment: .bottom) {
			if let toast {
				ToastView(title: toast.title)
					.padding(.bottom)
					.transition(.move(edge: .bottom).combined(with: .opacity))
			}
		}
		.animation(.spring, value: toast)
		.sensoryFeedback(.impact, trigger: toast)
		.onChange(of: toast) { oldValue, newValue in
			if newValue != nil {
				trigger()
			}
		}
	}
	
	private func trigger() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			withAnimation {
				self.toast = nil
			}
		}
	}
}

public extension View {
	func toast(item: Binding<Toast?>) -> some View {
		modifier(ToastModifier(toast: item))
	}
}
