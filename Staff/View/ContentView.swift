//
//  ContentView.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/2/23.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI
import PartialSheet
import BottomBar_SwiftUI

let tabBarItems: [BottomBarItem] = [
    BottomBarItem(icon: "checkmark.square", title: "列表", color: Color.purple),
    BottomBarItem(icon: "rectangle.3.offgrid", title: "整理", color: Color.blue),
    BottomBarItem(icon: "rectangle.stack.person.crop", title: "物料", color: Color.orange),
    BottomBarItem(icon: "tray.full.fill", title: "回顾", color: Color.green),
    
]

struct ContentView: View {
    @Environment(\.managedObjectContext) var context
    @State var isPopAdd = false //修改页面
    @State var isActive: Bool = false //半屏幕的弹出层
    @State private var selectedIndex: Int = 0 //新版tabBar
    @EnvironmentObject var task: Task
    var body: some View {
        ZStack{
            Color("app_background")
                .edgesIgnoringSafeArea(.all) //设置底部bottomBar的背景色
            
            VStack{
                
                if selectedIndex == 0{NavigationView{
                    TaskView(showPartialSheet: $isActive)
                        .navigationBarTitle("列表")
                        .navigationBarItems(trailing: Button(action: {
                            self.isPopAdd.toggle()
                        }){
                            Image("OrganizeBackground").renderingMode(.original).resizable().frame(width: 60, height: 60)
                        }
                        .sheet(isPresented: self.$isPopAdd){
                            AddTaskView(isPopAdd: self.$isPopAdd, isEditMode: .constant(false)).environment(\.managedObjectContext, self.context)
                        })
                    }}
                if selectedIndex == 1{
                    OrganizeView()
                }
                
                
                if selectedIndex == 2{
                    ZStack{
                        Color("app_background").edgesIgnoringSafeArea(.all)
                        MaterialView()
                    }
                }
                
                
                if selectedIndex == 3{
                    ReviewView()
                }
                
                
                
                
                BottomBar(selectedIndex: $selectedIndex, items: tabBarItems)
            }
            
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
