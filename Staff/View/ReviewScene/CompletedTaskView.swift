//
//  CompletedTaskView.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/3/2.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI
// 所有的已经完成的任务
struct CompletedTaskView: View {
    @FetchRequest(entity: Task.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Task.completedTime, ascending: true)],
                  predicate: NSPredicate(format: "isComplete == %@", NSNumber(value: true)))
    var completedTasks : FetchedResults<Task>
    
    var body: some View {
        ZStack{
            List{
                ForEach(completedTasks,id: \.self){
                    task in
                    VStack{
                        TimeLineCard(task: task)
                    }
                }.listRowBackground(Color("app_background"))
            }
        }
    }
}

struct CompletedTaskView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedTaskView()
    }
}
