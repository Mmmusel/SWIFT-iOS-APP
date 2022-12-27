//
//  commentView.swift
//  finalApp
//
//  Created by musel on 2022/11/12.
//  Copyright © 2022 musel. All rights reserved.
//

import Foundation
import SwiftUI

struct CommentView: View {
    @EnvironmentObject var userData: UserData
    var comment: Comment
    @State var registerAlert=false
       
    
    //var findStore: Store {
    //   storeData.filter { $0.id == comment.store_id } [0]
    //}
    
    var tstoreIndex: Int {
        
        userData.stores.firstIndex(where: { $0.id == comment.store_id })!
        
    }
    
    var storeIndex: Int {
        userData.stores.firstIndex(where: { $0.id == comment.store_id })!
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
    
    var commentStore: Store {
        
        self.userData.stores[self.tstoreIndex]
    }
    
    var commentIndex: Int {
        userData.comments.firstIndex(where: { $0.id == comment.id })!
    }
    
    var body: some View {
        VStack {
        HStack{
            Image(systemName: "text.bubble").font(.title)
            Text("用户评价")
            Spacer()
            
        }  .padding(.leading,10).padding(.trailing,10)
            CommentBannerShow(pics: comment.commentImage,iindex: 0)
                .scaledToFill()
            
                .frame(height: 250)
                .clipped()
                .listRowInsets(EdgeInsets())
                .padding()
            
            Text(comment.context)
               .font(.subheadline)
                .padding(.leading,15)
                
            
            HStack(alignment: .top) {
                Text(self.userData.userInfos.filter { $0.id == comment.user_name} [0].name)
                    
                .font(.system(size: 27))
                Spacer()
                
                
                //Text(String(comment.rating))
                    //.font(.subheadline)
                StarView(num:comment.rating)
                
                
            }.padding(.leading,15).padding(.trailing,15)
            HStack{
                Image(systemName: "link.circle").font(.title)
                Text("店铺链接")
                Spacer()
                
            }  .padding(.leading,10).padding(.trailing,10)
            
            //HStack(alignment: .top) {
            NavigationLink(
                destination: StoreView(
                    store:commentStore
                )
            ) {
            //VStack(alignment: .leading) {
                HStack {
                    HStack(spacing: 10){
                        //picItem(store: commentStore,iindex: 0)
                        picItem(store: commentStore)
                            .padding(.top,10)
                        
                        
                    }.padding().frame(height:170)
                    
                    Text(commentStore.name)
                         .font(.system(size: 22))
                        .padding()
                    
                    Button(action: self.toggleUserStaredStore) {
                        if self.isUserStared() {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color.yellow)
                        } else {
                            Image(systemName: "star")
                                .foregroundColor(Color.gray)
                        }
                    //}
                    }.padding(.trailing,20)
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
                    
                }.background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 2)
                    .padding(.leading,10).padding(.trailing,10)
                    
                //}
            
        }
            //}}
            //.padding()
            
            
            
            //Spacer()
        }
    }
}

struct StarView: View {
    var num:Int
      var body: some View {
        HStack
            {
                
                Image(systemName: (num>=1) ? "star.fill" : "star")
                .foregroundColor(Color.yellow)
                Image(systemName: (num>=2) ? "star.fill" : "star")
                .foregroundColor(Color.yellow)
                Image(systemName: (num>=3) ? "star.fill" : "star")
                .foregroundColor(Color.yellow)
                Image(systemName: (num>=4) ? "star.fill" : "star")
                .foregroundColor(Color.yellow)
                Image(systemName: (num>=5) ? "star.fill" : "star")
                .foregroundColor(Color.yellow)
                
        }.padding(.trailing,15)
        
    }
    
}
struct CommentBannerShow: View {
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
