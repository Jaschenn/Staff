//
//  TomatoView.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/3/27.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI
import SwiftDate

struct TomatoView: View {
    var needTobeEditedTask: Task
    //RUNLOOP 线程 - 主线程
    @Environment(\.managedObjectContext) var context
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var selectedOption: Int = 0
    @State var receivedTime = Date()
    @State var startTime = Date()
    @Binding var isActive: Bool
    var body: some View {
        NavigationView{
            VStack{
            Picker("模式", selection: $selectedOption) {
                Text("计时⌛️").tag(0)
                Text("番茄🍅").tag(1)
                }.pickerStyle(SegmentedPickerStyle()).padding()
            if selectedOption == 0{
                //计时器
                Spacer()
                ZStack{
                    Circle().fill(Color.orange.opacity(0.8))
                        .frame(width:200, height: 200)
                    
                        Text("\((receivedTime - startTime).hour!):\((receivedTime - startTime).minute!):\((receivedTime - startTime).second!)")
                            .font(.largeTitle)
                            .onAppear{
                                self.timer.upstream.connect().cancel()
                                self.timer = Timer
                                    .publish(every: 1, on: .main, in: .common)
                                    .autoconnect()
                                }
                        .onReceive(timer) { (time) in
                            self.receivedTime = time
                        }
                    
                }
                Spacer()
                
                Button(action:{
                    //结束计时之后停止计时器，将时间存入任务的总耗时中。
                    self.needTobeEditedTask.usedSeconds = String((self.receivedTime - self.startTime).hour! * 3600 + (self.receivedTime - self.startTime).minute! * 60 + (self.receivedTime - self.startTime).second!)
                    
                    self.needTobeEditedTask.isComplete = true // 标记任务为已完成
                    self.needTobeEditedTask.completedTime = Date() //添加任务完成时间
                    do{
                        try self.context.save()
                    }catch{
                        print(error)
                    }
                    
                    
                    self.timer.upstream.connect().cancel()
                    self.isActive.toggle()
                }){
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                        Text("结束")
                            .foregroundColor(.white)
                    }.frame(height: 50).padding()
                }
                
                Button("结束计时，但不标记任务完成"){
                   
                    self.needTobeEditedTask.usedSeconds = String((self.receivedTime - self.startTime).hour! * 3600 + (self.receivedTime - self.startTime).minute! * 60 + (self.receivedTime - self.startTime).second!)
                    do{
                        try self.context.save()
                    }catch{
                        print(error)
                    }
                    self.timer.upstream.connect().cancel()
                    self.isActive.toggle()
                }
                
            }else if selectedOption == 1 {
                //番茄钟
                Text("您无需手动使用番茄🍅，Staff将会智能的记录下您使用了番茄或者是计时器").padding()
                
            }
            Spacer()
            }.navigationBarTitle(Text("\(needTobeEditedTask.title ?? "无标题任务")"), displayMode: .large)
        }
    }
}

//struct TomatoView_Previews: PreviewProvider {
//    static var previews: some View {
//        TomatoView()
//    }
//}
