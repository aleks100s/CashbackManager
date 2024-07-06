//
//  Navigation.swift
//  CashbackApp
//
//  Created by Alexander on 15.06.2024.
//

enum Navigation: Hashable {
	case selectBank([Bank])
	case selectCard(Bank)
	case cardDetail(Card)
	case addCashback(Card)
}
