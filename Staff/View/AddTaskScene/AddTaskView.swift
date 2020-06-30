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
// 重新思考是否有更优雅的时间输入方式？
struct AddTaskView: View {
    @Environment(\.managedObjectContext) var contex
    @Binding var isPopAdd: Bool //binding 使得subview可以读写parent viwe中的var
    @Binding var isEditMode: Bool// 是否是编辑模式？若为编辑模式，那么需要预加载进行编辑的任务的信息
    @State var title = ""
    @State var notes = ""
    @State var date: Date = Date()
    @State var needTobeEditedTask: Task?
    @FetchRequest(entity: Tag.entity(), sortDescriptors: []) var tags: FetchedResults<Tag>
    @FetchRequest(entity: People.entity(), sortDescriptors: []) var peoples: FetchedResults<People>
    @State var checkedTag: [Tag] = []
    @State var checkedPeople:[People] = []
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                Form{
                    HStack {
                        Image(systemName: "square")
                        TextField(" 新建待办事项", text: $title)
                    }
                    HStack {
                        Image(systemName: "doc.text")
                        TextField("备注", text: $notes)
                    }
                    NavigationLink(destination: DatePickerView(selectedDate: $date)){
                        HStack{
                            Image(systemName: "clock")
                            Text("选择日期")
                        }
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
                Group{
                    VStack{
                        Text("附加")
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
                }.frame(height: 150)
                // MARK: - 指派给其他人
                Group{
                    
                    VStack{
                        Text("关联到")
                        WaterfallGrid(peoples,id: \.self){
                            people in
                            ZStack{
                                Button(action:{//todo： 保存数据, 更新视图
                                    if self.checkedPeople.contains(people){
                                        self.checkedPeople.remove(at: self.checkedPeople.firstIndex(of: people)!)
                                    }else{
                                        self.checkedPeople.append(people)
                                    }
                                    
                                }){
                                    Circle().overlay(Text(people.name ?? "ERROR")
                                        .foregroundColor(.white)
                                        .shadow(radius: 1))
                                        .scaledToFit()
                                }
                                .frame(width: 70, height: 70)
                                .blur(radius: self.checkedPeople.contains(people) ? 0.8 : 0)
                                if self.checkedPeople.contains(people){
                                    Image(systemName: "checkmark.seal.fill").foregroundColor(.yellow).font(.largeTitle)
                                }
                                
                            }
                        }.gridStyle(
                            columnsInPortrait: 1,
                            columnsInLandscape: 5,
                            spacing: 8,
                            padding: EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8),
                            animation: .easeInOut(duration: 0.5)
                        ).scrollOptions(direction: .horizontal, showsIndicators: false)
                        
                    }
                    
                }.frame(height: 120)
                
            }.navigationBarTitle(isEditMode ? "修正" : "今日新任务", displayMode: .inline)
                .navigationBarItems(trailing:   Button(action: {
                    if self.isEditMode == false{
                        self.saveNewTask()
                        self.isPopAdd = false
                    }else{
                        //更新任务
                        self.updateTask()
                        self.isEditMode = false
                        self.isPopAdd = false
                    }
                    
                }){
                    Text(isEditMode ? "更新" : "存入").foregroundColor(.primary)
                        .padding()
                    
                })
        }.onAppear {
            //修改时候需要先得到之前的分配人和标签状态
            if self.isEditMode{
                self.checkedPeople = self.needTobeEditedTask?.peoples ?? []
                self.checkedTag = self.needTobeEditedTask?.tags ?? []
                self.title = self.needTobeEditedTask?.title ?? "无标题"
                self.notes = self.needTobeEditedTask?.notes ?? "无备注"
                self.date = self.needTobeEditedTask?.date ?? Date()
            }
        }
    }
    
    func saveNewTask(){
        //添加新任务，创建新model
        let newTask = Task(context: contex)
        newTask.id = UUID()
        newTask.title = title
        newTask.date = date
        newTask.notes = notes
        newTask.isComplete = false
        for cTag in checkedTag{
            newTask.addToWithTag(cTag)
        }
        
        for cPeople in checkedPeople{
            newTask.addToRelateToPeople(cPeople)
        }
        if self.checkedPeople.count != 0{
            newTask.isAllocated = true
        }
        
        do{
            try contex.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func updateTask(){
        needTobeEditedTask?.title = title
        needTobeEditedTask?.notes = notes
        needTobeEditedTask?.date = date
        
        for cPeople in self.checkedPeople{
            needTobeEditedTask?.addToRelateToPeople(cPeople)
        }
        
        for cTag in self.checkedTag{
            needTobeEditedTask?.addToWithTag(cTag)
        }
        
        if self.checkedPeople.count != 0{
            needTobeEditedTask?.isAllocated = true
        }else{
            needTobeEditedTask?.isAllocated = false
        }
        try? contex.save() //更新
    }
    
}




