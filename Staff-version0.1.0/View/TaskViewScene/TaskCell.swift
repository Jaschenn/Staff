//
//  TaskCell.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/3/21.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI
import WaterfallGrid
import CoreData

struct TaskCell: View {
    /*
     重按修改，点击出现详情。
     */
    var task: Task
    @Binding var isSlideCardActive: Bool
    @Binding var editMode: Bool
    @Environment(\.managedObjectContext) var context
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: getCurrentTaskBackgroundColor(task: task)), startPoint: .leading, endPoint: .trailing)
            HStack{
                Button(action: {
                    //To DO: Edit this task with partial sheet
                    self.isSlideCardActive.toggle()
                }){
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(task.title!)
                                .font(.title)
                                .bold()
                            Text(task.notes ?? "无备注")
                                .font(.subheadline)
                                .bold()
                            TaskTagView(tags: task.tags)
                        }
                        Spacer()
                        Button(action:{self.markThisTaskComplete(task: self.task)}){
                            Image(systemName: "square").imageScale(.large)
                        }
                        
                    }.padding(.horizontal)
                }
            }
        }
        .background(Color.init("cell_background"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 4)
    }
    
    
    
    struct TaskTagView: View {
        var tags: [Tag]
        var body: some View{
            WaterfallGrid(tags, id:\.self){
                tag in
                Text(tag.name ?? "ERROR").font(.caption).padding(8).background(Color.init(tag.colorName ?? "defaultColor")).clipShape(Capsule())
            }.gridStyle(columns: 1, spacing: 6, padding: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0), animation: .interactiveSpring()).scrollOptions(direction: .horizontal, showsIndicators: false)
        }
    }
    
    func markThisTaskComplete(task: Task){
        let isComplete = true
        let taskID = task.id!
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Task")
        fetchRequest.predicate = NSPredicate(format: "id ==%@", taskID as CVarArg)
        fetchRequest.fetchLimit = 1
        do{
            let results = try context.fetch(fetchRequest)
            let taskUpdate = results[0] as! NSManagedObject
            taskUpdate.setValue(isComplete, forKey: "isComplete")
            taskUpdate.setValue(Date(), forKey: "completedTime")
        }catch{
            print(error)
        }
        
    }
    
}


//
//struct TaskCell_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskCell()
//    }
//}
