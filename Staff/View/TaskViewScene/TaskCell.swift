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
     重按修改，点击出现详情。 ✅
     */
    @EnvironmentObject var task: Task
    @Binding var isSlideCardActive: Bool
    @Binding var editMode: Bool
    @Environment(\.managedObjectContext) var context
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: getCurrentTaskBackgroundColor(task: task)), startPoint: .leading, endPoint: .trailing)
            HStack{
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(task.title ?? "无标题")
                            .font(.headline)
                            .bold()
                        Text(task.notes ?? "无备注")
                            .font(.footnote)
                            .bold()
                        TaskTagView(tags: task.tags)
                    }
                    Spacer()
                    Image(systemName: "square").foregroundColor(.blue).imageScale(.large).onTapGesture {
                        self.markThisTaskComplete(task: self.task)
                    }
                    
                }.padding(.horizontal)
            }
        }.onTapGesture {
            withAnimation{
                //Todo : 下个版本在添加该功能
                //self.isSlideCardActive.toggle()
            }
        }
        .background(Color.init("cell_background"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 2)
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
