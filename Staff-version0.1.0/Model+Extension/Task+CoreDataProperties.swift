//
//  Task+CoreDataProperties.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/3/15.
//  Copyright © 2020 jas chen. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var completedTime: Date?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isComplete: Bool
    @NSManaged public var isAllocated:Bool
    @NSManaged public var notes: String?
    @NSManaged public var review: String?
    @NSManaged public var title: String?
    @NSManaged public var taskType: String?
    @NSManaged public var relateToPeople: NSSet?
    @NSManaged public var withTag: NSSet?
    // 任务的种类，-1位灵感，0位收件箱、1为已安排列表
    var tags: [Tag]{
        guard let withTag = withTag,
            let tags = Array(withTag) as? [Tag]
            else {return []}
        return tags
    }
    var peoples: [People]{
        guard let relateToPeople = relateToPeople,
            let peoples = Array(relateToPeople) as? [People]
            else {return []}
        return peoples
    }
    
}

// MARK: Generated accessors for relateToPeople
extension Task {

    @objc(addRelateToPeopleObject:)
    @NSManaged public func addToRelateToPeople(_ value: People)

    @objc(removeRelateToPeopleObject:)
    @NSManaged public func removeFromRelateToPeople(_ value: People)

    @objc(addRelateToPeople:)
    @NSManaged public func addToRelateToPeople(_ values: NSSet)

    @objc(removeRelateToPeople:)
    @NSManaged public func removeFromRelateToPeople(_ values: NSSet)

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
