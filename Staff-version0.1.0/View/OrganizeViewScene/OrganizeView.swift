//
//  RecognizeView.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/3/13.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI
import SwiftDate
/*
 实施列表： 充当收件箱的角色，作为快速添加任务的入口。 同时整理历史过期任务，高亮显示。
 
 
 
 */

struct OrganizeView: View {
    @Environment(\.managedObjectContext) var context
    @State var selectedOption = 0
    @State var isActive: Bool = false
    @FetchRequest(entity: Task.entity(), sortDescriptors: [], predicate: NSPredicate(format: "isComplete == %@ AND date <= %@", NSString("0"), Date().dateAt(.startOfDay) as CVarArg)) var expiredTasks: FetchedResults<Task> // 过期任务
    
    @FetchRequest(entity: Task.entity(), sortDescriptors: [], predicate: NSPredicate(format: "taskType == %@", NSString("0"))) var inboxTasks: FetchedResults<Task> // 收件箱
    @FetchRequest(entity: Task.entity(), sortDescriptors: [], predicate: NSPredicate(format: "taskType == %@", NSString("-1"))) var inspiratedTasks: FetchedResults<Task> //灵感
    
    let pickerOptions = ["实施","灵感"]
    var body: some View {
        NavigationView{
            VStack{
                Picker("情景选择器",selection: $selectedOption){
                    ForEach(0..<pickerOptions.count){
                        index in
                        Text(self.pickerOptions[index])
                            .tag(index)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                if selectedOption == 0 {
                    //使用手势滑动到灵感里，同样的使用手势恢复灵感到实施中
                    VStack{
                        if inboxTasks.count != 0 || expiredTasks.count != 0 {
                            List{
                                ForEach(expiredTasks){
                                    task in
                                    InboxCell(task: task)
                                }
                                ForEach(inboxTasks){
                                    task in
                                    InboxCell(task: task)
                                }
                                
                            }
                            
                            ZStack{
                                ForEach(inboxTasks){
                                    task in
                                    PreDoCardView(isActive: self.$isActive, task: task)
                                }
                                ForEach(expiredTasks){
                                    task in
                                    PreDoCardView(isActive: self.$isActive, task: task)
                                }
                                
                            }
                        }else{
                            VStack(alignment: .center){
                                Image("OrganizeBackground")
                                Button(action:{self.isActive.toggle()}){
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10)
                                        Text("收集")
                                            .foregroundColor(.white)
                                            .font(.headline)
                                        }.frame(height: 50).padding()
                                }
                            }
                            
                        }
                        Spacer()
                    }.sheet(isPresented: $isActive) {
                        InboxForm(isActive: self.$isActive)
                            .environment(\.managedObjectContext, self.context)
                    }
                    
                }else {// 灵感
                    List{
                        ForEach(inspiratedTasks){
                            task in
                            InboxCell(task: task)
                        }.onDelete(perform: deleteInboxCardWithSwipe)
                    }
                }
            }.animation(.easeInOut)
                .navigationBarTitle("整理")
        }
    }
    
    
    func deleteInboxCardWithSwipe(at offsets: IndexSet){
        for offset in offsets{
            let preDeletedTag = inspiratedTasks[offset]
            context.delete(preDeletedTag)
        }
        try? context.save()
    }
    
    
}
