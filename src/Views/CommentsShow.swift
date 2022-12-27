//
//  CommentsShow.swift
//  finalApp
//
//  Created by musel on 2022/11/12.
//  Copyright © 2022 musel. All rights reserved.
//

func c2int(c:Comment)->Int {
    return 5
}

import Foundation
import SwiftUI
struct CommentShow: View {
    @EnvironmentObject var userData: UserData
    @State var refresh = false
    /*@State var sortComments: [Comment] {
        //if (userData.add)
        self.userData.comments.sorted { (t1, t2) -> Bool in
            return (c2int(c: t1) > c2int(c: t2)) ? true:false
    }*/
    
    @State var comments: [Comment]

    
    var body: some View {
        VStack{
            
            HStack{
             
            Spacer()
            Text("下拉刷新推荐")
                .foregroundColor(Color.gray.opacity(0.8))
            .font(.headline)
            
                .padding(.trailing, 15)}
            
        
        RefreshableScrollView(height: 70, refreshing: self.$refresh){
        HStack{
            List {
                ForEach(self.userData.comments) { comment in
                    NavigationLink(
                        destination: CommentView(comment: comment)
                            .onAppear{
                                let t = self.userData.stores.first(where: { $0.id == comment.store_id })!
                                let m = self.userData.clickDic[t.category]!
                                self.userData.clickDic[t.category] = m+1
                                print(self.userData.clickDic)
                        }
                    ) {
                        commentPicItem(commentStd: comment)
                            
                    } //.simultaneousGesture(TapGesture().onEnded{
                            
                    //})
                }.listRowInsets(EdgeInsets())
            }
        }.frame(height:410)}.frame(height:420)
        }
}

}
struct commentPicItem: View {
    @EnvironmentObject var userData: UserData
    @State var commentStd: Comment
   // var comment:Comment {
   //    self.userData.comments.filter {$0.id == commentStd.id} [0]
   // }
    var comment:Comment {
       let k =  self.userData.comments.filter {$0.id == commentStd.id}
        if(k.isEmpty) { return self.userData.comments[0] }
        else { return k[0] }
    }
    var body: some View {
        /*VStack(alignment: .leading) {
            comment.commentImage[0]
                //.renderingMode(.original)
                .resizable()
                .frame(height: 200)
                .cornerRadius(5)
            Text(comment.context)
                .foregroundColor(.primary)
                .font(.caption)
        }
        .padding(.leading, 15)*/
        VStack{
        if(commentStd.id==comment.id){
         VStack(alignment: .leading) {
         ScrollView(.horizontal, showsIndicators: false) {
                   HStack(alignment: .top, spacing: 0) {
                    ForEach(0..<comment.commentImageName.count, id: \.self) { index in
                           
                        self.comment.commentImage[index]
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 135, height: 135)
                            .cornerRadius(5)
                            .padding(.leading,15)
                            .padding(.top,10)
                           
                       }
                   }
               }
        //.frame(height: 160)
            Text(comment.context).font(.system(.body, design: .rounded))
        .foregroundColor(.primary)
        .font(.caption)
            .padding(10)
            .padding(.leading,15)
        }.background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 2)
        .padding(10)
        //.background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color.gray.opacity(0.1)))
        }
        else {
             Text("")
        }
        }
    }
}


struct storeCommentShow: View {
    
    @EnvironmentObject var userData: UserData
    @State var refresh = false
    
    @State var comments: [Comment]
    
    
    var body: some View {
        RefreshableScrollView(height: 70, refreshing: self.$refresh){
        HStack{
            List {
                ForEach(comments) { comment in
                    ZStack{
                        commentPicItem(commentStd: comment).zIndex(1.0)
                    NavigationLink(
                        destination: CommentView(comment: comment)
                            .onAppear{
                                let t = self.userData.stores.first(where: { $0.id == comment.store_id })!
                                let m = self.userData.clickDic[t.category]!
                                self.userData.clickDic[t.category] = m+1
                                print(self.userData.clickDic)
                        },label:{Text("")}
                        ).opacity(0)
                       
                            
                            
                        }
                }.listRowInsets(EdgeInsets())
                 
            }
        }.frame(height:430)}.frame(height:450)
    }
    

}
