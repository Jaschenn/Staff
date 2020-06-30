//
//  ReviewView.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/2/26.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI
import PartialSheet
import SwiftUICharts
import SwiftDate

struct ReviewView: View {
    @Environment(\.managedObjectContext) var context
    @State var showCompletedTasks = false
    
    @State var showSettingView = false
    
    @State var showTodayNotes = false
    
    var body: some View {
        
        NavigationView{
        ZStack{
            Color("app_background")
                .edgesIgnoringSafeArea(.all)
            VStack{
                VStack {
                    HStack{
                        //左侧今日视图
                        VStack {
                            TodayCompleteTaskChartView()
                                .padding(.leading)
                            Spacer()
                        }.sheet(isPresented: $showSettingView) {
                                
                                     SettingView()
                        
                            }
                        
                        Spacer(minLength: 8)//撑开左右部分
                       //右侧
                        RightGroupTextView(showTodayNotes: $showTodayNotes)
                            .sheet(isPresented: $showTodayNotes) {
                                TodayNotes()
                       }
                    }
                }
                VStack{
                    RecentCompletedTaskChartView()
                    Spacer()
                }
               Spacer()
            }
            .navigationBarTitle("回顾")
            .navigationBarItems(trailing:
                Button(action:{
                    self.showSettingView.toggle()
                }){
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                })
            }
        }
        
    }
}



struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ReviewView().environment(\.managedObjectContext, context)
    }
}


struct ReviewToday: View {
    var body: some View{
        Text("今日回顾")
    }
}



struct RecentCompletedTaskChartView: View {
    @FetchRequest(entity: Task.entity(),
                  sortDescriptors: [],
                  predicate: NSPredicate(format: "isComplete == %@ AND date >= %@ AND date <= %@",
                                         NSNumber(value: true),
                                         Date().dateAt(.startOfDay) as CVarArg,
                                         Date().dateAt(.endOfDay) as CVarArg))
    var last0: FetchedResults<Task>
    @FetchRequest(entity: Task.entity(),
                  sortDescriptors: [],
                  predicate: NSPredicate(format: "isComplete == %@ AND date >= %@ AND date <= %@",
                                         NSNumber(value: true),
                                         Date().dateAt(.yesterday).dateAt(.startOfDay) as CVarArg,
                                         Date().dateAt(.yesterday).dateAt(.endOfDay) as CVarArg))
    var last1: FetchedResults<Task>
    @FetchRequest(entity: Task.entity(),
                  sortDescriptors: [],
                  predicate: NSPredicate(format: "isComplete == %@ AND date >= %@ AND date <= %@",
                                         NSNumber(value: true),
                                         Date().dateAt(.yesterday).dateAt(.yesterday).dateAt(.startOfDay) as CVarArg,
                                         Date().dateAt(.yesterday).dateAt(.yesterday).dateAt(.endOfDay) as CVarArg))
    var last2: FetchedResults<Task>
    @FetchRequest(entity: Task.entity(),
                  sortDescriptors: [],
                  predicate: NSPredicate(format: "isComplete == %@ AND date >= %@ AND date <= %@",
                                         NSNumber(value: true),
                                         Date().dateAt(.yesterday).dateAt(.yesterday).dateAt(.yesterday).dateAt(.startOfDay) as CVarArg,
                                         Date().dateAt(.yesterday).dateAt(.yesterday).dateAt(.yesterday).dateAt(.endOfDay) as CVarArg))
    var last3: FetchedResults<Task>
    @FetchRequest(entity: Task.entity(),
                  sortDescriptors: [],
                  predicate: NSPredicate(format: "isComplete == %@ AND date >= %@ AND date <= %@",
                                         NSNumber(value: true),
                                         Date().dateAt(.yesterday).dateAt(.yesterday).dateAt(.yesterday).dateAt(.yesterday).dateAt(.startOfDay) as CVarArg,
                                         Date().dateAt(.yesterday).dateAt(.yesterday).dateAt(.yesterday).dateAt(.yesterday).dateAt(.endOfDay) as CVarArg))
    var last4: FetchedResults<Task>
    @FetchRequest(entity: Task.entity(),
                  sortDescriptors: [],
                  predicate: NSPredicate(format: "isComplete == %@ AND date >= %@ AND date <= %@",
                                         NSNumber(value: true),
                                         Date().dateAt(.yesterday).dateAt(.yesterday).dateAt(.yesterday).dateAt(.yesterday).dateAt(.yesterday).dateAt(.startOfDay) as CVarArg,
                                         Date().dateAt(.yesterday).dateAt(.yesterday).dateAt(.yesterday).dateAt(.yesterday).dateAt(.yesterday).dateAt(.endOfDay) as CVarArg))
    var last5: FetchedResults<Task>
    @FetchRequest(entity: Task.entity(),
                  sortDescriptors: [],
                  predicate: NSPredicate(format: "isComplete == %@ AND date >= %@ AND date <= %@",
                                         NSNumber(value: true),
                                         Date().dateAt(.yesterday).dateAt(.yesterday).dateAt(.yesterday).dateAt(.yesterday).dateAt(.yesterday).dateAt(.yesterday).dateAt(.startOfDay) as CVarArg,
                                         Date().dateAt(.yesterday).dateAt(.yesterday).dateAt(.yesterday).dateAt(.yesterday).dateAt(.yesterday).dateAt(.yesterday).dateAt(.endOfDay) as CVarArg))
    var last6: FetchedResults<Task>
    
    
    var body: some View {
        ZStack{
            if getSum([last0.count,last1.count,last2.count,last3.count,last4.count,last5.count,last6.count]) != 0{
                NavigationLink(destination: CompletedTaskView()){
                BarChartView(
                    data: ChartData(points: [Float(last6.count), Float(last5.count), Float(last4.count), Float(last3.count), Float(last2.count), Float(last1.count) , Float(last0.count)]),
                    title: "最近7日",
                    style: Styles.barChartStyleOrangeDark,
                    form: ChartForm.large,
                    dropShadow: false
                ).padding()
            }
            }else{
                ZStack{
                    RoundedRectangle(cornerRadius: 25).fill(Color.green)
                    Text("您需要使用一段时间才可以回顾更多的日子")
                }.padding()
                
            }
        }
    }
    func getSum(_ nums: [Int]) -> Int{
        var answer = 0
        for i in nums{
            answer = answer + i
        }
        return answer
    }
}

