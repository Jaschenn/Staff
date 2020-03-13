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
    
    var today: Int{
        tasksRecentlycompleted.count
    }
    var body: some View {
            NavigationView{
                
                NavigationLink(destination: CompletedTaskView()){
                    VStack(alignment: .leading) {
                        // 1 完成情况图
                        
                            //七天的数据
                            MultiLineChartView(data: [([8,32,11,23,40,28], GradientColors.green), ([90,99,78,111,70,60,77], GradientColors.purple), ([34,56,72,38,43,100,50], GradientColors.orngPink)], title: "最近完成情况")
                        
                    }
                    // 2 查看情况图
                }
        }
    }
}



struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView()
    }
}

