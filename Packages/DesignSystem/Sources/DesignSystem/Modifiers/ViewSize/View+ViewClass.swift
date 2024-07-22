//
//  View+ViewClass.swift
//
//
//  Created by Alexander on 21.07.2024.
//

import SwiftUI

public extension View {
	func viewClass(_ viewClass: ViewClass) -> some View {
		environment(\.viewClass, viewClass)
	}
}
