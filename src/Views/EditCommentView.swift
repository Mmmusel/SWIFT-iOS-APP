//
//  EditCommentView.swift
//  finalApp
//
//  Created by musel on 2022/11/15.
//  Copyright © 2022 musel. All rights reserved.
//

import Foundation

import SwiftUI
import UIKit


func getUIImageFromCache(str:String) -> UIImage {
    let filename = getDocumentsDirectory().appendingPathComponent("\(str).jpg")
    
    let imgData = try! Data.init(contentsOf: filename)
    return UIImage(data: imgData)!
   
       //self.getImage.append(Image(uiImage: t))
}

struct EditCommentView : View {
    @EnvironmentObject var userData: UserData
    
    
    var comment : Comment
    
    var uiImages : [UIImage] {
        
        comment.commentImageName.map { getUIImageFromCache(str: $0) }
            
        
    }
    
    var body: some View {
        commentDoneView(comment: comment, text1: comment.context, getImage: comment.commentImage, getUIImage:uiImages, rates: comment.rating, isZero: (comment.rating == 0), commentStore: self.userData.stores[userData.stores.firstIndex(where: { $0.id == comment.store_id })!])
    }
    
    }


struct commentDoneView : View {
    @EnvironmentObject var userData: UserData
    @State var showAlert = false
    @State var comment : Comment
    @State  var showCameraPicker = false
    @State var chooseStore=false
    @State var hasChoosen=true
        
    @State  var text1 : String
        
    @State  var getImage : [Image]
    @State  var getUIImage : [UIImage]
        
    @State var rates : Int
    @State var isZero : Bool
    
    @State var commentStore : Store
    @State var y = 9
        
        
    var tstoreIndex: Int {
        userData.stores.firstIndex(where: { $0.id == comment.store_id })!
    }
    var storeIndex: Int {
        userData.stores.firstIndex(where: { $0.id == comment.store_id })!
    }
    
