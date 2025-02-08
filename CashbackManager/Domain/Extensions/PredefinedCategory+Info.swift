//
//  PredefinedCategory+Info.swift
//  CashbackManager
//
//  Created by Alexander on 08.02.2025.
//

extension PredefinedCategory {
	var info: String? {
		switch self {
		case .allPurchases:
			nil
		case .education:
			"Школы, колледжи и университеты, бизнес-курсы и образовательные услуги"
		case .airplainTickets:
			nil
		case .vipZone:
			nil
		case .carRent:
			"Прокат автомобилей, домов на колесах, трейлеров и грузовиков:"
		case .railRoadTickets:
			"Билеты на поезда дальнего следования"
		case .tourAgencies:
			"Туроператоры, круизы"
		case .cruises:
			nil
		case .hotels:
			"Гостиничные номера, отели, мотели, курорты, рекреационные и спортивные лагеря, кемпинги"
		case .dutyFreeShops:
			"Беспошлинные магазины Duty Free"
		case .transport:
			"Городской и междугородный транспорт, такси, стоянка автомобилей; продажа снегоходов, автодомов и прицепов"
		case .taxi:
			nil
		case .carSharing:
			nil
		case .autoServices:
			"Продажа, лизинг, сервис и ремонт автомобилей, магазины автозапчастей, мотоциклов, автомойки"
		case .pharmacies:
			nil
		case .beautyAndSPA:
			"Парикмахерские и салоны красоты, массаж и магазины косметики, спа"
		case .cosmeticsAndParfume:
			nil
		case .houseAndRenovation:
			"Магазины строительных материалов, мебели, хозтоваров, например IKEA и «Леруа Мерлен»"
		case .art:
			"Антикварные магазины, магазины художественных изделий и мастерства, картинные галереи; магазины марок и монет; религиозные товары"
		case .books:
			"Книжные магазины"
		case .zooGoods:
			"Зоомагазины и ветеринарные услуги"
		case .cinema:
			"Кинотеатры и прокат фильмов"
		case .entertainment:
			"Билеты в театр и на концерты, боулинг, бильярд, спортивные клубы; аквариумы, дельфинарии и зоопарки, парки аттракционов, гольф-поля"
		case .exhibitionsAndMuseums:
			nil
		case .medicineServices:
			"Скорая помощь, больницы, стоматологические клиники, медицинские лаборатории, ортопедические салоны и оптика"
		case .fitness:
			nil
		case .clinicsAndEsthetics:
			nil
		case .dentist:
			nil
		case .music:
			"Магазины музыкальных инструментов, студии звукозаписи"
		case .supermarkets:
			"Супер- и гипермаркеты"
		case .shops:
			"Универмаги, непродовольственные товары, ломбарды, канцтовары, магазины игрушек"
		case .digitalGoods:
			"Цифровые товары и программное обеспечение"
		case .electronicDevices:
			"Компьютеры, офисная и бытовая техника"
		case .restaurants:
			"Кафе, рестораны, столовые, бары и ночные клубы"
		case .fastfood:
			nil
		case .yandex:
			nil
		case .communicationAndTelecom:
			"Телефония, денежные переводы, обработка данных, поиск информации, ремонт компьютеров"
		case .photoAndVideo:
			"фотостудии и фотолаборатории, копировальные услуги"
		case .souvenirs:
			"Магазины подарков, сувениров и открыток"
		case .flowers:
			"Магазины цветов, товары для флористики:"
		case .sportGoods:
			"Спортивная одежда, веломагазины и другие спорттовары"
		case .clothesAndShoes:
			"Магазины одежды и обуви, ювелирные магазины, аксессуары, изделия из кожи и меха"
		case .sbp:
			"Оплата по СБП"
		case .burgerKing:
			nil
		case .gasStation:
			"Покупки на автозаправках, даже если купить там кофе"
		case .communalServices:
			nil
		case .accessories:
			nil
		}
	}
}
