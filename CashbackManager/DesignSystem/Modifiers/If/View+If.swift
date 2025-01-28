//
//  View+If.swift
//
//
//  Created by Alexander on 21.07.2024.
//

import SwiftUI

extension View {
	/// Проверяет условие, если истинно, то применяет изменения к View.
	@inlinable @ViewBuilder
	func `if`<Content: View>(_ condition: @autoclosure () -> Bool, @ViewBuilder transform: (Self) -> Content) -> some View {
		if condition() {
			transform(self)
		} else {
			self
		}
	}
}
