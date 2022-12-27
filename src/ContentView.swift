//
//  ContentView.swift
//  finalApp
//
//  Created by musel on 2022/11/12.
//  Copyright © 2022 musel. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    //@State private var selection = 1
    @EnvironmentObject private var userData: UserData
    
    init() {
        // To remove only extra separators below the list:
        UITableView.appearance().tableFooterView = UIView()

        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
    }
 
    var body: some View {
        TabView(selection: $userData.selection){
            PageView1()
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: (userData.selection==0) ? "bookmark.fill" : "bookmark")
                        .foregroundColor((userData.selection==0) ? Color.blue : Color.gray)
                        Text("精选").foregroundColor((userData.selection==0) ? Color.blue : Color.gray)
                    }
                }
                .tag(0)
            PageView2()
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: (userData.selection==1) ? "ellipses.bubble.fill" : "ellipses.bubble")
                        .foregroundColor((userData.selection==0) ? Color.blue : Color.gray)
                        Text("发布").foregroundColor((userData.selection==0) ? Color.blue : Color.gray)
                    }
                }
                .tag(1)
            PageView3()
            .font(.title)
            .tabItem {
                VStack {
                    Image(systemName: (userData.selection==2) ? "person.fill" : "person")
                    .foregroundColor((userData.selection==0) ? Color.blue : Color.gray)
                    Text("个人").foregroundColor((userData.selection==0) ? Color.blue : Color.gray)
                }
            }
            .tag(2)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
