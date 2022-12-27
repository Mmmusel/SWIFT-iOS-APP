//
//  UserData.swift
//  finalApp
//
//  Created by musel on 2022/11/12.
//  Copyright © 2022 musel. All rights reserved.
//

import Foundation
import Combine
import SwiftUI



final class UserData: ObservableObject {
    @Published var selection = 0
    
    
    @Published var hasInit = ddd
    @Published var showFavoritesOnly = false
    @Published var stores = storeData
    @Published var comments = commentData
    @Published var userInfos = userInfoData
    
    @Published var clickDic = clickDicData
    @Published var sortedComments = commentData
    @Published var searchedStores = storeData
    @Published var add=false
    
    
    @Published var isManager = false
    
    
    
    @Published var userName = ""
    
    
    func store2click(store:String) -> Int {
        let index = stores.firstIndex(where: { $0.id == store })!
        return clickDic[stores[index].category]!
    }
    
}
