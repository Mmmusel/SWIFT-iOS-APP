//
//  Comment.swift
//  finalApp
//
//  Created by musel on 2022/11/12.
//  Copyright © 2022 musel. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation

struct Comment: Hashable, Codable, Identifiable {
    var id: String
    var store_id: String
    var user_name:String
    var rating:Int
    var context:String
    var commentImageName: [String]
    
    init(id:String,store_id:String,user_name:String,rating:Int,context:String,commentImageName: [String]){
        self.id=id
        self.store_id=store_id
        self.user_name=user_name
        self.rating=rating
        self.context=context
        self.commentImageName=commentImageName
    }
    
}

extension Comment {
    var commentImage: [Image] {
        var tmp = [Image]()
        
        for oneName in commentImageName {
            tmp.append(ImageStore.shared.image(name:oneName))
        }
        return tmp
        
    }
}

