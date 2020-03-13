//
//  TestView.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/2/27.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI

struct TestView: View {
    @State var show = false
    var body: some View {
        Button(action: {self.show.toggle()}){
            Text("click to show popover")
        }.popover(isPresented: $show,arrowEdge: .top) {
            Text("H")
        }
}
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
