//
//  PeopleForm.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/3/20.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI

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


struct PeopleForm_Previews: PreviewProvider {
    static var previews: some View {
        PeopleForm(isActive: .constant(false))
    }
}
