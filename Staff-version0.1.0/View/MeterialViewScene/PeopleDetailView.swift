//
//  PeopleDetailView.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/3/21.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI

struct PeopleDetailView: View {
    let people: People
    @State var showPeopleDetail = false
    var body: some View {
        
        VStack(alignment: .leading){
            if showPeopleDetail{
                VStack(alignment: .leading){
                    HStack{
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .padding(.leading).padding(.top)
                        Divider()
                        VStack(alignment: .leading){
                            Text("Jas").font(.headline)
                            Text("财务总监").font(.subheadline)
                        }
                        
                    }
                    Divider()
                    VStack(alignment: .leading){
                        HStack{
                            Text("电话号码：").frame(width: 100)
                            Divider()
                            Text("18000317884")
                        }.padding(.horizontal)
                        
                        Divider()
                        
                        HStack{
                            Text("邮箱：").frame(width: 100)
                            Divider()
                            Text("cchenzyy@icloud.com")
                        }.padding(.horizontal)
                        Divider()
                        
                    }
                    
                }
                .frame(height: 200)

            }
            
            
            
            
            List{
                ForEach(people.relatedTasks){
                    task in
                    Text("无标题")
                }
            }
        }.navigationBarTitle("详情", displayMode: .inline)
         .navigationBarItems(trailing:
            Button(action: {
                withAnimation{
                    self.showPeopleDetail.toggle()
                }})
            {
                Text(self.showPeopleDetail ? "折叠" : "展开")
            }
            )
    }
}


//
//struct PeopleDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PeopleDetailView(people: People(name: "张三", phoneNumber: "18000317884", tasks: []))
//    }
//}
struct PeopleDetailTaskCell: View {
    var body: some View{
        Text("hello")
    }
}
