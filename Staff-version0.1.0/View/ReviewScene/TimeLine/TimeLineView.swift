//
//  TimeLineView.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/3/20.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI
import PartialSheet

struct TimeLineView: View {
    var body: some View{
        Text("hello")
    }
}

struct TimeLineView_Previews: PreviewProvider {
    static var previews: some View {
        TimeLineView()
    }
}

struct TimeLineCard: View {
    let task: Task
    var body: some View {
        ZStack(alignment: .topTrailing){
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.orange)
                    .frame(height: 120)
                VStack(alignment: .leading){
                    
                    Text(task.completedTime?.description ?? "无完成时间")
                        .frame(height: 10)
                    
                    
                    
                    
                    Divider()
                        .offset(x: 0, y: -10)
                    Text(task.title ?? "无标题")
                        .font(.headline)
                }
                
            }
            Button(action:{
                
            }){
                Image(systemName: "pencil.and.outline")
                    .padding()
            }
        }
        
    }
}

