//
//  LanguageConstants.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 24.4.23..
//

import Foundation
import CoreLocation

class Constants {
    static let constants = Constants()
    
    //Language
    let userDefKey = UserDefaults.standard.string(forKey: "Language")
    let memoriesTabArray = ["УСПОМЕНЕ СА ПОСЕЋЕНИХ ЛОКАЦИЈА", "USPOMENE SA POSEĆENIH LOKACIJA", "MEMORIES FROM VISITED LOCATIONS"]
    let roomsArray = ["СМЕШТАЈ  И РЕЗЕРВАЦИЈЕ","SMEŠTAJ  I REZERVACIJE","ROOMS AND SERVICES"]
    let postsArray = ["ОБЈАВЕ","OBJAVE","POSTS"]
    let membershipArray = ["ЧЛАНАРИНА И ПЛАЋАЊА","ČLANARINA I PLAĆANJA","MEMBERSHIP AND PAYMENT"]
    
    let loginStringConstant = [""]
    let registerStringConstant = [""]
    let nextButtonConstant = [""]
    
    //BoundingBox
    let serbiaSouthWest = CLLocationCoordinate2D(latitude: 42.245826, longitude: 18.829444)
    let serbiaNorthEast = CLLocationCoordinate2D(latitude: 46.193056, longitude: 23.013334)
    
    let userDefLoginKey = UserDefaults.standard.bool(forKey: "logedIn")
}
