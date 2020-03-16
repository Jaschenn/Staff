//
//  MaterialView.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/2/27.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI
import PartialSheet
import WaterfallGrid
import UIKit

struct MaterialView: View {
    @State private var selectedOption = 0
    @State private var addMaterialMode = false //控制sheet弹出和隐藏
    @Environment(\.managedObjectContext) var contex
    //FetchRequest在进入页面的时候会生效
    @FetchRequest(entity: Tag.entity(), sortDescriptors: []) var tags: FetchedResults<Tag>
    @FetchRequest(entity: People.entity(), sortDescriptors: []) var peoples: FetchedResults<People>
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            VStack{
                Picker("helo",selection: $selectedOption){
                    Text("People").tag(0)
                    Text("Tags").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
                List{
                    if selectedOption == 1{//标签列表
                        ForEach(tags, id: \.self){
                            tag in
                            Text(tag.name ?? "").padding().background(Color.init(tag.colorName ?? "defaultColor"))
                        }.onDelete(perform: deleteCurrentTagWithSwipe)
                    }else if selectedOption == 0{//人员列表
                        ForEach(peoples, id: \.self){
                            people in
                            PeopleCell(people: people).contextMenu {
                                Button(action: {
                                    self.deleteCurrentPeople(people: people)
                                }){
                                 Text("delete this people")
                                 Image(systemName: "trash")
                                }
                            }
                        }.onDelete(perform: deleteCurrentPeopleWithSwipe)
                    }
                }
                
            }
            Button(action:{
                self.addMaterialMode = true
            }){
                Image(systemName: "plus.circle.fill").resizable().frame(width: 70,height: 70).padding()
            }.sheet(isPresented: $addMaterialMode) {
                if(self.selectedOption==0){
                    PeopleForm(isActive: self.$addMaterialMode ).environment(\.managedObjectContext, self.contex)
                }else{
                    TagForm(isPopUp: self.$addMaterialMode).environment(\.managedObjectContext, self.contex)
                }
            }
        }
    }
    // TODO: 删除标签和删除人的时候需要十分谨慎，要考虑到已分配的关系应该如何清除？
    func deleteCurrentPeople(people: People){
        // contains bug
        // This is the same bug: https://forums.developer.apple.com/thread/124735
        let preDeletePeople = people
        contex.delete(preDeletePeople)
        do{
            try contex.save()
        }catch{
            print(error)
        }
    }
    func deleteCurrentPeopleWithSwipe(at offsets: IndexSet){
        for offset in offsets{
            let preDeletePeople = peoples[offset]
            contex.delete(preDeletePeople)
        }
        
        do{
            try contex.save()
        }catch{
            print(error)
        }
        
    }
    func deleteCurrentTagWithSwipe(at offsets: IndexSet){
        //删除标签之前首先删除和此标签相关联的所有的任务中的本标签
        for offset in offsets{
            let preDeleteTag = tags[offset]
            for task in preDeleteTag.interrelatedTasks{
                task.removeFromWithTag(preDeleteTag)
            }
            contex.delete(preDeleteTag)
        }
        try? contex.save()
        
    }

}

//
struct PeopleCell: View {
    let people: People
    var uiImage: UIImage{
        if let bioData = people.bio{
          return UIImage(data: bioData)!
        }else{
             return UIImage(systemName: "person.circle")!
        }
    }
    var body: some View {
        HStack{
            Image(uiImage: uiImage).resizable().clipShape(Circle()).frame(width: 50, height: 50).scaledToFit()
            VStack(alignment: .leading){
                Text(people.name ?? "ERROR").font(.headline).foregroundColor(.primary)
                Spacer()
                Text(people.phoneNumber ?? "ERROR").font(.subheadline).foregroundColor(.secondary)
            }
        }
    }
}

struct MaterialView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return MaterialView().environment(\.managedObjectContext, context)
    }
}


struct PeopleForm: View {
    @State private var name = ""
    @State private var phoneNumber = ""
    @Environment(\.managedObjectContext) var context
    @State private var showImagePicker = false
    @State private var selectedUIImage: UIImage?
    @Binding var isActive: Bool
    var body: some View {
        NavigationView{
            VStack{
                Form{
                    HStack{
                        Image(systemName: "person.circle.fill")
                        TextField("name", text: $name)
                    }
                    HStack{
                        Image(systemName: "phone.circle.fill")
                        TextField("phone number", text: $phoneNumber)
                    }
                    Button("添加bio"){
                        self.showImagePicker = true
                    }.sheet(isPresented: $showImagePicker) {
                        ImagePickerView(showImagePicker: self.$showImagePicker, uiImage: self.$selectedUIImage)
                    }
                    
                }
                Button("Add"){
                    let newPeople = People(context: self.context)
                    newPeople.name = self.name
                    newPeople.phoneNumber = self.phoneNumber
                    newPeople.id = UUID()
                    newPeople.bio = self.selectedUIImage?.pngData()
                    
                    do{
                        try self.context.save()
                    }catch{
                        print(error)
                    }
                    self.isActive.toggle()
                }
            }.navigationBarTitle("Add New People")
            
        }
    }
}


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
            }.navigationBarTitle("Add New Tag")
        }
    }
}


func getCurrentTagWidth(tag: Tag)-> CGFloat{
    let name = tag.name
    let compWidth = (name?.count ?? 10) * 10
    return CGFloat(compWidth < 100 ? 100: compWidth)
}


struct ImagePickerView: View {
    @Binding var showImagePicker    : Bool
    @Binding var uiImage              : UIImage?
    var body: some View{
        ImagePicker(isShown: $showImagePicker, uiImage: $uiImage)
    }
}


struct ImagePicker : UIViewControllerRepresentable {
   @Binding var isShown : Bool
   @Binding var uiImage : UIImage?
    
func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
}
func makeCoordinator() -> ImagePickerCordinator {
      return ImagePickerCordinator(isShown: $isShown, image: $uiImage)
   }
func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
let picker = UIImagePickerController()
      picker.delegate = context.coordinator
      return picker
   }
}



// supporting class
class ImagePickerCordinator : NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    @Binding var isShown    : Bool
    @Binding var uiImage      : UIImage?
    
    init(isShown : Binding<Bool>, image: Binding<UIImage?>) {
        _isShown = isShown
        _uiImage   = image
    }
    
    //Selected Image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.uiImage = uiImage
        isShown = false
    }
    
    //Image selection got cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}

