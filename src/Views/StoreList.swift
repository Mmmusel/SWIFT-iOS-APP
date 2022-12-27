//
//  StoreList.swift
//  finalApp
//
//  Created by musel on 2022/11/14.
//  Copyright © 2022 musel. All rights reserved.
//

import Foundation
import SwiftUI

struct StoreList: View {
    @EnvironmentObject var userData: UserData
    
    
    
    var body: some View {

        
        List {
            
            if (self.userData.searchedStores.isEmpty){
            ForEach(userData.stores) { store in
                NavigationLink(
                    destination: StoreView(
                        store: store
                    )
                ) {
                HStack {
                    store.image[0]
                        .resizable()
                        .cornerRadius(15)
                         .frame(width: 80, height: 80)
                        .padding(15)
                        .shadow(radius: 2)
                    Text(store.name)
                        .font(.system(size: 22))
                        .padding(.leading,15)
                    Spacer()

                    
                }.padding()
                        
               // }
                }.background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 2)
                .padding(10)
                
                
                
                }//.onDelete(perform:deleteRow)
            }else {
                ForEach(userData.searchedStores) { store in
                 NavigationLink(
                     destination: StoreView(
                         store: store
                     )
                 ) {
                 HStack {
                     store.image[0]
                         .resizable()
                        .cornerRadius(15)
                         .frame(width: 80, height: 80)
                        .padding(15)
                    .shadow(radius: 2)
                     Text(store.name)
                        .font(.system(size: 22))
                        .padding(.leading,15)
                     Spacer()

                     
                 }.background(Color.white)
                 .cornerRadius(15)
                 .shadow(radius: 2)
                 .padding(10)
                
                         
                // }
                 }}
                
                
            }
            
            
            
        }
       
    }
}
