//
//  TodayTimeLine.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/3/20.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI
import SwiftDate

struct TodayTimeLine: View {
    @FetchRequest(entity: Task.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Task.completedTime, ascending: true)],
                  predicate: NSPredicate(format: "isComplete == true AND completedTime >= %@ AND completedTime <= %@",
                                         Date().dateAt(.startOfDay) as CVarArg,
                                         Date().dateAt(.endOfDay) as CVarArg))
    var todayCompletedTasks: FetchedResults<Task>
    
    
    
    var body: some View {
        ZStack{
            Color("app_background").edgesIgnoringSafeArea(.all)
            VStack{
                List{
                    ForEach(todayCompletedTasks){
                        task in
                        TimeLineCard(task: task)
                    }
                }.listRowBackground(Color("app_background"))
            }
        }
    }
}

struct TodayTimeLine_Previews: PreviewProvider {
    static var previews: some View {
        TodayTimeLine()
    }
}
