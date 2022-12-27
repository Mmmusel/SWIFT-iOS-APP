//
//  ManagerNoticeView.swift
//  finalApp
//
//  Created by musel on 2022/11/19.
//  Copyright © 2022 musel. All rights reserved.
//

import Foundation
import SwiftUI
struct ManagerNoticeView: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.presentationMode) var presentationMode
    @State var y=9
    @State var deleteAlert=false
     @State var shareAlert=false
    @State  var text1 = ""
    @State  var showCameraPicker = false
    @State  var getImage = [Image]()
    @State  var getUIImage = [UIImage]()
    
    @State var rates = 0
    @State var isZero=true
    
    
    @State var chooseStore=false
    @State var commentStore=Store()
    @State var hasChoosen=false
    
    
    @State var showAlert = false
    @State var emptyText=false
    @State var emptyPic=false
    @State var emptyStore=false
    @State var registerAlert=false
    
    
    
    
    var tstoreIndex: Int {
        
        userData.stores.firstIndex(where: { $0.id == commentStore.id })!
        
    }
    
    var storeIndex: Int {
        userData.stores.firstIndex(where: { $0.id == commentStore.id })!
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
    
    func isUserStared() -> Bool {
        let userid = self.userData.userInfos.filter { $0.name == self.userData.userName} [0].id
        return self.userData.stores[self.storeIndex].staredUserId.contains(userid)
    }
    
    //var commentStore: Store {
      //  self.userData.stores[self.tstoreIndex]
   // }
    
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
        let i = userData.comments.count
    
        var k = [String]()
        for index in 0..<getUIImage.count {
            let picStr = "c00\(i+1)_\(index+1).jpg"
            loadImageInToCache(str:picStr, uploadImg:self.getUIImage[index])
            k.append("c00\(i+1)_\(index+1)")
        }
        let c = Comment(id:"c00\(i+1)",store_id: commentStore.id, user_name: self.userData.userName, rating: rates, context: self.text1, commentImageName: k)
        //self.userData.comments.append(c)
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
    
    func clear(){
        text1=""
        getImage = [Image]()
        getUIImage = [UIImage]()
        isZero=true
        rates=0
        hasChoosen=false
    }

    
    var userId:String {
        
        return self.userData.userInfos.filter { $0.name == self.userData.userName} [0].id
    }
    
    var body: some View {

    VStack(spacing: 10) {
        
        //////////////////
        HStack{Button(
            action: {self.deleteAlert=true},
                label: {VStack {
                    Image(systemName: "trash")
                        .font(.system(size: 20))
                        .foregroundColor(Color.gray.opacity(0.85))
                    Text("清空")
                        .foregroundColor(Color.gray.opacity(0.85))
                        .font(.system(size: 17))}
                .frame(width: 40, height: 40)})
            .alert(isPresented: self.$deleteAlert) {
                 Alert(
                     title: Text("是否清空？"),
                     
                     primaryButton: .default(
                         Text("取消")
                         //action: saveWorkoutData
                     ),
                     secondaryButton: .destructive(
                         Text("删除"),
                         action: clear
                     )
                 )
            }
            
            Spacer()
            Text("写评价")
                .foregroundColor(Color.black)
                .bold()
                .font(.system(size: 25))
            Spacer()
            
            Button(
                action: {self.shareAlert=true},
                label: {
                VStack {
                    Image(systemName: "tray.and.arrow.up")
                        .font(.system(size: 20))
                        .foregroundColor(Color.orange.opacity(0.85))
                        //.padding(10)
                    Text("发布")
                        .foregroundColor(Color.orange.opacity(0.85))
                        .font(.system(size: 17))
                }
                .frame(width: 40, height: 40)})
            
            .alert(isPresented: self.$shareAlert) {
                if(self.getImage.isEmpty){
                    return Alert(
                    title: Text("请选择照片"), message: Text("照片不能为空"), dismissButton:
                    .default(Text("确定"))
                     
                    )
                }
                else if(self.commentStore.name == ""){
                    return Alert(
                    title: Text("请选择店铺"), message: Text("店铺不能为空"), dismissButton:
                    .default(Text("确定"))
                     
                    )
                }
                else if(self.text1 == ""){
                    return Alert(
                    title: Text("请输入评价"), message: Text("评价不能为空"), dismissButton:
                    .default(Text("确定"))
                     
                    )
                }
                else{
                 return Alert(
                     title: Text("确定发布？"),
                     
                     primaryButton: .default(
                         Text("继续编辑")
                         //action: saveWorkoutData
                     ),
                     secondaryButton: .destructive(
                         Text("立即发布"),
                         action: {
                            
                            self.upload()
                            
                            
                     }
                            
                            
                     
                    )
                    )}
            }
            
           /* .alert(isPresented: self.$emptyText) {
                 Alert(
                    title: Text("请输入评价"), message: Text("评价不能为空"), dismissButton:
                    .default(Text("确定"))
                     
                    )
            }
            */
            
            
        }
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
                action: {
                    
                    
                    if(self.userData.userName == "")
                    { self.registerAlert=true }
                    
                    else { self.showCameraPicker = true } }, label: {
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
                    
                            .background(Color.white)
                             .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity,alignment: .topLeading)
                        .onTapGesture {
                                 self.showAlert=true
                        self.y=index
                        
                          }.alert(isPresented: self.$showAlert) {
                              Alert(
                                  title: Text("删除此照片？"),
                                  primaryButton: .default(Text("取消")),
                                  secondaryButton: .destructive(
                                      Text("删除"),
                                      action: {
                                        self.getImage.remove(at: self.y)
                                        self.getUIImage.remove(at: self.y)}
                                  ))})}}.padding(.top,5)}
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
             action: {
              self.chooseStore = true  }, label: {
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
                    Button(action: self.toggleUserStaredStore) {
                        if self.isUserStared() {
                        Image(systemName: "star.fill")
                            .foregroundColor(Color.yellow)
                    } else {
                        Image(systemName: "star").foregroundColor(Color.gray)}}}}
            .frame(height: 70)
                .sheet(isPresented: self.$chooseStore,content:{
                    ChooseView2(stores: self.userData.stores){ ss in
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
                
                
                if(self.userData.userName == "")
                { self.registerAlert=true }
                
                else {
                
                
                        if(self.rates != 1) {
                            self.isZero = false
                            self.rates = 1
                        } else {
                            self.isZero = true
                            self.rates = 0 }}},
                    label: { Image(systemName: "star.fill")
                        .font(.system(size: 20))
                        .foregroundColor((self.isZero) ? Color.gray.opacity(0.85) : Color.yellow.opacity(0.85)).padding(10)})
                
                
                Button(action: {
                    
                    if(self.userData.userName == "")
                    { self.registerAlert=true }
                    
                    else {
                        self.rates=2
                        self.isZero=false }},
                    label:{Image(systemName: "star.fill")
                    .font(.system(size: 20))
                        .foregroundColor((self.rates>=2) ? Color.yellow.opacity(0.85) : Color.gray.opacity(0.85)).padding(10)})
                
                Button(action: {
                    if(self.userData.userName == "")
                    { self.registerAlert=true }
                    
                    else {
                        self.rates=3
                        self.isZero=false }},
                    label:
                    {Image(systemName: "star.fill")
                    .font(.system(size: 20))
                        .foregroundColor((self.rates>=3) ? Color.yellow.opacity(0.85) : Color.gray.opacity(0.85)).padding(10)})
                
                Button(action: {
                    if(self.userData.userName == "")
                    { self.registerAlert=true }
                    
                    else {
                        self.rates=4
                        self.isZero=false }},
                    label:{Image(systemName: "star.fill")
                    .font(.system(size: 20)).foregroundColor((self.rates>=4) ? Color.yellow.opacity(0.85) : Color.gray.opacity(0.85)).padding(10)})
                
                Button(action: {
                    if(self.userData.userName == "")
                    { self.registerAlert=true }
                    
                    else {
                        self.rates=5
                        self.isZero=false }},
                    label:{Image(systemName: "star.fill")
                    .font(.system(size: 20)).foregroundColor((self.rates>=5) ? Color.yellow.opacity(0.85) : Color.gray.opacity(0.85)).padding(10)})
                
                Spacer()}}

        VStack{
            Divider()
                .foregroundColor(Color.gray.opacity(0.5))
                .padding(5)
            HStack{
                Image(systemName: "tray.and.arrow.up")
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
            .onTapGesture {
            if(self.userData.userName == "")
            { self.registerAlert=true }
            
            }
            .alert(isPresented: self.$registerAlert) {
                Alert(title: Text("请登录"), message: Text("先登录再评价"),
                      primaryButton: .default(
                    Text("取消")
                    //action: saveWorkoutData
                ),
                secondaryButton: .destructive(
                    Text("去登录"),
                    action: { self.userData.selection=2 }))
            }
        }
        
        

         Spacer()
    }.padding()
        
}}


struct ChooseView2: View {
    @Environment(\.presentationMode) var presentationMode
    @State var stores: [Store]
    let onStorePicked: (Store) -> Void
    
    @EnvironmentObject var userData: UserData
    
    
    var userId:String {
        
        return self.userData.userInfos.filter { $0.name == self.userData.userName} [0].id
    }
    
    var body: some View {
        VStack {
            //StoresList(stores: self.stores)
            //.frame(width: 640, height: 480)
            //.foregroundColor(.green)
            
            
            List {
                ForEach(self.stores.filter{ $0.manager==userId }) { store in
                    HStack {
                        store.image[0]
                            .resizable()
                            .frame(width: 50, height: 50)
                        .padding()
                        Text(store.name)
                        .padding()
                        Spacer()

                        
                    }
                    
                    .padding()
                    .onTapGesture(count: 1, perform: {
                        self.onStorePicked(store)
                            
                        self.presentationMode.wrappedValue.dismiss()
                    })
                            
                    
                }
                
            }
                
            Spacer()
        }.edgesIgnoringSafeArea(.all)
    }
}
