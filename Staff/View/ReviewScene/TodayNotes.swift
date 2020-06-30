//
//  TodayNotes.swift
//  Staff
//
//  Created by jas chen on 2020/4/16.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI


struct TodayNotes: View {
    @State var todayNotes: String = ""
    @State var selectedMode: Int = 0
    @State var isEditing: Bool = true
    var body: some View {
        NavigationView{
            ZStack(alignment: .topLeading){
                Color("app_background")
                VStack{
                    Form{
                        TextField("记录今日📝",
                                  text: $todayNotes,
                                  onEditingChanged: {
                                    x in print(x)
                        }) {
                            print("提交状态")
                        }.padding()
                        Button("保存"){
                            print("保存被点击了")
                        }.padding()
                    }
                }
            }.navigationBarTitle("总结今日")
            
        }
        
    }
}

struct TodayNotes_Previews: PreviewProvider {
    static var previews: some View {
        TodayNotes(todayNotes: "今天保存的东西")
    }
}
