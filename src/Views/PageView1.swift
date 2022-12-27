//
//  PageView1.swift
//  finalApp
//
//  Created by musel on 2022/11/12.
//  Copyright © 2022 musel. All rights reserved.
//

import SwiftUI



struct PageView1: View {
    @EnvironmentObject var userData: UserData
    @State var search=""
    @State var search1=""
    @State var isActive=false
    
    //按类别给店铺分类
    var categories: [String: [Store]] {
        Dictionary(
            grouping: self.userData.stores,
            by: { $0.category.rawValue }
        )
    }
    
    //按是否推荐分类
    var advertised: [Store] {
        //self.userData.stores.filter { $0.isAdvertised }
        self.userData.stores.sorted(by: {$0.sumCost > $1.sumCost})
    }

    func hasnot(store:Store)->Bool{
        let y = self.userData.comments.filter{ $0.context.contains(self.search) }
        if(y.isEmpty){
            return true
        } else {
            let q = y.filter{ $0.store_id == store.id }
            return q.isEmpty
        }
    }

   
    var body: some View {
        VStack {
            TextField("搜索店铺、菜品",text: $search,onCommit: {
                              if(self.search != "") {
                                self.isActive = true
                                    self.userData.searchedStores = self.userData.stores.filter {
                                        $0.name.contains(self.search) || $0.category.rawValue.contains(self.search)
                                            || !self.hasnot(store: $0)
                                }
                                
                                
            }})
                .frame(width: 320,height: 30, alignment: .topLeading)
                
            .padding(10)
                
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
                
                .overlay(
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 6)
            )
            .padding(.horizontal, 10)
            
        
            NavigationView {
                
            
            VStack {
                
                NavigationLink(destination: StoreList(),isActive: self.$isActive) {
                    Text("")
                }.frame(height:0)
                
                HStack{
                    Image(systemName: "calendar").font(.title)
                Text("每日促销")
                }
            HStack{
                 
                Spacer()
                Text("右滑浏览更多>>")
                    .foregroundColor(Color.gray.opacity(0.8))
                .font(.headline)
                
                    .padding(.trailing, 10)}
                
                
                AdvertisedStores2(stores: advertised)
                    //.scaledToFill()
                    //.frame(height: 200)
                    //.clipped()
                    //.frame(height: 200)
                    
                    .listRowInsets(EdgeInsets())
                
                
                HStack{
                    Image(systemName: "text.bubble").font(.title)
                    Text("精选评价")
                    
                }.padding(.top,10).padding(.bottom,0)
                    
                
                /*
                HStack{
                                
                               Spacer()
                               Text("下拉刷新推荐")
                               .font(.headline)
                               
                                   .padding(.trailing, 10)}*/
                
                
                CommentShow(comments: self.userData.comments)
                //.scaledToFill()
                //.frame(height: 200)
                .clipped()
                .listRowInsets(EdgeInsets())
                   
                Spacer()
            }}//.navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
    }
}

}
