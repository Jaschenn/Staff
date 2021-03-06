//
//  SettingView.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/3/20.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @State var isOn: Bool = false
    var body: some View {
        NavigationView{
            VStack{
                Form{
                    Toggle(isOn: $isOn) {
                        Text("试验性")
                    }
                }
                Spacer()
            }.navigationBarTitle("设置")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
