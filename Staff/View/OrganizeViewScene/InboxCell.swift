//
//  InboxCell.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/3/20.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI
import SwiftDate


struct InboxCell: View{
    var task: Task
    var body: some View{
        ZStack(alignment: .topLeading){
            RoundedRectangle(cornerRadius: 10).fill(Color("cell_background"))
            HStack{
                VStack(alignment: .leading){
                    Text(task.title ?? "无标题").font(.headline).padding(.horizontal)
                    Text(task.notes ?? "无备注").font(.caption).padding(.horizontal)
                }
                Spacer()
                if task.date ?? Date() < Date().dateAt(.startOfDay){
                    Image(systemName: "pin.fill")
                        .foregroundColor(.red)
                        .padding()
                }
                
            }
            
        }
    }
}



