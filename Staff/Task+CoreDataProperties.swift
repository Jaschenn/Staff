//
//  Task+CoreDataProperties.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/2/26.
//  Copyright © 2020 jas chen. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var date: Date?
    @NSManaged public var completedTime: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isComplete: Bool
    @NSManaged public var notes: String?
    @NSManaged public var review: String?
    @NSManaged public var title: String?
    @NSManaged public var withTag: NSSet?
    @NSManaged public var taskType: String?
    
    
}

// MARK: Generated accessors for withTag
extension Task {

    @objc(addWithTagObject:)
    @NSManaged public func addToWithTag(_ value: Tag)

    @objc(removeWithTagObject:)
    @NSManaged public func removeFromWithTag(_ value: Tag)

    @objc(addWithTag:)
    @NSManaged public func addToWithTag(_ values: NSSet)

    @objc(removeWithTag:)
    @NSManaged public func removeFromWithTag(_ values: NSSet)

}
