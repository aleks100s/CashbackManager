//
//  File.swift
//  DesignSystem
//
//  Created by Alexander on 23.10.2024.
//

import SwiftUI

struct ToastModifier: ViewModifier {
	@Binding var value: String?

	func body(content: Content) -> some View {
		content.overlay(alignment: .bottom) {
			if value != nil {
				ToastView(title: "Значение скопировано")
					.padding(.bottom)
					.transition(.move(edge: .bottom).combined(with: .opacity))
			}
		}
		.animation(.spring, value: value)
		.onChange(of: value) { oldValue, newValue in
			if newValue != nil {
				trigger()
			}
		}
	}
	
	private func trigger() {
		print("Toast appeared")
		UIPasteboard.general.string = value
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			withAnimation {
				self.value = nil
				print("Toast disappeared")
			}
		}
	}
}

public extension View {
	func toast(value: Binding<String?>) -> some View {
		modifier(ToastModifier(value: value))
	}
}
