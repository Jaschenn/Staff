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
    
    @FetchRequest(entity: Task.entity(),
                  sortDescriptors: [],
                  predicate: NSPredicate(format: "isComplete == %@", NSNumber(1)))
    var allCompletedTasks: FetchedResults<Task>
    
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
    
    @State var showSettingView = false
    
    var body: some View {
        
        NavigationView{
            
        VStack{
            HStack{
                //左侧今日视图
                NavigationLink(destination: TodayTimeLine()){
                    PieChartView(
                        data: [Double(todayCompletedTasks.count),Double(todayRemainTasks.count)],
                        title: "今日 \(todayRemainTasks.count)/\(todayCompletedTasks.count)",
                        form: ChartForm.medium
                    ).padding()
                }
               //右侧 设置以及组件
                VStack{
                    //  设置按钮
//                    HStack{
//                        Spacer()
//                        VStack(alignment: .trailing){
//                            NavigationLink(destination: SettingView()){
//                        ZStack{
//                            Circle()
//                                .fill(Color("TaskCell_background"))
//                                .frame(width: 70, height: 70)
//                                .shadow(radius: 10)
//                            Image(systemName: "person")
//                                .resizable()
//                                .foregroundColor(.secondary)
//                                .frame(width: 40, height: 40)
//                        }
//
//                    }
//                                .padding()
//                        }
//                    }
                    
                    VStack(alignment: .leading){
                        //Kama
                        HStack{
                            Text("\(allCompletedTasks.count * 5)\n KAMA")
                                .font(.largeTitle)
                                .foregroundColor(.green)
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
            }
            
           
                VStack(alignment: .leading) {
                     NavigationLink(destination: CompletedTaskView()){
                        BarChartView(
                            data: ChartData(points: [110,23,54,32,12,37,7,23,43]),
                            title: "最近7日",
                            form: ChartForm.large
                        ).padding()
                    }

                }
           
            Spacer()
        }.navigationBarTitle("回顾")
        .navigationBarItems(trailing:
            Button(action:{
                self.showSettingView.toggle()
            }){
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
            }.offset(x: 0, y: 50))
            .sheet(isPresented: $showSettingView) {
                SettingView()
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


