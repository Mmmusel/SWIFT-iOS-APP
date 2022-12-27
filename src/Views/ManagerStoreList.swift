//
//  ManagerStoreList.swift
//  finalApp
//
//  Created by musel on 2022/11/18.
//  Copyright © 2022 musel. All rights reserved.
//

import Foundation

import SwiftUI

struct ManagerStoreList: View {
    @EnvironmentObject var userData: UserData
    
    @State var addStore=false
    
    @State  var text1 = ""
    @State  var getImage = [Image]()
    @State  var getUIImage = [UIImage]()
    
    var userId:String {
        //print("dddd\(self.userData.userName)")
        return self.userData.userInfos.filter { $0.name == self.userData.userName} [0].id
    }
    
    func loadImageInToCache(str:String, uploadImg:UIImage){
        let filename = getDocumentsDirectory().appendingPathComponent(str)
        if let data = uploadImg.jpegData(compressionQuality: 0.8) {
            try? data.write(to: filename)
        }
    }
    
    func upload(){
        let i = self.userData.stores.count
    
        var k = [String]()
        for index in 0..<getUIImage.count {
            let picStr = "s00\(i+1)_\(index+1).jpg"
            loadImageInToCache(str:picStr, uploadImg:self.getUIImage[index])
            k.append("s00\(i+1)_\(index+1)")
        }
        let s = Store(id:"s00\(i+1)",name: self.text1, imageName: k,manager:self.userId)
        //self.userData.comments.append(c)
        self.userData.stores.insert(s, at: 0)
        
        //let datat: Data = try encoder.encode(self.userData.stores)
        let encoder = JSONEncoder()
        do  {
            // 将player对象encod（编码）
            let data: Data = try encoder.encode(self.userData.stores)
            let filename = getDocumentsDirectory().appendingPathComponent("store.json")
            try? data.write(to: filename)
        } catch {
            
        }}
    
    var body: some View {
        VStack{
            
           /* Button(
            action: {self.addStore=true},
            label: {
            HStack {
                Image(systemName: "tray.and.arrow.up")
                    .font(.system(size: 20))
                    .foregroundColor(Color.orange.opacity(0.85))
                    //.padding(10)
                Text("开新店")
                    .foregroundColor(Color.orange.opacity(0.85))
                    .font(.system(size: 17))
            }
            .frame(width: 120, height: 50)})*/
                
                Button(
                    action: {self.addStore=true},
                label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 60)
                    .frame(width: 120, height: 60)
                    .foregroundColor( Color.blue )
                    Text("开新店")
                        .foregroundColor(Color.white)
                        .font(.system(size: 25))
                }
                .frame(width: 40, height: 40)})
                
            
            .sheet(isPresented: self.$addStore,content:{
                AddStoreView(){ t,im,uiim in
                    
                    self.text1=t
                    
                    self.getUIImage = uiim
                    
                    self.getImage=im
                    self.upload()
                    
                }
                
            })
            
            
        List {
            ForEach(userData.stores.filter { $0.manager == userId }) { store in
                 NavigationLink(
                     destination: StoreEditView(
                         store: store
                     )
                 ) {
                 HStack {
                     store.image[0]
                         .resizable()
                         .frame(width: 60, height: 60)
                     .padding(8)
                     Text(store.name)
                        .font(.system(size: 22))
                        .padding(.leading,10)
                     Spacer()
                     
                 }.padding(8)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 2)
                 }}
            }}
        }
}


struct StoreEditView : View {
    @EnvironmentObject var userData: UserData
    @State var store:Store
    @State var payAlert=false
    @State var number=0
    
    @State var addNotice=false
    @State var editAlert=false
    
    @State  var text1 = ""
    @State  var showCameraPicker = false
    
    
    var storeIndex: Int {
        userData.stores.firstIndex(where: { $0.id == store.id })!
    }
    
    func payCost(){
    self.userData.stores[self.storeIndex].sumCost = self.number+self.userData.stores[self.storeIndex].sumCost
        let encoder = JSONEncoder()
        
        do  {
            // 将player对象encod（编码）
            let data: Data = try encoder.encode(self.userData.stores)
            let filename = getDocumentsDirectory().appendingPathComponent("store.json")
            try? data.write(to: filename)
        } catch {
            
        }
    }
    
    
    
    
    
    
    var body: some View {
        VStack{
            Text("总广告费：\(userData.stores[storeIndex].sumCost)").padding(.trailing,30).padding(.bottom,30)
            HStack{Text("投入广告费：").padding(.trailing,30)
            TextField("投入广告费",value:$number,formatter:NumberFormatter(),onCommit: {
                self.payAlert=true
                })
                .alert(isPresented: self.$payAlert) {
                     Alert(
                         title: Text("是否支付？"),
                         
                         primaryButton: .default(
                             Text("取消")
                             //action: saveWorkoutData
                         ),
                         secondaryButton: .destructive(
                             Text("支付"),
                             action: payCost
                         )
                     )
                }
        }
           
            
        }
    }
}


struct AddStoreView:View {
    @EnvironmentObject private var userData: UserData
    @Environment(\.presentationMode) var presentationMode
    
    //let onStorePicked: (Store) -> Void
    @State  var text1 = ""
    @State var editAlert=false
    
    
    @State  var getImage = [Image]()
    @State  var getUIImage = [UIImage]()
    
    @State  var showCameraPicker = false
    @State var showAlert = false
    
    @State var y=0
    
    let onStorePicked: (String,[Image],[UIImage]) -> Void
    
    
    
    var body:some View {
        VStack{
        
        TextField("店铺名",text:$text1)
        
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
                
                
                //if(self.userData.userName == "")
               // { self.registerAlert=true }
                
                 self.showCameraPicker = true  }, label: {
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
            
            
        
        
          
                
                Button(
                    action: {self.editAlert=true},
                label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 60)
                    .frame(width: 100, height: 70)
                    .foregroundColor( Color.blue )
                    Text("创建")
                        .foregroundColor(Color.white)
                        .font(.system(size: 25))
                }
                .frame(width: 40, height: 40)})
                .padding(.top,20)
                
        
        
        .alert(isPresented: self.$editAlert) {
        if(self.getImage.isEmpty){
            return Alert(
            title: Text("请选择照片"), message: Text("照片不能为空"), dismissButton:
            .default(Text("确定"))
             
            )
        }
        /*else if(self.text1 == ""){
            return Alert(
            title: Text("请选择店铺"), message: Text("店铺不能为空"), dismissButton:
            .default(Text("确定"))
             
            )
        }*/
        else if(self.text1 == ""){
            return Alert(
            title: Text("请输入店铺名"), message: Text("店铺名不能为空"), dismissButton:
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
                 action:
                
                
                {//self.upload()
                    self.onStorePicked(self.text1,self.getImage,self.getUIImage)
                    self.presentationMode.wrappedValue.dismiss()
             }
            )
            )}}
        }.padding(.leading,15) }
}
