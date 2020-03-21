//
//  PreDoCardView.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/3/20.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI

struct PreDoCardView: View {
    //用于快速整理的一个整理器，左滑动为今天，右滑动为灵感
    @Environment(\.managedObjectContext) var context
    @State private var offset = CGSize.zero
    @Binding var isActive: Bool
    var task: Task
    var body: some View{
        
        ZStack{
            RoundedRectangle(cornerRadius: 25, style: .continuous).fill(Color("2-card-background")).shadow(color: Color.secondary, radius: 4)
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
                    self.task.taskType = "1" //更新任务到列表中
                    self.task.date = Date() //更新时间为本日
                    try? self.context.save()
                }
                
                withAnimation {
                    self.offset = .zero
                }
                
            })
            .animation(.spring())
        
    }
    
    
    
}
