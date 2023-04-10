//
//  DataModel.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 24.3.23..
//


import Foundation

class DataModel{
    var category: String
    var categoryEng:String
    var categoryLat:String
    var subcategory: [String]
    var expanded: Bool
    var categoryImageData : String
    var imageData : [String]
    
    init(category: String,categoryEng:String,categoryLat:String, subcategory: [String],expanded:Bool,categoryImageData:String,imageData:[String]) {
        self.category = category
        self.categoryEng = categoryEng
        self.categoryLat = categoryLat
        self.subcategory = subcategory
        self.expanded = expanded
        self.categoryImageData = categoryImageData
        self.imageData = imageData
    }
}
    