    func toggleUserStaredStore(){
        
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
    
    var userId:String {
        //print("dddd\(self.userData.userName)")
        return self.userData.userInfos.filter { $0.name == self.userData.userName} [0].id
    }
    
    func isUserStared() -> Bool {
        let userid = self.userData.userInfos.filter { $0.name == self.userData.userName} [0].id
        return self.userData.stores[self.storeIndex].staredUserId.contains(userid)
    }

        
        func getImageFromCache(){
             let filename = getDocumentsDirectory().appendingPathComponent("my1.jpg")
             
             let imgData = try! Data.init(contentsOf: filename)
             let t = UIImage(data: imgData)!
                self.getImage.append(Image(uiImage: t))
         }
        
        func loadImageInToCache(str:String, uploadImg:UIImage){
            let filename = getDocumentsDirectory().appendingPathComponent(str)
            if let data = uploadImg.jpegData(compressionQuality: 0.8) {
                try? data.write(to: filename)
            }
        }
        
        func upload(){
            //1
            let i = userData.comments.firstIndex(where: { $0.id == comment.id })!
            
            self.userData.comments.remove(at: i)
            let cid = comment.id
        
            var k = [String]()
            for index in 0..<getUIImage.count {
                let picStr = "\(cid)_\(index+1).jpg"
                loadImageInToCache(str:picStr, uploadImg:self.getUIImage[index])
                k.append("\(cid)_\(index+1)")
            }
            //2
            let c = Comment(id:"\(cid)",store_id: commentStore.id, user_name: self.userId, rating: rates, context: self.text1, commentImageName: k)
            
            self.userData.comments.insert(c, at: 0)
            
            //let datat: Data = try encoder.encode(self.userData.stores)
            let encoder = JSONEncoder()
            do  {
                // 将player对象encod（编码）
                let data: Data = try encoder.encode(self.userData.comments)
                let filename = getDocumentsDirectory().appendingPathComponent("comment.json")
                try? data.write(to: filename)
            } catch {
                
            }
            
            
            clear()
        }
    
    func deletefromcomment(){
        //remove
        let i = userData.comments.firstIndex(where: { $0.id == comment.id })!
        self.userData.comments.remove(at: i)
        //let datat: Data = try encoder.encode(self.userData.stores)
        let encoder = JSONEncoder()
        do  {
            // 将player对象encod（编码）
            let data: Data = try encoder.encode(self.userData.comments)
            let filename = getDocumentsDirectory().appendingPathComponent("comment.json")
            try? data.write(to: filename)
        } catch {
            
        }
        clear()
        
    }
        
        func clear(){
            
            
            text1=""
            getImage = [Image]()
            getUIImage = [UIImage]()
            isZero=true
            rates=0
            hasChoosen=false
        }

        var body: some View {

        VStack(spacing: 10) {
            
            //////////////////
            HStack{Button(
                    action: deletefromcomment,
                    label: {VStack {
                        Image(systemName: "trash")
                            .font(.system(size: 20))
                            .foregroundColor(Color.gray.opacity(0.85))
                        Text("删除")
                            .foregroundColor(Color.gray.opacity(0.85))
                            .font(.system(size: 17))}
                    .frame(width: 40, height: 40)})
                
                Spacer()
              
                    Text((self.userData.isManager) ? "修改通知" : "修改评价")
                    .foregroundColor(Color.black)
                    .bold()
                    .font(.system(size: 25))
                Spacer()
                
                Button(
                    action: upload,
                    label: {
                    VStack {
                        Image(systemName: "tray.and.arrow.up")
                            .font(.system(size: 20))
                            .foregroundColor(Color.orange.opacity(0.85))
                            //.padding(10)
                        Text("修改")
                            .foregroundColor(Color.orange.opacity(0.85))
                            .font(.system(size: 17))
                    }
                    .frame(width: 40, height: 40)})}
            ///////

            VStack{
                Divider().foregroundColor(Color.gray.opacity(0.5)).padding(5)
                HStack{
                    Image(systemName: "camera")
                        .font(.system(size: 25))
                        .foregroundColor(Color.gray.opacity(0.85))
                        .padding(10)
                    Text("图片")
                        .foregroundColor(Color.gray.opacity(0.85))
                        .font(.system(size: 20))
                    Spacer()}
                
                HStack{
                Button(
                    action: { self.showCameraPicker = true }, label: {
                        VStack {
                            Image(systemName: "photo.fill.on.rectangle.fill")
                                .font(.system(size: 35))
                                .foregroundColor(Color.gray.opacity(0.85)).padding(10)
                            Text("点击上传图片")
                                .foregroundColor(Color.gray.opacity(0.85))
                                .font(.system(size: 17))}
                                .frame(width: 130, height: 130)
                                .background(Color.gray.opacity(0.2))
                                .overlay(RoundedRectangle(cornerRadius:10).stroke(Color.gray, style: StrokeStyle(lineWidth: 1, dash: [10])))})
                 ScrollView(.horizontal, showsIndicators: true) {
                 HStack(alignment: .top, spacing: 0) {
                     ForEach(0..<getImage.count,id:\.self) { index in
                     
                     self.getImage[index]
                         .renderingMode(.original)
                         .resizable()
                         .frame(width: 130, height: 130)
                         .cornerRadius(5)
                         .padding(5)
                         
                    .overlay(
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.red)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity,alignment: .topLeading)
                            
                        .onTapGesture {
                                 self.showAlert=true
                        self.y=index
                        
                          }.alert(isPresented: self.$showAlert) {
                              Alert(
                                  title: Text("删除此照片？"),
                                  
                                  primaryButton: .default(
                                      Text("取消")
                                      //action: saveWorkoutData
                                  ),
                                  secondaryButton: .destructive(
                                      Text("删除"),
                                      action: {
                                        self.getImage.remove(at: self.y)
                                        self.getUIImage.remove(at: self.y)}
                                  ))}
                    )
                     
                          
                         
                         
                    }}.padding(.top,5)}
                 .frame(height: 145)
                 .sheet(isPresented: self.$showCameraPicker,content:
                             { ImagePicker(sourceType: .photoLibrary) { image in
                                 self.getUIImage.append(image)
                                 self.getImage.append(Image(uiImage: image))}})}}
            
             
             
             VStack{
             Divider().foregroundColor(Color.gray.opacity(0.5)).padding(5)
             HStack{
                 Image(systemName: "doc.text.magnifyingglass")
                     .font(.system(size: 25))
                     .foregroundColor(Color.gray.opacity(0.85))
                     .padding(10)
                 Text("店铺")
                     .foregroundColor(Color.gray.opacity(0.85))
                     .font(.system(size: 20))
                 Spacer()}
             
             HStack{
                Button(
                 action: { self.chooseStore = true }, label: {
                     VStack {Image(systemName: "plus.square")
                                 .font(.system(size: 25))
                                 .foregroundColor(Color.gray.opacity(0.85)).padding(10)
                             Text("点击选择店铺")
                                 .foregroundColor(Color.gray.opacity(0.85))
                                 .font(.system(size: 17))}
                         .frame(width: 70, height: 70)
                         .background(Color.gray.opacity(0.2))
                         .overlay(RoundedRectangle(cornerRadius:10).stroke(Color.gray, style: StrokeStyle(lineWidth: 1, dash: [10])))})
                HStack {
                    if(self.hasChoosen){
                    //HStack(spacing: 10){
                        //picItem(store: commentStore).frame(height:40)
                        commentStore.image[0]
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 70, height: 70)
                        .cornerRadius(5)
                    //}.padding()
                    
                    Text(commentStore.name).font(.system(size: 25)).padding()
                        Button(action: self.toggleUserStaredStore ) {
                        if self.isUserStared() {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color.yellow)
                        } else {
                            Image(systemName: "star").foregroundColor(Color.gray)}}}}
                .frame(height: 70)
                    .sheet(isPresented: self.$chooseStore,content:{
                        ChooseView(stores: self.userData.stores){ ss in
                            self.commentStore=ss
                            self.hasChoosen=true}})
                Spacer()}}
            
            VStack{
                Divider().foregroundColor(Color.gray.opacity(0.5)).padding(5)
                HStack{
                    Image(systemName: "star")
                    .font(.system(size: 25))
                    .foregroundColor(Color.gray.opacity(0.85))
                    .padding(10)
                    Text("打分")
                    .foregroundColor(Color.gray.opacity(0.85))
                    .font(.system(size: 20))
                Spacer() }
                
                HStack{ Button(action: {
                            if(self.rates != 1) {
                                self.isZero = false
                                self.rates = 1
                            } else {
                                self.isZero = true
                                self.rates = 0 }},
                        label: { Image(systemName: "star.fill")
                            .font(.system(size: 20))
                            .foregroundColor((self.isZero) ? Color.gray.opacity(0.85) : Color.yellow.opacity(0.85)).padding(10)})
                    Button(action: {
                            self.rates=2
                            self.isZero=false },
                        label:{Image(systemName: "star.fill")
                        .font(.system(size: 20))
                            .foregroundColor((self.rates>=2) ? Color.yellow.opacity(0.85) : Color.gray.opacity(0.85)).padding(10)})
                    Button(action: {
                            self.rates=3
                            self.isZero=false},
                        label:
                        {Image(systemName: "star.fill")
                        .font(.system(size: 20))
                            .foregroundColor((self.rates>=3) ? Color.yellow.opacity(0.85) : Color.gray.opacity(0.85)).padding(10)})
                    Button(action: {
                            self.rates=4
                            self.isZero=false},
                        label:{Image(systemName: "star.fill")
                        .font(.system(size: 20)).foregroundColor((self.rates>=4) ? Color.yellow.opacity(0.85) : Color.gray.opacity(0.85)).padding(10)})
                    Button(action: {
                            self.rates=5
                            self.isZero=false},
                        label:{Image(systemName: "star.fill")
                        .font(.system(size: 20)).foregroundColor((self.rates>=5) ? Color.yellow.opacity(0.85) : Color.gray.opacity(0.85)).padding(10)})
                    Spacer()}}

            VStack{
                Divider()
                    .foregroundColor(Color.gray.opacity(0.5))
                    .padding(5)
                HStack{
                    Image(systemName: "square.and.pencil")
                    .font(.system(size: 25))
                    .foregroundColor(Color.gray.opacity(0.85))
                    .padding(10)
                    Text("评价")
                    .foregroundColor(Color.gray.opacity(0.85))
                    .font(.system(size: 20))
                Spacer()}
            
                TextField("😄写点吃喝玩乐的分享吧～", text: self.$text1)
                    .font(.system(size: 22.5)) //设置字体
                           .padding(10)  //设置间距
                           .textFieldStyle(PlainTextFieldStyle()) //去掉边框
                           .frame(width: 380, height: 110, alignment: .topLeading) //设置尺寸
                           .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color.gray.opacity(0.15))) //填充圆角背景
                           //.overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(Color(red: 220 / 255, green: 220 / 255, blue: 220 / 255), lineWidth: 1)) //填充圆角边框
            }
            
            

             Spacer()
            }.padding()
    }
}
