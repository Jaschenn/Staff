//
//  RecognizeView.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/3/13.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI


struct OrganizeView: View {
    @Environment(\.managedObjectContext) var context
    @State var selectedOption = 0
    @State var isActive: Bool = false
    @FetchRequest(entity: Task.entity(), sortDescriptors: [], predicate: NSPredicate(format: "taskType == %@", NSString("0"))) var inboxTasks: FetchedResults<Task>
    @FetchRequest(entity: Task.entity(), sortDescriptors: [], predicate: NSPredicate(format: "taskType == %@", NSString("-1"))) var inspiratedTasks: FetchedResults<Task> //灵感
    
    
    var body: some View {
        VStack{
            Picker("情景选择器",selection: $selectedOption){
                Text("实施").tag(0)
                Text("灵感").tag(1)
            }.pickerStyle(SegmentedPickerStyle())
        
        if selectedOption == 0 {
        //使用手势滑动到灵感里，同样的使用手势恢复灵感到实施中
        VStack{
            if inboxTasks.count != 0 {
            List{
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
                
            }
            }else{
                VStack(alignment: .center){
                    Image("OrganizeBackground")
                    Button("收集"){
                                       self.isActive.toggle()
                                   }
                }
               
            }
            Spacer()
            }.sheet(isPresented: $isActive) {
                InboxForm(isActive: self.$isActive).environment(\.managedObjectContext, self.context)
            }
            
        }else {
            List{
                ForEach(inspiratedTasks){
                    task in
                    InboxCell(task: task)
                }
            }
            }
        }.animation(.linear)
        }
        
    }


//Card
struct PreDoCardView: View {
    //用于快速整理的一个整理器，左滑动为今天，右滑动为灵感
    @Environment(\.managedObjectContext) var context
    @State private var offset = CGSize.zero
    @Binding var isActive: Bool
    var task: Task
    var body: some View{
        
        ZStack{
            RoundedRectangle(cornerRadius: 25, style: .continuous).fill(Color.white).shadow(radius: 10)
            VStack{
                Text(task.title ?? "").font(.headline)
                Text(task.notes ?? "").font(.subheadline)
            }
        }.frame(width: 300, height: 200)
            .rotationEffect(.degrees(Double(self.offset.width/6)))
            .offset(x: self.offset.width * 1.2, y: self.offset.height > 0 ? self.offset.height : 0)
            .gesture(DragGesture()
                .onChanged{
                    value in
                    self.offset = value.translation
            }
            .onEnded{
                value in
                
                if self.offset.height > 100 {
                    
                    self.isActive.toggle()
                }
                
                if self.offset.width > 100 {
                    //更改本task状态
                    withAnimation {
                        self.task.taskType = "-1"
                    }
                    
                    try? self.context.save()
                }
                
                if self.offset.width < -100 {
                    self.task.isComplete = false
                    self.task.taskType = "1"
                    try? self.context.save()
                }
                
                withAnimation {
                    self.offset = .zero
                }
                
            })
            .animation(.spring())
        
    }
    
    
    
}


struct InboxForm: View {
    @Environment(\.managedObjectContext) var context
    @State var titleName = ""
    @Binding var isActive: Bool
    var body: some View{
        NavigationView{
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 10).fill(Color.white).frame(width: UIScreen.main.bounds.width - 50, height: 60).shadow(radius: 4)
                    
                    TextField(" 想到了什么？", text: $titleName)
                        .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                    
                }.padding()
                Spacer()
            }.navigationBarTitle("新想法",displayMode: .inline)
                .navigationBarItems(leading: Button("取消"){
                    self.isActive.toggle()
                    }, trailing: Button("存入"){
                        let newTask = Task(context: self.context)
                        newTask.title = self.titleName
                        newTask.taskType = "0" //在Inbox中
                        newTask.date = Date()
                        newTask.id = UUID()
                        do{
                            try self.context.save()
                            
                            //考虑是否可以做个弹窗提示成功？
                        }catch{
                            print(error.localizedDescription)
                        }
                        self.titleName = ""
                })
        }
    }
}



struct InboxCell: View{
    var task: Task
    var body: some View{
        ZStack(alignment: .topLeading){
            RoundedRectangle(cornerRadius: 10).fill(Color("TaskCell_background"))
            VStack(alignment: .leading){
                Text(task.title ?? "貌似出现了一个问题").font(.headline)
                Text(task.notes ?? "无备注").font(.subheadline)
            }
        }
    }
}





















//
//struct OrganizeView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        return OrganizeView(currentNeedToBeOrganizedTask: ).environment(\.managedObjectContext, context)
//    }
//}
//
