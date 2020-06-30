//
//  DatePickerView.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/3/23.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate: Date
    var body: some View {
        VStack{
        ZStack{
            Rectangle().fill(Color("app_background")).edgesIgnoringSafeArea(.all)
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 10).fill(Color("cell_background"))
                    DatePicker("时间", selection: $selectedDate, in: Date()...)
                }.padding()
                
                ZStack{
                    RoundedRectangle(cornerRadius: 10).fill(Color("cell_background")).frame(height: 200)
                    Text("选择任务的计划完成时间，如果为今日，那么您应当能够在今日视图中看到该任务，如果选择将来， 那么您应当在计划视图中看到该任务。")
                }.padding()
               
                Spacer()
            }
            
        }
         Spacer()
        }
    }
}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerView(selectedDate: .constant(Date()))
    }
}
