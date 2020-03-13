//
//  ContentView.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/2/23.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI
import SlideOverCard
import BottomBar_SwiftUI

let tabBarItems: [BottomBarItem] = [
    BottomBarItem(icon: "checkmark.square", title: "列表", color: Color.purple),
    BottomBarItem(icon: "rectangle.3.offgrid", title: "整理", color: Color.blue),
    BottomBarItem(icon: "rectangle.stack.person.crop", title: "物料", color: Color.orange),
    BottomBarItem(icon: "tray.full.fill", title: "回顾", color: Color.green),

]



struct ContentView: View {
    @Environment(\.managedObjectContext) var context
    @State private var selectionTab = 0
    @State var isPopAdd = false
    @State var isSlideCardActive: Bool = false
    @State private var selectedIndex: Int = 0 //新版tabBar
    
    
    var body: some View {
        
        ZStack{
            // MARK: - Task View
            TabView(selection: $selectionTab){
                NavigationView{
                    TaskView(isSlideCardActive: $isSlideCardActive)
                        .navigationBarTitle("Task")
                        .navigationBarItems(trailing: Button(action: {
                            self.isPopAdd.toggle()
                        }){
                            Image(systemName: "plus.circle").imageScale(.large)
                        }.sheet(isPresented: self.$isPopAdd){
                            AddTaskView(isPopAdd: self.$isPopAdd).environment(\.managedObjectContext, self.context)
                        })
                }.tabItem{
                    VStack{
                        Image(systemName: "checkmark.square")
                        Text("列表")
                    }}.tag(0)
                
                OrganizeView().tabItem {
                    VStack{
                        Image(systemName: "rectangle.3.offgrid")
                        Text("整理")
                    }
                }.tag(3)
                
                // MARK: - 物料
                NavigationView{
                    MaterialView()
                        .navigationBarTitle("Materials")
                }
                .tabItem {
                    VStack {
                        Image(systemName: "rectangle.stack.person.crop")
                        Text("物料")
                    }
                }
                .tag(1)
                ReviewView()
                    .tabItem{
                        VStack {
                            Image(systemName: "tray.full.fill")
                            Text("回顾")
                        }
                }.tag(2)
                
            }
            
            if isSlideCardActive == true{
                SlideOverCard {
                    Text("hello")
                }
            }
            
            BottomBar(selectedIndex: $selectedIndex, items: tabBarItems)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
