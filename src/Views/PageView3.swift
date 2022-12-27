//
//  PageView3.swift
//  finalApp
//
//  Created by musel on 2022/11/13.
//  Copyright © 2022 musel. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit





struct PageView3: View {
    @EnvironmentObject var userData: UserData
    @State var text: String = ""
    @State var selectedIndex = 1
    //@State var isActive: Bool = false
    //@State var stateName:String
    @State var exitAlert=false
    @State var plate:String=""
    @State var isActive=false
    
    
    @State var nameText=""
    @State var keyword=""
    @State var type="user"
    @State var nameHasnotAlert=false
    @State var keywordErrorAlert=false
    @State var nameEmptyAlert=false
    @State var nameHasAlert=false
    
    
    func fresh(){
        
        let encoder = JSONEncoder()
        do  {
            // 将player对象encod（编码）
            let data: Data = try encoder.encode(self.userData.userInfos)
            let filename = getDocumentsDirectory().appendingPathComponent("userInfo.json")
            try? data.write(to: filename)
        } catch {
            
        }
        
        do  {
            // 将player对象encod（编码）
            let data: Data = try encoder.encode(self.userData.comments)
            let filename = getDocumentsDirectory().appendingPathComponent("comment.json")
            try? data.write(to: filename)
        } catch {
            
        }
        do  {
            // 将player对象encod（编码）
            let data: Data = try encoder.encode(self.userData.stores)
            let filename = getDocumentsDirectory().appendingPathComponent("store.json")
            try? data.write(to: filename)
        } catch {
            
        }
        
    }
    
    
    
    
    
    func registerUser(){
        self.userData.userName=""
        self.plate=""
        if(self.nameText == ""){
            self.nameEmptyAlert = true
            return
        }
        let userHas = userData.userInfos.filter { $0.name == self.nameText }
        if userHas.isEmpty {
            self.userData.userInfos.append(UserInfo(id: "user00\(self.userData.userInfos.count+1)", name: self.nameText, keyword: self.keyword, profile: "c003_1", type: self.type))
            self.userData.userName=self.nameText
            self.plate=self.nameText
            self.nameText=""
            self.keyword=""
            
            if(self.type=="manager"){
                self.userData.isManager = true
            }else{
                self.userData.isManager = false
            }
            let encoder = JSONEncoder()
            do  {
                // 将player对象encod（编码）
                let data: Data = try encoder.encode(self.userData.userInfos)
                let filename = getDocumentsDirectory().appendingPathComponent("userInfo.json")
                try? data.write(to: filename)
            } catch {
                
            }
            
            
        }
        else {
            self.nameHasAlert = true
        }
        
        
    }
    
    func loginUser(){
        self.userData.userName=""
        let userHas = userData.userInfos.filter { $0.name == self.nameText }
        if userHas.isEmpty {
            self.nameHasnotAlert = true
           
            
        }
        else if(userHas[0].keyword != self.keyword){
            self.keywordErrorAlert = true
            
        }else {
        self.userData.userName=self.nameText
            self.plate=self.nameText
            self.nameText=""
            self.keyword=""
            
            if userHas[0].type=="manager" {
                self.userData.isManager = true
            }else{
                self.userData.isManager = false
            }
        
        }
        
        
        
    }
  
