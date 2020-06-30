//
//  TagForm.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/3/20.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI
import WaterfallGrid

struct TagForm: View {
    @Binding var isPopUp: Bool
    @State private var name = ""
    @State private var selectedColor = 0
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Tag.entity(), sortDescriptors: []) var tags: FetchedResults<Tag>
    
    let formatedColor = ["red","yellow","blue","green","orange","pink","gray","purple"]
    var body: some View{
        NavigationView{
            VStack{
                Form{
                    HStack{
                        Image(systemName: "textbox")
                        TextField("名称",text: $name)
                    }
                    HStack{
                        Image(systemName: "pencil.and.outline")
                        Picker("颜色", selection: $selectedColor){
                            ForEach(0..<formatedColor.count){ index in
                                Text(self.formatedColor[index]).background(Color.init(self.formatedColor[index])).tag(index)
                            }
                        }.pickerStyle(SegmentedPickerStyle()).scaledToFit()
                    }
                }
                
                WaterfallGrid(tags,id: \.self){
                    tag in
                    ZStack{
                        Rectangle().clipShape(Capsule()).foregroundColor(Color.init(tag.colorName ?? "")).frame(width: getCurrentTagWidth(tag: tag),height: 40)
                        Text(tag.name ?? "ERROR").shadow(radius: 1)
                    }
                    
                }.gridStyle(
                    columnsInPortrait: 6,
                    columnsInLandscape: 5,
                    spacing: 8,
                    padding: EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8),
                    animation: .easeInOut(duration: 0.5)
                ).scrollOptions(direction: .horizontal, showsIndicators: false)
                
                Button("添加"){
                    let tag = Tag(context: self.context)
                    tag.name = self.name
                    tag.id = UUID()
                    tag.colorName = self.formatedColor[self.selectedColor]
                    do{
                        try self.context.save()
                    }catch{
                        print(error)
                    }
                    self.isPopUp.toggle()
                }
            }.navigationBarTitle("添加新标签")
        }
    }
}



func getCurrentTagWidth(tag: Tag)-> CGFloat{
    let name = tag.name
    let compWidth = (name?.count ?? 10) * 10
    return CGFloat(compWidth < 100 ? 100: compWidth)
}


struct TagForm_Previews: PreviewProvider {
    static var previews: some View {
        TagForm(isPopUp: .constant(false))
    }
}
