//
//  View+ViewSize.swift
//
//
//  Created by Alexander on 21.07.2024.
//

import SwiftUI

public extension View {
	func viewSize(_ size: ViewSize) -> some View {
		environment(\.viewSize, size)
	}
}