    var body: some View {
        //ActivityGraph(logs: ActivityTestData.testData, selectedIndex: $selectedIndex)
        //NavigationView {
        VStack{
            
            if(plate != "") {
                
                NavigationView {
               
                               
                               VStack{
                NavigationLink(destination: StoreList(),isActive: self.$isActive) {
                    Text("")
                }.frame(height:0)
                                VStack{Text("")}
                                    .frame(height:60)
                        NavigationLink(destination: StoreList(),isActive: self.$isActive) {
                            Text("")
                        }.frame(height:0)
                               
                        HStack{
                       
                        
                        Spacer()
                        Text("个人页面")
                            .foregroundColor(Color.black)
                            .bold()
                            .font(.system(size: 25))
                        Spacer()
                        
                        
                        
                        
                        
                                }
                                
                        
                        
                                HStack{
                                Button(
                                action: {self.exitAlert=true
                                   
                                },
                                    label: {VStack {
                                        Image(systemName: "arrowshape.turn.up.left.circle")
                                            .font(.system(size: 27))
                                            .foregroundColor(Color.gray.opacity(0.85))
                                        Text("退出")
                                            .foregroundColor(Color.gray.opacity(0.85))
                                            .font(.system(size: 20))}
                                    .frame(width: 60, height: 60)})
                                .alert(isPresented: self.$exitAlert) {
                                     Alert(
                                         title: Text("确定退出？"),
                                         
                                         primaryButton: .default(
                                             Text("取消")
                                         ),
                                         secondaryButton: .destructive(
                                             Text("确定"),
                                             action: { //self.userData.userName=""
                                                self.plate=""
                                         }
                                         )
                                     )
                                    }.zIndex(3.0)
                                
                                Spacer()
                                Text("hello! \(self.userData.userName)")
                                    .foregroundColor(Color.black)
                                    .bold()
                                    .font(.system(size: 25))
                                Spacer()
                                
                                
                                
                                NavigationLink(
                                    destination: EditProfileView()
                                     
                                ) {VStack{
                                        Image(systemName: "person.crop.circle")
                                        .font(.system(size: 27))
                                        .foregroundColor(Color.orange.opacity(0.85))
                                        Text("修改")
                                        .foregroundColor(Color.orange.opacity(0.85))
                                        .font(.system(size: 20))
                                }
                                        .frame(width: 60, height: 60)}
                                
                                        }
                                
                                Divider().foregroundColor(Color.gray.opacity(0.5)).padding(.trailing,5).padding(.leading,5)
                        if(self.userData.isManager){
                            ManagerStoreList()
                        }else {
                        Text("收藏的店铺").foregroundColor(Color.blue)
                            .frame(height:30,alignment: .topLeading)
                         if(plate != "") {
                        myStars()
                            }}
                                
                                Divider().foregroundColor(Color.gray.opacity(0.5)).padding(.trailing,5).padding(.leading,5)
                                Text((self.userData.isManager) ? "发布的通知" : "发布的评论").frame(height:30,alignment: .topLeading).foregroundColor(Color.blue)
                         if(plate != "") {
                        myComments()
                        .listRowInsets(EdgeInsets())
                            
                        }
                        
                               }.navigationBarHidden(true)
                    .edgesIgnoringSafeArea(.top)
                    }.navigationBarHidden(true)
                    
            }else {
                
                VStack{
                
                HStack{
                    Button(
                                           action: {self.type="user"},
                                       label: {
                                       ZStack {
                                           
                                               Circle()
                                               .frame(width: 120, height: 120)
                                                   .foregroundColor((self.type=="user") ? Color.blue : Color.gray.opacity(0.25))
                                           VStack{
                                           Image(systemName: "person.fill")
                                               .font(.system(size: 30))
                                               .foregroundColor(Color.white)
                                               //.padding(10)
                                           Text("我是用户")
                                               .foregroundColor(Color.white)
                                               .font(.system(size: 20))
                                       }
                                           }.frame(width: 60, height: 60)})
                    
                    Spacer()
                    
                    //Button(
                     //   action: {self.fresh()},
                      //  label: {Text("refresh")})
                   
                    Button(
                        action: {self.type="manager"},
                    label: {
                    ZStack {
                        Circle()
                        .frame(width: 120, height: 120)
                        .foregroundColor((self.type=="manager") ? Color.blue : Color.gray.opacity(0.25))
                        VStack{
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 30))
                            .foregroundColor(Color.white)
                            //.padding(10)
                        Text("我是商家")
                            .foregroundColor(Color.white)
                            .font(.system(size: 20))}
                    }
                    .frame(width: 60, height: 60)})
                    
   
                }.padding(.leading,100).padding(.trailing,100).padding(.bottom,60)
                
                HStack{
                    Text("请输入用户名：")
                    TextField("用户名", text:self.$nameText)
                }.padding(.leading,20).padding(.bottom,8)
                .alert(isPresented: self.$nameHasnotAlert) {
                    Alert(
                    title: Text("用户名不存在"),  dismissButton:
                    .default(Text("确定"))
                    )
                }
                
                HStack{
                    Text("请输入密码：")
                    TextField("密码", text:self.$keyword)
                }.padding(.leading,20)
                .alert(isPresented: self.$keywordErrorAlert) {
                    Alert(
                    title: Text("密码不正确"),  dismissButton:
                    .default(Text("确定"))
                     
                    )
                }.padding(.bottom,30)
                
                HStack{
                    Button(
                        action: self.loginUser,
                    label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 60)
                        .frame(width: 140, height: 70)
                        .foregroundColor( Color.blue )
                        Text("登录")
                            .foregroundColor(Color.white)
                            .font(.system(size: 25))
                    }
                    .frame(width: 40, height: 40)})
                    .alert(isPresented: self.$nameEmptyAlert) {
                        Alert(
                        title: Text("用户名不能为空"),  dismissButton:
                        .default(Text("确定"))
                         
                        )
                    }

