//
//  File.swift
//  Domain
//
//  Created by Alexander on 11.01.2025.
//

import TipKit

public struct HowToEditCardTip: Tip {
	public var title: Text {
		Text("Здесь можно переименовать карту, изменить форму выплаты или удалить")
	}
	
	public init() {}
}