struct TodayCompleteTaskChartView: View {
    @FetchRequest(entity: Task.entity(),
                  sortDescriptors: [],
                  predicate: NSPredicate(format: "isComplete == %@ AND date >= %@ AND date <= %@",
                                         NSNumber(value: true),
                                         Date().dateAt(.startOfDay) as CVarArg,
                                         Date().dateAt(.endOfDay) as CVarArg))
    var todayCompletedTasks: FetchedResults<Task>

    @FetchRequest(entity: Task.entity(),
                  sortDescriptors: [],
                  predicate: NSPredicate(format: "isComplete == %@ AND date >= %@ AND date <= %@",
                                         NSNumber(value: false),
                                         Date().dateAt(.startOfDay) as CVarArg,
                                         Date().dateAt(.endOfDay) as CVarArg))
    var todayRemainTasks: FetchedResults<Task>
    
    var body: some View {
        NavigationLink(destination: TodayTimeLine()){
            PieChartView(
                data: [Double(todayCompletedTasks.count),Double(todayRemainTasks.count)],
                title: "今日 \(todayRemainTasks.count)/\(todayCompletedTasks.count)",
                style: Styles.pieChartStyleOne,
                form: ChartForm.medium,
                dropShadow: false
            )
        }
    }
}


struct RightGroupTextView: View {
    @Binding var showTodayNotes: Bool
    @FetchRequest(entity: Task.entity(),
                  sortDescriptors: [],
                  predicate: NSPredicate(format: "isComplete == %@", NSNumber(1)))
    var allCompletedTasks: FetchedResults<Task>
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .frame(height: 140)
                    .padding(.trailing)
                VStack(alignment: .leading){
                    //Kama
                    HStack{
                        Text("\(allCompletedTasks.count * 5)\nKAMA")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                            .animation(.spring())
                            .fixedSize()
                        
                        Image(systemName: "text.bubble")
                            .imageScale(.small)
                            .foregroundColor(.secondary)
                    }
                    //级别
                    Text(allCompletedTasks.count * 5 < 500 ? "初级" : "中级")
                        .font(.headline)
                        .foregroundColor(.purple)
                        .padding(.vertical)
                    
                }
                
            }
            
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(height: 100)
                Button(action:{self.showTodayNotes.toggle()
                    print(self.showTodayNotes)
                }){
                    Text("总结今天").font(.largeTitle)
                }
                
                
            }
            
            Spacer()
        }.padding(.trailing)
            
    }
}
