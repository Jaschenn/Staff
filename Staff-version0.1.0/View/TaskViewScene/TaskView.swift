//
//  TaskView.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/2/23.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI
import CoreData
import WaterfallGrid
import SlideOverCard
import SwiftDate
import PartialSheet


struct TaskView: View {
    @Environment(\.managedObjectContext) var context
    @State private var taskName: String = ""
    @State private var selectedFilter = 1
    @Binding var isSlideCardActive: Bool // 控制父控件中的弹出卡片
    // ASAPTasks - 随时任务，尽可能快的完成没有指定时间✅
    @FetchRequest(entity: Task.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Task.date, ascending: false)],
                  predicate: NSPredicate(format: "isComplete == %@ AND date == %@",
                                         NSNumber(value: false), NSNull()))
    var ASAPTasks: FetchedResults<Task>
    
    // todayTasks - 今天的任务✅
    @FetchRequest(entity: Task.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Task.date, ascending: false)],
                  predicate: NSPredicate(format: "isComplete == %@ AND date >= %@ AND date <= %@",
                                         NSNumber(value: false),
                                         Date().dateAt(.startOfDay) as CVarArg,
                                         Date().dateAt(.endOfDay) as CVarArg))
    var todayTasks: FetchedResults<Task>
    
    //某天的任务 - 不是今天、但是指定时间了✅
    @FetchRequest(entity: Task.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Task.date, ascending: false)],
                  predicate: NSPredicate(format: "isComplete == %@ AND date >= %@",
                                         NSNumber(value: false),
                                         Date().dateAt(.tomorrow).dateAt(.startOfDay) as CVarArg))
    var somedayTasks: FetchedResults<Task>
    // 授权的任务 Todo
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.date, ascending: false)],
        predicate: NSPredicate(format: "(isComplete == %@) AND isAllocated == %@",
                               NSNumber(value: false),
                               NSNumber(true)))
    var permittedTasks: FetchedResults<Task>
    /*
     四个选项分别对应的情况为：
     今天：筛选日期为今天的Task 展示出来
     将来：手动归类到某天中的Task
     等待：有分配人的Task 😊
     随时：没有时间的Task
     */
    
    let pickerOptions = ["随时","今天","将来","跟踪"]
    @State var editMode: Bool = false
    @State var currentNeedToBeEditTask: Task? //传递给sheet的需要修改的值
    var body: some View {
        ZStack{
            Color("background").edgesIgnoringSafeArea(.all)
        VStack{
            Picker("过滤器",selection: $selectedFilter) {
                ForEach(0..<pickerOptions.count){ index in
                    Text(self.pickerOptions[index])
                }
            }.pickerStyle(SegmentedPickerStyle()).padding()
            
            HStack{
                HStack{
                    VStack{
                        List{// 根据条件展示内容
                            ForEach(getCurrentTasksData()){
                                task in
                                TaskCell(task: task,
                                         isSlideCardActive: self.$isSlideCardActive,
                                         editMode: self.$editMode)
                                    .listRowBackground(Color("app_background"))
                                    .environment(\.managedObjectContext, self.context)
                                    .contextMenu{
                                        Button(action:{
                                            self.currentNeedToBeEditTask = task
                                            self.editMode = true
                                        }){
                                            Text("修正")
                                            Image(systemName: "pencil.and.ellipsis.rectangle")
                                        }
                                }
                                
                                
                            }
                        }.animation(.default)
                        
                    }
                }
            }
            Spacer()
        }.sheet(isPresented: self.$editMode) {
            AddTaskView(isPopAdd: self.$editMode,
                        isEditMode: self.$editMode,
                        needTobeEditedTask: self.currentNeedToBeEditTask ).environment(\.managedObjectContext, self.context)
        }
    }
    }
    
    
    func getCurrentTasksData()->FetchedResults<Task>{
        switch selectedFilter {
        case 0:
            return ASAPTasks
        case 1:
            return todayTasks
        case 2:
            return somedayTasks
        case 3:
            return permittedTasks
        default:
            return todayTasks
        }
    }
}




func getCurrentTaskBackgroundColor(task: Task)-> [Color]{
    var backColor:[Color] = []
    //     杀马特风格，因为太丑不用了 ，和 LinerGrident 一起用
    //    for tag in task.tags{
    //        backColor.append(Color.init(tag.colorName ?? "defaultColor"))
    //    }
    backColor.append(Color.secondary)
    return backColor
}

