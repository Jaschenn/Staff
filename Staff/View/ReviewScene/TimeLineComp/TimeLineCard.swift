//
//  TimeLineView.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/3/20.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI
import PartialSheet
import SwiftDate

struct TimeLineCard: View {
    let task: Task
    @State var isActive: Bool = false
    @State var taskReview: String = ""
    var body: some View {
        ZStack(alignment: .topTrailing){
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.orange)
                    .frame(height: 120)
                VStack(alignment: .leading){
                    
                    Text("\(task.completedTime?.hour ?? 0):\(task.completedTime?.minute ?? 0) ")//todo
                        .frame(height: 10)
                    
                    Divider()
                        .offset(x: 0, y: -10)
                    Text(task.title ?? "无标题")
                        .font(.headline)
                    Text(getUsedTimeDescription(seconds: task.usedSeconds ?? "使用时间没有统计"))
                }.padding()
                
            }
            Button(action:{
                self.isActive.toggle()
            }){
                Image(systemName: "square.and.pencil")
                    .padding()
            }
        }.sheet(isPresented: self.$isActive) {
            VStack{
                Form{
                    TextField("留下评论", text: self.$taskReview)
                }.padding()
                Spacer()
                Button(action:{self.isActive.toggle()}){
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                        Text("保存")
                            .foregroundColor(.white)
                            .font(.headline)
                    }.frame(height: 50).padding()
                }            }
            
            
        }
        
    }
    
    func getUsedTimeDescription(seconds: String) -> String{
        guard let totalSeconds = Double(seconds) else { return "没有时间统计" }
        
        let hour = totalSeconds / 3600
        let minute = totalSeconds.truncatingRemainder(dividingBy: 3600)/60
        let second = totalSeconds.truncatingRemainder(dividingBy: 60)
        var answer = "使用"
        if Int(hour) != 0 {
            answer += "\(Int(hour))小时"
        }
        if Int(minute) != 0 {
            answer += "\(Int(minute))分钟"
        }
        if Int(second) != 0 {
            answer += "\(Int(second))秒"
        }
        
        return answer
    }
}

