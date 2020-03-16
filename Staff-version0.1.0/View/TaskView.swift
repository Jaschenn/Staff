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
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.date, ascending: false)], predicate: NSPredicate(format: "isComplete == %@ AND date == %@", NSNumber(value: false), NSNull())) var ASAPTasks: FetchedResults<Task>
    
    // todayTasks - 今天的任务✅
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.date, ascending: false)], predicate: NSPredicate(format: "isComplete == %@ AND date >= %@ AND date <= %@", NSNumber(value: false), Date().dateAt(.startOfDay) as CVarArg, Date().dateAt(.endOfDay) as CVarArg)) var todayTasks: FetchedResults<Task>
    
    //某天的任务 - 不是今天、但是指定时间了✅
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.date, ascending: false)], predicate: NSPredicate(format: "isComplete == %@ AND date >= %@", NSNumber(value: false), Date().dateAt(.tomorrow).dateAt(.startOfDay) as CVarArg)) var somedayTasks: FetchedResults<Task>
    // 授权的任务 Todo
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.date, ascending: false)],
        predicate: NSPredicate(format: "(isComplete == %@) AND isAllocated == %@", NSNumber(value: false), NSNumber(true)))
    var permittedTasks: FetchedResults<Task>
    /*
     四个选项分别对应的情况为：
     今天：筛选日期为今天的Task 展示出来
     将来：手动归类到某天中的Task
     等待：有分配人的Task 😊
     随时：没有时间的Task
     */
    
    let pickerOptions = ["随时","今天","将来","等待"]
    @State var editMode = false
    
    var body: some View {
            
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
                                    TaskCell(task: task,isSlideCardActive: self.$isSlideCardActive, editMode: self.$editMode).environment(\.managedObjectContext, self.context)
                                        .sheet(isPresented: self.$editMode) {
                                            AddTaskView(isPopAdd: self.$editMode, isEditMode: true, needTobeEditedTask: task ).environment(\.managedObjectContext, self.context)
                                    }
                                    
                                }
                            }.animation(.default)
                                
                        }
                    }
                }
                Spacer()
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
    
    func getCurrentAuthoriedTasks()-> [Task]{
        // no used
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "People")
        var existPeoples: [People] = []
        do{
            try existPeoples = context.fetch(fetchRequest) as! [People]
        }catch{
            print(error)
        }
        
        let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        fetchRequest2.predicate = NSPredicate(format: "(isComplete == %@) AND (ALL relateToPeople IN %@)", NSNumber(0), existPeoples)
        var results: [Task] = []
        do{
            results = try context.fetch(fetchRequest2) as! [Task]
            return results
        }catch{
            print(error)
        }
        return results
        
    }
    
    
}
//
//struct TaskView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        return TaskView(cardPosttion: $cardPosition).environment(\.managedObjectContext, context)
//    }
//}





struct TaskCell: View {
    /*
     重按修改，点击出现详情。
     */
    var task: Task
    @Binding var isSlideCardActive: Bool
    @Binding var editMode: Bool
    @Environment(\.managedObjectContext) var context
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: getCurrentTaskBackgroundColor(task: task)), startPoint: .leading, endPoint: .trailing)
            HStack{
                Button(action: {
                    //To DO: Edit this task with partial sheet
                    self.isSlideCardActive.toggle()
                }){
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(task.title!)
                                .font(.title)
                                .bold()
                            Text(task.notes ?? "无备注")
                                .font(.subheadline)
                                .bold()
                            TaskTagView(tags: task.tags)
                        }
                        Spacer()
                        Button(action:{markThisTaskComplete(task: self.task, context: self.context)}){
                            Image(systemName: "square").imageScale(.large)
                        }
                        
                    }.padding(.horizontal)
                }
            }
            
            }
        .background(Color.init("TaskCell_background")).clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 4)
            .contextMenu{
                Button(action:{
                    self.editMode.toggle()
                }){
                    Text("修正")
                    Image(systemName: "pencil.and.ellipsis.rectangle")
                }
        }
    }
}

func markThisTaskComplete(task: Task, context: NSManagedObjectContext){
    let isComplete = true
    let taskID = task.id!
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Task")
    fetchRequest.predicate = NSPredicate(format: "id ==%@", taskID as CVarArg)
    fetchRequest.fetchLimit = 1
    do{
        let results = try context.fetch(fetchRequest)
        let taskUpdate = results[0] as! NSManagedObject
        taskUpdate.setValue(isComplete, forKey: "isComplete")
        taskUpdate.setValue(Date(), forKey: "completedTime")
    }catch{
        print(error)
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

struct TaskTagView: View {
    @State var tags: [Tag]
    var body: some View{
        WaterfallGrid(tags, id:\.self){
            tag in
            Text(tag.name ?? "ERROR").font(.caption).padding(8).background(Color.init(tag.colorName ?? "defaultColor")).clipShape(Capsule())
        }.gridStyle(columns: 1, spacing: 6, padding: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0), animation: .interactiveSpring()).scrollOptions(direction: .horizontal, showsIndicators: false)
    }
}