                    Spacer()
                    Button(
                        action: self.registerUser,
                    label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 60)
                                              .frame(width: 140, height: 70)
                                              .foregroundColor( Color.blue )
                        Text("注册")
                            .foregroundColor(Color.white)
                            .font(.system(size:25))
                    }
                    .frame(width: 40, height: 40)}).alert(isPresented: self.$nameHasAlert) {
                        Alert(
                        title: Text("用户名重复"),dismissButton:
                        .default(Text("确定"))
                         
                        )
                    }
                }.padding(.leading,100).padding(.trailing,100)
                        }
            }
        
        }

    }
    }

struct RegisterView: View {
    @EnvironmentObject var userData: UserData
    @State var nameText=""
    @State var keyword=""
    @State var type="user"
    @State var nameHasnotAlert=false
    @State var keywordErrorAlert=false
    @State var nameEmptyAlert=false
    @State var nameHasAlert=false
    
    
    
    
    
    func registerUser(){
        self.userData.userName=""
        if(self.nameText == ""){
            self.nameEmptyAlert = true
            return
        }
        let userHas = userData.userInfos.filter { $0.name == self.nameText }
        if userHas.isEmpty {
            self.userData.userInfos.append(UserInfo(id: "user00\(self.userData.userInfos.count+5)", name: self.nameText, keyword: self.keyword, profile: "c003_1", type: self.type))
            self.userData.userName=self.nameText
            //self.plate=self.nameText
            
        }
        else {
            self.nameHasAlert = true
        }
        
        
    }
    
    func loginUser(){
        self.userData.userName=""
        let userHas = userData.userInfos.filter { $0.name == self.nameText }
        if userHas.isEmpty {
            self.nameHasnotAlert = true
           
            
        }
        else if(userHas[0].keyword != self.keyword){
            self.keywordErrorAlert = true
            
        }else {
        self.userData.userName=self.nameText
            //self.plate=self.nameText
        }
        
        
        
    }


    var body: some View {
        
        VStack{
            
            
            
            HStack{
                Button(
                    action: {self.type="user"},
                label: {
                ZStack {
                    
                        Circle()
                        .frame(width: 100, height: 100)
                            .foregroundColor((self.type=="user") ? Color.blue : Color.gray.opacity(0.25))
                    VStack{
                    Image(systemName: "tray.and.arrow.up")
                        .font(.system(size: 20))
                        .foregroundColor(Color.white)
                        //.padding(10)
                    Text("我是用户")
                        .foregroundColor(Color.white)
                        .font(.system(size: 17))
                }
                    }.frame(width: 40, height: 40)}).padding(80)
                
                Spacer()
                
                Button(
                    action: {self.type="manager"},
                label: {
                ZStack {
                    Circle()
                    .frame(width: 100, height: 100)
                    .foregroundColor((self.type=="manager") ? Color.blue : Color.gray.opacity(0.25))
                    VStack{
                    Image(systemName: "tray.and.arrow.up")
                        .font(.system(size: 20))
                        .foregroundColor(Color.white)
                        //.padding(10)
                    Text("我是商家")
                        .foregroundColor(Color.white)
                        .font(.system(size: 17))}
                }
                .frame(width: 40, height: 40)}).padding(80)
            }
            
            HStack{
                Text("请输入用户名：")
                TextField("用户名", text:self.$nameText)
            }.alert(isPresented: self.$nameHasnotAlert) {
                Alert(
                title: Text("用户名不存在"),  dismissButton:
                .default(Text("确定"))
                 
                )
            }
            
            HStack{
                Text("请输入密码：")
                TextField("密码", text:self.$keyword)
            }.alert(isPresented: self.$keywordErrorAlert) {
                Alert(
                title: Text("密码不正确"),  dismissButton:
                .default(Text("确定"))
                 
                )
            }
            
            HStack{
                Button(
                    action: self.loginUser,
                label: {
                VStack {
                    Image(systemName: "tray.and.arrow.up")
                        .font(.system(size: 20))
                        .foregroundColor(Color.orange.opacity(0.85))
                        //.padding(10)
                    Text("登录")
                        .foregroundColor(Color.orange.opacity(0.85))
                        .font(.system(size: 17))
                }
                .frame(width: 40, height: 40)})
                .alert(isPresented: self.$nameEmptyAlert) {
                    Alert(
                    title: Text("用户名不能为空"),  dismissButton:
                    .default(Text("确定"))
                     
                    )
                }

                
                
                
                Button(
                    action: self.registerUser,
                label: {
                VStack {
                    Image(systemName: "tray.and.arrow.up")
                        .font(.system(size: 20))
                        .foregroundColor(Color.orange.opacity(0.85))
                        //.padding(10)
                    Text("注册")
                        .foregroundColor(Color.orange.opacity(0.85))
                        .font(.system(size: 17))
                }
                .frame(width: 40, height: 40)}).alert(isPresented: self.$nameHasAlert) {
                    Alert(
                    title: Text("用户名重复"),dismissButton:
                    .default(Text("确定"))
                     
                    )
                }
            }
                    }
    }
        
}


