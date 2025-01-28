//
//  File.swift
//  Domain
//
//  Created by Alexander on 11.01.2025.
//

import TipKit

struct HowToEditCardTip: Tip {
	var title: Text {
		Text("Здесь можно переименовать карту, изменить форму выплаты или удалить")
	}
	
	init() {}
}
