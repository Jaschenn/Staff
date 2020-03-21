//
//  MaterialView.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/2/27.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI
import PartialSheet
import WaterfallGrid
import UIKit

struct MaterialView: View {
    @State private var selectedOption = 0
    @State private var addMaterialMode = false //控制sheet弹出和隐藏
    @Environment(\.managedObjectContext) var contex
    @State var phoneNumberIsValidate = false
    @FetchRequest(entity: Tag.entity(), sortDescriptors: []) var tags: FetchedResults<Tag>
    @FetchRequest(entity: People.entity(), sortDescriptors: []) var peoples: FetchedResults<People>
    @State var showAddButton = true
    
    let pickerOptions = ["People", "Tags"]
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            NavigationView{
                
                ZStack{
                    Color("app_background").edgesIgnoringSafeArea(.all)//设置导航栏标题颜色
                    VStack{
                        Picker("selectOption",selection: $selectedOption){
                            ForEach(0..<pickerOptions.count){
                                index in
                                Text(self.pickerOptions[index]).tag(index)
                            }
                            }.pickerStyle(SegmentedPickerStyle()).padding()
                        Spacer()
                        List{
                            if selectedOption == 0{//人员列表
                                ForEach(peoples, id: \.self){
                                    people in
                                    NavigationLink(destination: PeopleDetailView(people: people).onAppear{
                                        self.showAddButton = false
                                    }){
                                        PeopleCell(people: people)
                                            .contextMenu {
                                                Button(action: {self.callPeopleWithPhoneNumber(people: people)}){
                                                    Text(self.phoneNumberIsValidate ? "拨打" : "号码有误")
                                                    Image(systemName: "phone.arrow.up.right")
                                                }
                                                .disabled(!self.phoneNumberIsValidate)
                                                .onAppear{
                                                    self.initContextMenu(people: people)
                                                }
                                                
                                                
                                                Button(action: {
                                                    self.deleteCurrentPeople(people: people)
                                                }){
                                                    Text("删除联系人").foregroundColor(.red)
                                                    Image(systemName: "trash").foregroundColor(.red)
                                                }
                                        }
                                    }
                                    
                                }.onDelete(perform: deleteCurrentPeopleWithSwipe)
                            }
                            else if selectedOption == 1{//标签列表
                                ForEach(tags, id: \.self){
                                    tag in
                                    Text(tag.name ?? "").padding().background(Color.init(tag.colorName ?? "defaultColor"))
                                }.onDelete(perform: deleteCurrentTagWithSwipe)
                            }
                            
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 20)).padding()
                        
                        
                        .onAppear{
                            withAnimation{
                                self.showAddButton = true
                            }
                        }
                        
                    }.navigationBarTitle("物料")
                }
                
            }
            if showAddButton{
                Button(action:{
                    self.addMaterialMode = true
                }){
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 70,height: 70)
                        .padding()
                }.sheet(isPresented: $addMaterialMode) {
                    if(self.selectedOption==0){
                        PeopleForm(isActive: self.$addMaterialMode )
                            .environment(\.managedObjectContext, self.contex)
                    }else{
                        TagForm(isPopUp: self.$addMaterialMode)
                            .environment(\.managedObjectContext, self.contex)
                    }
                }
            }
            
        }
    }
    
    func deleteCurrentPeople(people: People){
        // contains bug
        // This is the same bug: https://forums.developer.apple.com/thread/124735
        // 可能已经解决、出现情况不明确
        let preDeletePeople = people
        for task in preDeletePeople.relatedTasks{
            task.removeFromRelateToPeople(preDeletePeople)
            if task.peoples.count == 0 {
                task.isAllocated = false
            }
        }
        contex.delete(preDeletePeople)
        do{
            try contex.save()
        }catch{
            print(error)
        }
    }
    func deleteCurrentPeopleWithSwipe(at offsets: IndexSet){
        for offset in offsets{
            let preDeletePeople = peoples[offset]
            for task in preDeletePeople.relatedTasks{
                task.removeFromRelateToPeople(preDeletePeople)
                if task.peoples.count == 0 {
                    task.isAllocated = false
                }
            }
            contex.delete(preDeletePeople)
        }
        
        do{
            try contex.save()
        }catch{
            print(error)
        }
        
    }
    func deleteCurrentTagWithSwipe(at offsets: IndexSet){
        //删除标签之前首先删除和此标签相关联的所有的任务中的本标签
        for offset in offsets{
            let preDeleteTag = tags[offset]
            for task in preDeleteTag.interrelatedTasks{
                task.removeFromWithTag(preDeleteTag)
            }
            contex.delete(preDeleteTag)
        }
        try? contex.save()
        
    }
    
    func validateMobile(phoneNumber: String?)-> Bool{
        /**
         
         验证手机号码是否为合法的手机号码，如果不合法，那么让contextMenu中的button变为dissable
         
         */
        //        guard phoneNumber != nil else {
        //            return false
        //        }
        //        let phoneRegex: String = "^((1[3-9][0-9]))\\d{8}$"
        //        let phoneNumber = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        //        return phoneNumber.evaluate(with: phoneNumber)
        return true
    }
    
    
    func callPeopleWithPhoneNumber(people: People){
        let clearnString = (people.phoneNumber)?.replacingOccurrences(of: " ", with: "")
        //验证手机号码是否为合法手机号码，如果不合法，disable掉按钮
        self.phoneNumberIsValidate = self.validateMobile(phoneNumber: clearnString!)
        let tel = "tel://"
        let formattedString = tel + clearnString! //已经检验过
        let url = URL(string: formattedString)
        UIApplication.shared.open(url!)
    }
    
    func initContextMenu(people: People){
        //验证手机号码是否为合法手机号码，如果不合法，disable掉按钮，下方的检测函数可能有问题
        let clearnString = (people.phoneNumber)?.replacingOccurrences(of: " ", with: "")
        self.phoneNumberIsValidate = self.validateMobile(phoneNumber: clearnString)
    }
}


struct MaterialView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return MaterialView().environment(\.managedObjectContext, context)
    }
}

