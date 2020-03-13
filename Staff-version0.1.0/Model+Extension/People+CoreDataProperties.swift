//
//  People+CoreDataProperties.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/3/8.
//  Copyright © 2020 jas chen. All rights reserved.
//
//

import Foundation
import CoreData


extension People {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<People> {
        return NSFetchRequest<People>(entityName: "People")
    }

    @NSManaged public var bio: Data?
    @NSManaged public var count: Int64
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var relatedTask: NSSet?
    var relatedTasks: [Task]{
        guard let rt = relatedTask,
            let relatedTasks = Array(rt) as? [Task]
            else {return []}
        return relatedTasks
    }
}

// MARK: Generated accessors for relatedTask
extension People {

    @objc(addRelatedTaskObject:)
    @NSManaged public func addToRelatedTask(_ value: Task)

    @objc(removeRelatedTaskObject:)
    @NSManaged public func removeFromRelatedTask(_ value: Task)

    @objc(addRelatedTask:)
    @NSManaged public func addToRelatedTask(_ values: NSSet)

    @objc(removeRelatedTask:)
    @NSManaged public func removeFromRelatedTask(_ values: NSSet)

}
