//
//  File.swift
//  
//
//  Created by Alexander on 19.09.2024.
//

extension PredefinedCategory {
	var synonyms: [String] {
		switch self {
		case .allPurchases:
			["За все покупки", "На все покупки", "На всё"]
		case .education:
			["Курсы"]
		case .airplainTickets:
			["Авиаперелеты"]
		case .vipZone:
			[]
		case .carRent:
			["Прокат авто", "Автопрокат"]
		case .railRoadTickets:
			["Железные дороги", "Железнодорожные билеты"]
		case .tourAgencies:
			["Туризм"]
		case .cruises:
			[]
		case .hotels:
			[]
		case .dutyFreeShops:
			["Duty Free"]
		case .transport:
			[""]
		case .taxi:
			["Yandex Go", "Яндекс Go"]
		case .carSharing:
			[""]
		case .autoServices:
			["Автозапчасти", "Автосервис"]
		case .pharmacies:
			["Аптека", "Фармацея"]
		case .beautyAndSPA:
			["Салоны красоты", "Барбершопы", "Красота"]
		case .cosmeticsAndParfume:
			["Косметика и парфюмерия", "Магазины косметики"]
		case .houseAndRenovation:
			["Товары для дома"]
		case .art:
			[]
		case .books:
			["Книжные магазины", "Книжные лавки", "Канцтовары", "Книги и канцтовары"]
		case .zooGoods:
			["Зоомагазины", "Товары для животных", "Магазины для животных", "Животные", "Питомцы", "Домашние животные"]
		case .cinema:
			["Кинотеатры"]
		case .entertainment:
			[]
		case .exhibitionsAndMuseums:
			["Выставки", "Музеи", "Музеи и выставки"]
		case .medicineServices:
			[]
		case .fitness:
			["Спортзалы", "Спортивные залы"]
		case .clinicsAndEsthetics:
			[]
		case .dentist:
			["Стоматология", "Стоматологи"]
		case .music:
			["Магазины музыки"]
		case .supermarkets:
			[]
		case .shops:
			[]
		case .electronicDevices:
			["Магазины бытовой техники", "Магазины электроники"]
		case .restaurants:
			["Кафе и рестораны", "Бары"]
		case .fastfood:
			[]
		case .communicationAndTelecom:
			[]
		case .photoAndVideo:
			[]
		case .souvenirs:
			["Сувенирные магазины"]
		case .flowers:
			["Магазины цветов", "Цветочные"]
		case .sportGoods:
			["Магазины спортивных товаров", "Спортивные товары"]
		case .clothesAndShoes:
			["Аксессуары", "Магазины одежды", "Магазины обуви"]
		case .sbp:
			["СБП"]
		case .digitalGoods:
			["Цифровой контент"]
		case .yandex:
			[]
		case .burgerKing:
			["Burger King"]
		case .gasStation:
			["Топливо", "Автозаправки", "АЗС", "Бензин"]
		case .communalServices:
			["ЖКУ"]
		}
	}
}
