//
//  Store.swift
//  finalApp
//
//  Created by musel on 2022/11/12.
//  Copyright © 2022 musel. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation

enum Category: String, CaseIterable, Codable, Hashable {
    case type5 = "咖啡厅"
    case type2 = "火锅"
    case type1 = "西餐"
    case type4 = "快餐"
    case type3 = "奶茶"

}

struct Store: Hashable, Codable, Identifiable {
    var id: String
    var name: String
    var imageName: [String]
    fileprivate var coordinates: Coordinates
    var category: Category
    //var isFavorite: Bool
    var isAdvertised: Bool
    var manager:String
    var sumCost:Int

    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }
    
    var staredUserId: [String]
    
    init(id:String,name:String,imageName:[String],manager:String){
        self.id=id
        self.name=name
        self.imageName = imageName
        
        coordinates=Coordinates()
        category=Category(rawValue: "火锅")!
        //isFavorite=true
        isAdvertised=true
        staredUserId = [String]()
        self.manager = manager
        sumCost=0
        
    }

    
    
    init(){
        id=""
        name=""
        imageName = [String]()
        imageName.append("c001_1")
        coordinates=Coordinates()
        category=Category(rawValue: "火锅")!
        //isFavorite=true
        isAdvertised=true
        staredUserId = [String]()
        manager = ""
        sumCost=0
    }
}

extension Store {
    var image: [Image] {
        var tmp = [Image]()
        
        for oneName in imageName {
            tmp.append(ImageStore.shared.image(name:oneName))
        }
        return tmp
        
    }
}

struct Coordinates: Hashable, Codable {
    var latitude: Double
    var longitude: Double
    
    init(){
        latitude=0.0
        longitude=0.0
    }
}
