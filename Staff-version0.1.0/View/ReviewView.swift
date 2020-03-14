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
                
                NavigationLink(destination: CompletedTaskView()){
                    VStack(alignment: .leading) {
                        // 1 完成情况图
                        
                            //七天的数据
                        LineView(data: [8,23,54,32,12,37,7,23,43], title: "最近完成情况", legend: "Full screen") .padding()// legend is optional, use optional .padding()
                        
                    }
                    // 2 查看情况图
                }.navigationBarTitle("回顾")
        }
    }
}



struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView()
    }
}

