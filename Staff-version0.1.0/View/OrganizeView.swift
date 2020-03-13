//
//  RecognizeView.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/3/13.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI

struct OrganizeView: View {
    @State var selectedOption = 0
    var body: some View {
        
        VStack{
            Picker("情景选择器",selection: $selectedOption){
                Text("实施").tag(0)
                Text("灵感").tag(1)
            }.pickerStyle(SegmentedPickerStyle())
            
            Spacer()
            
            if selectedOption == 0 {
                Text("这里需要一个收件箱列表、和一个滑动整理器")
                //使用手势滑动到灵感里，同样的使用手势恢复灵感到实施中
                
                
            }else {
                Text("这里记录下来历史的想法，也可以转移到灵感里")
            }
            
        }
    }
}

struct OrganizeView_Previews: PreviewProvider {
    static var previews: some View {
        OrganizeView()
    }
}