struct myStars: View {
    @EnvironmentObject var userData: UserData
    
    var userId:String {
        //print("dddd\(self.userData.userName)")
        return self.userData.userInfos.filter { $0.name == self.userData.userName} [0].id
    }

    var body: some View {
        AdvertisedStores(stores: userData.stores.filter {$0.staredUserId.contains(userId)} )

        
    }
}

struct myComments: View {
    @EnvironmentObject var userData: UserData

    var body: some View {

        HStack{
        List {
            
            ForEach(self.userData.comments.filter { $0.user_name ==
                self.userData.userInfos.filter { $0.name == self.userData.userName} [0].id },id:\.self ) { comment in
                    NavigationLink(
                        destination:
                        
                        EditCommentView(comment: comment)
                        
                    ) {
                        commentPicItem(commentStd: comment)
                        
                            
                }
            
        }.listRowInsets(EdgeInsets())
            
        }
    }
    }
}



struct LikedStoreList: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
NavigationView {
        
        ScrollView(.horizontal, showsIndicators: false) {
            
            
            ForEach(userData.stores) { store in
                NavigationLink(
                    destination: StoreView(
                        store: store
                    )
                ) {
                HStack {
                    store.image[0]
                        .resizable()
                        .frame(width: 50, height: 50)
                    .padding()
                    Text(store.name)
                    .padding()
                    Spacer()

                    
                }.padding()
                        
               // }
                }}
            
        }.frame(height:80)
    .padding(10)
            
        }
       
    }
}


 struct editProfileBar : View {
     @EnvironmentObject var userData: UserData
     @State var exitAlert=false
    @State var plate:String=""
     
     var body: some View {
         HStack{
         Button(
         action: {self.exitAlert=true
            
         },
             label: {VStack {
                 Image(systemName: "trash")
                     .font(.system(size: 20))
                     .foregroundColor(Color.gray.opacity(0.85))
                 Text("退出")
                     .foregroundColor(Color.gray.opacity(0.85))
                     .font(.system(size: 17))}
             .frame(width: 60, height: 60)})
         .alert(isPresented: self.$exitAlert) {
              Alert(
                  title: Text("确定退出？"),
                  
                  primaryButton: .default(
                      Text("取消")
                  ),
                  secondaryButton: .destructive(
                      Text("确定"),
                      action: { self.userData.userName=""
                        self.userData.isManager=false
                  }
                  )
              )
         }
         
         Spacer()
         Text("个人页面")
             .foregroundColor(Color.black)
             .bold()
             .font(.system(size: 25))
         Spacer()
         
         
         
         NavigationLink(
                 destination:
                 
             EditProfileView()
                 
             ) {
                VStack{
                    Image(systemName: "tray.and.arrow.up")
                    .font(.system(size: 20))
                    .foregroundColor(Color.orange.opacity(0.85))
                    
                    Text("修改")
                    .foregroundColor(Color.orange.opacity(0.85))
                    .font(.system(size: 17))
                    
                }
                 
                 
                 
                 .frame(width: 60, height: 60)}}
     }
 }

