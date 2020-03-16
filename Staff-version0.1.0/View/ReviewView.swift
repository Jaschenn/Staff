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

struct ReviewView: View {
    @Environment(\.managedObjectContext) var context
    @State var showCompletedTasks = false
    @FetchRequest(entity: Task.entity(), sortDescriptors: []) var tasksRecentlycompleted: FetchedResults<Task>
    
    var today: Int{tasksRecentlycompleted.count}
    
    var body: some View {
        
        NavigationView{
            
        VStack{
            HStack(alignment: .top){
                NavigationLink(destination: ReviewToday()){
                    PieChartView(data: [10,20,30], title: "今日",  form: ChartForm.medium).padding()
                }
                Spacer()
                VStack(alignment: .leading){
                    Text("1348\n KAMA")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                        .animation(.spring())
                        .padding()
                    Text("中级").font(.headline).foregroundColor(.purple).padding(.horizontal)
                }
                
                
            }
            
            NavigationLink(destination: CompletedTaskView()){
                VStack(alignment: .leading) {
                    // 1 完成情况图
                    
                        //七天的数据
                    BarChartView(data: ChartData(points: [8,23,54,32,12,37,7,23,43]), title: "最近7日", form: ChartForm.large) .padding()// legend is optional, use optional .padding()
                    
                }
                // 2 查看情况图
            }
            Spacer()
        }.navigationBarTitle("回顾")
        }
    }
}



struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView()
    }
}


struct ReviewToday: View {
    var body: some View{
        Text("今日回顾")
    }
}
