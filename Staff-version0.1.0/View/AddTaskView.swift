//
//  AddTaskView.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/2/24.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI
import CoreData
import WaterfallGrid

struct AddTaskView: View {
    @Environment(\.managedObjectContext) var contex
    @Binding var isPopAdd: Bool //binding 使得subview可以读写parent viwe中的var
    @State var title = ""
    @State var notes = ""
    @State var date: Date = Date()
    @FetchRequest(entity: Tag.entity(), sortDescriptors: []) var tags: FetchedResults<Tag>
    @FetchRequest(entity: People.entity(), sortDescriptors: []) var peoples: FetchedResults<People>
    @State var checkedTag: [Tag] = []
    
    var body: some View {
        NavigationView{
            VStack{
                Form{
                    HStack {
                        Image(systemName: "square")
                        TextField("新建待办事项", text: $title)
                    }
                    HStack {
                        Image(systemName: "doc.text")
                        TextField("备注", text: $notes)
                    }
                    HStack{
                        Image(systemName: "clock")
                        DatePicker("时间", selection: $date, in: ...Date())
                    }
                    HStack{
                        Image(systemName: "tag.fill")
                        WaterfallGrid(checkedTag, id: \.self){
                            tag in
                            Text(tag.name ?? "ERROR").font(.caption).padding(5).background(Color.init(tag.colorName ?? "defaultColor"))
                        }.gridStyle(columns: 1, spacing: 6, padding: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0), animation: .interactiveSpring())
                    }.scrollOptions(direction: .horizontal, showsIndicators: false)
                    
   }
                //MARK: - 标签选择器
                Section(header: Text("Select Tags")){
                    VStack{
                        Image(systemName: "tag")
                        WaterfallGrid(tags,id: \.self){
                            tag in
                            Button(action:{self.checkedTag.append(tag)
                            }){
                                ZStack{
Rectangle().clipShape(Capsule()).foregroundColor(Color.init(tag.colorName ?? "")).frame(width: getCurrentTagWidth(tag: tag),height: 30)
                                    Text(tag.name ?? "ERROR").foregroundColor(.white).shadow(radius: 1)
                                }
                                
                            }.disabled(self.checkedTag.contains(tag))
                        }.gridStyle(
                            columnsInPortrait: 3,
                            columnsInLandscape: 3,
                            spacing: 8,
                            padding: EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8),
                            animation: .easeInOut(duration: 0.5)
                        ).scrollOptions(direction: .horizontal, showsIndicators: false)
                        
                    }
                }
                // MARK: - 指派给其他人
                Section(header: Text("Allocate to people")){
                    VStack{
                        Image(systemName: "person")
                        WaterfallGrid(peoples,id: \.self){
                            people in
                            Button(action:{//todo： 保存数据
                            }){
                                Circle().overlay(Text(people.name ?? "ERROR").foregroundColor(.white).shadow(radius: 1)).scaledToFit()
                            }.frame(width: 70, height: 70)
                        }.gridStyle(
                            columnsInPortrait: 1,
                            columnsInLandscape: 5,
                            spacing: 8,
                            padding: EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8),
                            animation: .easeInOut(duration: 0.5)
                        ).scrollOptions(direction: .horizontal, showsIndicators: false)
                        
                    }
                }

                Spacer()
                // MARK: - 添加按钮
                Button(action: {
                    //创建新model
                    let newtask = Task(context: self.contex)
                    newtask.id = UUID()
                    newtask.title = self.title
                    newtask.date = self.date
                    newtask.notes = self.notes
                    newtask.isComplete = false
                    for cTag in self.checkedTag{
                        newtask.addToWithTag(cTag)
                    }
                    //更新数据库
                    saveNewTask(task: newtask, contex: self.contex)
                    self.isPopAdd = false
                }){
                        Text("Add").foregroundColor(.primary)
                        .padding()
                    
                    }
            }.navigationBarTitle("Add New Task")
        }
    }
    
}

//struct AddTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTaskView(date: Date())
//    }
//}


func saveNewTask(task: Task, contex: NSManagedObjectContext){
    do{
        try contex.save()
    }catch{
        print(error.localizedDescription)
    }
}
