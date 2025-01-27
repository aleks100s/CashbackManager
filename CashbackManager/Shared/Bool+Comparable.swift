//
//  File.swift
//  Shared
//
//  Created by Alexander on 07.11.2024.
//

extension Bool: @retroactive Comparable {
	public static func < (lhs: Bool, rhs: Bool) -> Bool {
		return !lhs && rhs
	}
}
