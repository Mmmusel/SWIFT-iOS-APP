//
//  EditProfileView.swift
//  finalApp
//
//  Created by musel on 2022/11/17.
//  Copyright © 2022 musel. All rights reserved.
//

import Foundation

import SwiftUI
import UIKit





struct userEditView : View {
    @EnvironmentObject var userData: UserData

    @State var nowUser: UserInfo
    @State var nameText:String
    @State var keyword:String
    @State var nameEmptyAlert=false
    @State var nameHasAlert=false
    
    @State var shareAlert=false
    
    @Environment(\.presentationMode) var mode
    
    func editChange(){
        
        
        nowUser.name = nameText
        nowUser.keyword = keyword
        
        let k = self.userData.userInfos.firstIndex { $0.id == nowUser.id }!
        self.userData.userInfos.remove(at: k)
        self.userData.userInfos.append(nowUser)
        
        self.userData.userName=nameText
        self.mode.wrappedValue.dismiss()
    }
    
    
    var body : some View {
        VStack{
        
       /* Button(
            action: {self.shareAlert=true},
            label: {
            VStack {
                Image(systemName: "tray.and.arrow.up")
                    .font(.system(size: 20))
                    .foregroundColor(Color.orange.opacity(0.85))
                    //.padding(10)
                Text("确定修改")
                    .foregroundColor(Color.orange.opacity(0.85))
                    .font(.system(size: 17))
            }
            .frame(width: 40, height: 40)})*/
            
            
            
            
            
            HStack{
                Text("请输入用户名：")
                TextField("\(nameText)", text:self.$nameText)
            }.padding(.leading,20).padding(.bottom,15)
            
            HStack{
                Text("请输入密码：")
                TextField("\(keyword)", text:self.$keyword)
            }.padding(.leading,20).padding(.bottom,15)
            
            Button(action:
                   {self.shareAlert=true},
                label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 60)
                    .frame(width: 140, height: 70)
                    .foregroundColor( Color.blue )
                    Text("确定修改")
                        .foregroundColor(Color.white)
                        .font(.system(size: 25))
                }
                .frame(width: 40, height: 40)})
            
            
            .alert(isPresented: self.$shareAlert) {
                if(self.nameText.isEmpty){
                    return Alert(
                    title: Text("用户名不能为空"),  dismissButton:
                    .default(Text("确定"))
                     
                    )
                }
                
                let tmp = self.userData.userInfos.filter { $0.name == self.nameText }
                var u = false
                if(tmp.count==2){
                    u=true
                } else if(tmp.count==1){
                    if(tmp[0].id != nowUser.id) { u = true }
                }
                if(u){
                    return Alert(
                    title: Text("用户名重复"),  dismissButton:
                    .default(Text("确定"))
                     
                    )
                }
                
                else{
                 return Alert(
                     title: Text("确认修改？"),
                     
                     primaryButton: .default(
                         Text("继续编辑")
                         //action: saveWorkoutData
                     ),
                     secondaryButton: .destructive(
                         Text("提交修改"),
                         action: editChange
                            
                            
                     
                    )
                    )}
            }
        }
        
    }
}

struct EditProfileView : View {
    @EnvironmentObject var userData: UserData

    var nowUser : UserInfo {
        self.userData.userInfos.filter { $0.name ==  self.userData.userName } [0]
    }
    
    var uiImages : UIImage {
        getUIImageFromCache(str: nowUser.profile)
    }
    
    var body: some View {
        userEditView(nowUser: nowUser, nameText: nowUser.name, keyword: nowUser.keyword)
    }
}

/*

func getUIImageFromCache(str:String) -> UIImage {
    let filename = getDocumentsDirectory().appendingPathComponent("\(str).jpg")
    
    let imgData = try! Data.init(contentsOf: filename)
    return UIImage(data: imgData)!
   
       //self.getImage.append(Image(uiImage: t))
}*/
