//
//  Data.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 24.3.23..
//

import Foundation

class Data {
    var items = [
        DataModel(
            category: "ПРИРОДА",
            categoryEng: "Nature",
            categoryLat: "Priroda",
            subcategory: [
                " Аде",
                " Водопади",
                " Заштићена подручја ",
                " Излетишта и видиковци",
                " Језера",
                " Клисуре",
                " Пећине",
                " Планине",
                " Реке",
            ],
            expanded: false,
            categoryImageData: "nature",
            imageData: [
                "nature1",
                "nature2",
                "nature3",
                "nature4",
                "nature5",
                "nature6",
                "nature7",
                "nature8",
                "nature9"
            ]
        ),
        DataModel(
            category: "БАЊЕ",
            categoryEng: "Spa",
            categoryLat: "Banje",
            subcategory: [""],
            expanded :false,
            categoryImageData: "spa",
            imageData: []
        ),
        DataModel(
            category: "ГРАДОВИ",
            categoryEng: "Cities",
            categoryLat: "Gradovi",
            subcategory: [""],
            expanded :false,
            categoryImageData: "cities",
            imageData: []
        ),
        DataModel(
            category: "ГРАЂЕВИНЕ",
            categoryEng: "Buildings",
            categoryLat: "Gradjevine",
            subcategory: [
                " Бране и хидроелектране",
                " Дворци и виле",
                " Мостови",
                " Народно градитељство",
                " Палате",
                " Спомен-куће",
                " Тврђаве",
                " Торњеви",
                " Храмови"
            ],
            expanded :false,
            categoryImageData: "buildings",
            imageData: ["hydro","castle","bridges","peoplebuild","palaces","monumenthouses","castle","tower","temple"]
        ),
        DataModel(
            category: "КУЛТУРА",
            categoryEng: "Culture",
            categoryLat: "Kultura",
            subcategory: [
                " Библиотеке",
                " Биоскопи",
                " Галерије",
                " Истраживачки центри",
                " Културни центри",
                " Музеји и збирке",
                " Позоришта",
                " Споменици",
                " Сусрети ",
                " Целине "
            ],
            expanded :false,
            categoryImageData: "culture",
            imageData: [
                "libraries",
                "cinemas",
                "galleries",
                "research",
                "culturecentres",
                "museums",
                "theater",
                "monuments",
                "meetings",
                "entirety"]
        ),
        DataModel(
            category: "ЗАНИМЉИВОСТИ",
            categoryEng: "Interestgin",
            categoryLat: "Zanimljivosti",
            subcategory: [
                " Аква-паркови",
                " Гондоле",
                " Зоо-вртови",
                " Манифестације",
                " Природњачки центри",
                " Регате и крстарења",
                " Скеле"
            ],
            expanded :false,
            categoryImageData: "interesting",
            imageData: [
                "aqua",
                "gondolas",
                "zoos",
                "manifestations",
                "naturecenters",
                "regattas",
                "scaffold"]
        ),
        DataModel(
            category: "СПОРТ, РЕКРЕАЦИЈА",
            categoryEng: "Sport",
            categoryLat: "Sport,Rekreacija",
            subcategory: [
                " Адреналински",
                " Базени",
                " Дворане",
                " Купалишта",
                " Ловишта",
                " Риболов",
                " Скијалишта",
                " Спортови на води",
                " Спортски центри",
                " Стадиони",
                " Стазе" ,
                " Хиподроми"
            ],
            expanded :false,
            categoryImageData: "sport",
            imageData: [
                "adrenalin",
                "pools",
                "halls",
                "baths",
                "huntinggrounds",
                "fishing",
                "skies",
                "watersports",
                "sportcenters",
                "stadiums",
                "tracks",
                "hipodromes"
            ]
        ),
        DataModel(
            category: "ТУРИСТ-ИНФО ЦЕНТРИ",
            categoryEng: "Tourist-info centers",
            categoryLat: "Turist-info Centri",
            subcategory: [""
                         ],
            expanded :false,
            categoryImageData: "touristcenters",
            imageData: []
        ),
        DataModel(
            category: "СМЕШТАЈ",
            categoryEng: "Accommodation",
            categoryLat: "Smeštaj",
            subcategory: [
                " Домаћинства и етно-села",
                " Кампови",
                " Планинарски домови и одмаралишта",
                " Собе и апартмани",
                " Хостели",
                " Хотели"
            ],
            expanded :false,
            categoryImageData: "stay",
            imageData: [
                "etnovillage",
                "camps",
                "mountainhome",
                "rooms",
                "hostels",
                "hotels"
            ]
        ),
        DataModel(
            category: "УГОСТИТЕЉСТВО",
            categoryEng: "Catering",
            categoryLat: "Ugostiteljstvo",
            subcategory: [
                " Барови, пабови, клубови",
                " Винарије",
                " Кафеи и посластичарнице",
                " Ресторани (Сви. Општи, национални, пицерије, кафане",
                " Салаши и етно-куће"
            ],
            expanded :false,
            categoryImageData: "catering",
            imageData: [
                "bars",
                "wines",
                "caffes",
                "restaurants",
                "farms",
                ]
        ),
        DataModel(
            category: "ШОПИНГ",
            categoryEng: "Shopping",
            categoryLat: "Šoping",
            subcategory: [
                " Пијаце",
                " Тржни центри",
                " Шопинг зоне"
            ],
            expanded :false,
            categoryImageData: "shopping",
            imageData: [
                "markets",
            "shoppingcenters",
            "shoppingzones"]
        ),
        DataModel(
            category: "КОРИСНЕ ИНФОРМАЦИЈЕ",
            categoryEng: "Useful information",
            categoryLat: "Korisne Informacije",
            subcategory: [
                " Апотеке",
                " Банке",
                " Визни режим",
                " Гориво",
                " Здравље",
                " Мењачнице",
                " Мобилна телефонија",
                " Осигурање",
                " Паркинг",
                " Полиција",
                " Помоћ на путу",
                " Празници и нерадни дани",
                " Путовања",
                " Такси"
            ],
            expanded :false,
            categoryImageData: "usefulinfo",
            imageData: [
            "pharmacy",
            "banks",
            "regime",
            "fuel",
            "health",
            "exchange",
            "mobile",
            "insurance",
            "parking",
            "police",
            "roadhelp",
            "holidays",
            "travel",
            "taxi"
            ]
        )
    ]
}
