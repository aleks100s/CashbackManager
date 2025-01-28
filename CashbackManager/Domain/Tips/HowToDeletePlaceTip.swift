//
//  File.swift
//  Domain
//
//  Created by Alexander on 11.01.2025.
//

import TipKit

struct HowToDeletePlaceTip: Tip {
	var title: Text {
		Text("Перейдите в режим редактирования, чтобы переименовать место, изменить категорию или удалить его")
	}
	
	init() {}
}
