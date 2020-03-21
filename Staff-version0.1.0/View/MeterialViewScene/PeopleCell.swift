//
//  PeopleCell.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/3/20.
//  Copyright © 2020 jas chen. All rights reserved.
//

import SwiftUI

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
        ZStack{
            HStack{
                Image(uiImage: uiImage)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                    .scaledToFit()
                VStack(alignment: .leading){
                    Text(people.name ?? "无姓名").font(.headline).foregroundColor(.primary)
                    Spacer()
                    Text(people.phoneNumber ?? "无手机号码").font(.subheadline).foregroundColor(.secondary)
                }
            }.background(Color("cell_background"))
        }
    }
}
