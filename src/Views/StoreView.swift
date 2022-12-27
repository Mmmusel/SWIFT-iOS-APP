//
//  StoreView.swift
//  finalApp
//
//  Created by musel on 2022/11/12.
//  Copyright © 2022 musel. All rights reserved.
//

import Foundation
import SwiftUI



struct StoreView: View {
    @EnvironmentObject var userData: UserData
    var store: Store
    @State var registerAlert=false
    
    
    
    
    var storeComments: [Comment] {
        userData.comments.filter { $0.store_id == store.id }
    }
    
    var storeIndex: Int {
        userData.stores.firstIndex(where: { $0.id == store.id })!
    }
    
    func toggleUserStaredStore(){
        if(userData.userName==""){
            self.registerAlert=true
        }else{
        
        let userid = self.userData.userInfos.filter { $0.name == self.userData.userName} [0].id
        if(self.userData.stores[self.storeIndex].staredUserId.contains(userid)){
            let i = self.userData.stores[self.storeIndex].staredUserId.firstIndex(where:  { $0==userid } )!
            self.userData.stores[self.storeIndex].staredUserId.remove(at: i)
        }else{
            self.userData.stores[self.storeIndex].staredUserId.insert(userid, at: 0)
            }
            
            let encoder = JSONEncoder()
            do  {
                // 将player对象encod（编码）
                let data: Data = try encoder.encode(self.userData.stores)
                let filename = getDocumentsDirectory().appendingPathComponent("store.json")
                try? data.write(to: filename)
            } catch {
                
            }
        }
    }
    
    func isUserStared() -> Bool {
        if(self.userData.userName==""){return false}
        let userid = self.userData.userInfos.filter { $0.name == self.userData.userName} [0].id
        return self.userData.stores[self.storeIndex].staredUserId.contains(userid)
    }
    
    var body: some View {
        VStack {
            
            
            BannerShow(pics: store.image,iindex: 0)
            .scaledToFill()
            .frame(height: 200)
            .clipped()
            .listRowInsets(EdgeInsets())
            
            VStack(alignment: .leading) {
                HStack {
                    Text(store.name)
                        .font(.title)
                        .foregroundColor(Color.blue)
                    
                    Button(action:self.toggleUserStaredStore
                        //self.userData.stores[self.storeIndex].isFavorite.toggle()
                        
                    ) {
                        if self.isUserStared() {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color.yellow)
                        } else {
                            Image(systemName: "star")
                                .foregroundColor(Color.gray)
                        }
                    }
                .alert(isPresented: self.$registerAlert) {
                    Alert(title: Text("请登录"), message: Text("先登录再收藏"),
                          primaryButton: .default(
                        Text("取消")
                        //action: saveWorkoutData
                    ),
                    secondaryButton: .destructive(
                        Text("去登录"),
                        action: { self.userData.selection=2 }))
                }
                    Spacer()
                    Text(store.category.rawValue)
                        .font(.system(size: 25))
                }.padding()
                
              /*  HStack(alignment: .top) {
                    Text(store.category.rawValue)
                        .font(.subheadline)
                    Spacer()
                    Text(store.category.rawValue)
                        .font(.subheadline)
                }.padding()*/
                
                /*MapView(coordinate: store.locationCoordinate)
                //.edgesIgnoringSafeArea(.top)
                .frame(height: 70)
                .padding()*/
                HStack{
                    Image(systemName: "text.bubble").font(.title)
                    Text("用户评价")
                    Spacer()
                    
                }  .padding(.leading,10).padding(.trailing,10)
                storeCommentShow(comments: self.storeComments)
                .scaledToFill()
                //.frame(height: 200)
                .clipped()
                .listRowInsets(EdgeInsets())
                .padding(.leading,10).padding(.trailing,10)
                
            }
            .padding()
            
            
            
            Spacer()
        }
    }
}
    
struct BannerShow: View {
    var pics: [Image]
    @State var iindex:Int
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        //return stores[iindex].image.resizable()
        HStack(spacing: 10){
            pics[iindex].resizable()
        }
        /// 对定时器的监听
        .onReceive(timer, perform: { _ in
            self.iindex += 1
            self.iindex=self.iindex%(self.pics.count)
        })
    }
}



