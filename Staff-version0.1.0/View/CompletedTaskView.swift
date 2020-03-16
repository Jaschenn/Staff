//
//  CompletedTaskView.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/3/2.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI

struct CompletedTaskView: View {
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.completedTime, ascending: true)], predicate: NSPredicate(format: "isComplete == %@", NSNumber(value: true))) var completedTasks : FetchedResults<Task>
    
    var body: some View {
        List{
            ForEach(completedTasks,id: \.self){
                task in
                TaskReviewCell(task: task)
            }
        }
    }
}

struct CompletedTaskView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedTaskView()
    }
}

struct TaskReviewCell: View {
    let task: Task
    var body: some View{
        VStack(alignment: .leading){
            Text(task.title ?? "").font(.headline)
            Text(task.notes ?? "").font(.subheadline)
            Text(task.date?.description ?? "")
            Text(task.completedTime?.description ?? "")

        }
    }
}

