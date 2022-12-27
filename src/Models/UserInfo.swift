//
//  UserInfo.swift
//  finalApp
//
//  Created by musel on 2022/11/17.
//  Copyright © 2022 musel. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation

struct UserInfo: Hashable, Codable, Identifiable {
    var id: String
    var name: String
    var keyword: String
    var profile: String
    var type: String

    
    init(id:String,name:String,keyword:String,profile:String,type:String){
        self.id=id
        self.name=name
        self.keyword=keyword
        self.profile=profile
        self.type=type
        
    }
}

extension UserInfo {
    var profileImg: Image {

        return ImageStore.shared.image(name:profile)
        
    }
}
