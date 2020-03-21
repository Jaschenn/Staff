//
//  InboxForm.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/3/20.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI


struct InboxForm: View {
    @Environment(\.managedObjectContext) var context
    @State var titleName = ""
    @Binding var isActive: Bool
    var body: some View{
        NavigationView{
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 10).fill(Color("2-card-background")).frame(width: UIScreen.main.bounds.width - 50, height: 60).shadow(radius: 4)
                    
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
