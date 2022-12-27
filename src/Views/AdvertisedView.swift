//
//  AdvertisedView.swift
//  finalApp
//
//  Created by musel on 2022/11/12.
//  Copyright © 2022 musel. All rights reserved.
//

import Foundation
import SwiftUI
struct AdvertisedStores: View {
    var stores: [Store]
    
    
    var body: some View {
        //List{
        
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 0) {
                ForEach(self.stores) { store in
                    NavigationLink(
                        destination: StoreView(
                            store: store
                        )
                    ) {
                        //picItem(store: store,iindex: 0)
                        picItem(store: store).padding(.leading,10)
                    }
                }
            }
        }
            
        .frame(height: 180)
        }
}

struct AdvertisedStores2: View {
    var stores: [Store]
    
    
    var body: some View {
        //List{
        
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 0) {
                ForEach(0..<5) { index in
                //ForEach(self.stores) { store in
                    NavigationLink(
                        destination: StoreView(
                            store: self.stores[index]
                        )
                    ) {
                        //picItem(store: store,iindex: 0)
                        picItem(store: self.stores[index])
                    }.padding(.leading,20).padding(.bottom,15)
                }
            }
        }
            
        .frame(height: 200)
        }
        
        
    //}
    

}

struct picItem: View {
    var store: Store
    //@State var iindex:Int
    //let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack(alignment: .leading) {
            store.image[0]
                .renderingMode(.original)
                .resizable()
                .frame(width: 165, height: 145)
                //.cornerRadius(15)
            Text(store.name)
                .foregroundColor(.primary)
                .font(.system(.body, design: .rounded))
                .padding(.leading,15)
        }
        
        
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 2)
        /*.onReceive(timer, perform: { _ in
            self.iindex += 1
            self.iindex=self.iindex%(self.store.image.count)
        })*/
    }
}

/*
struct picItem: View {
    var store: Store
    @State var iindex:Int
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack(alignment: .leading) {
            store.image[iindex]
                .renderingMode(.original)
                .resizable()
                .frame(width: 155, height: 155)
                .cornerRadius(5)
            Text(store.name)
                .foregroundColor(.primary)
                .font(.caption)
        }
        .padding(.leading, 15)
        .onReceive(timer, perform: { _ in
            self.iindex += 1
            self.iindex=self.iindex%(self.store.image.count)
        })
    }
}
*/
