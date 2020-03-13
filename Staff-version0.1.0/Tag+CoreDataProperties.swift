//
//  Tag+CoreDataProperties.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/2/26.
//  Copyright © 2020 jas chen. All rights reserved.
//
//

import Foundation
import CoreData

extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var colorName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?

}


