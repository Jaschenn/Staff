//
//  Tag+CoreDataProperties.swift
//  Staff-version0.1.0
//
//  Created by jas chen on 2020/3/16.
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
    @NSManaged public var byTask: NSSet?
    public var interrelatedTasks:[Task]{
        guard let byTask = byTask,
                let interrelatedTasks = Array(byTask) as? [Task]
            else {
                return []
        }
        return interrelatedTasks
        
    }
    
    
}

// MARK: Generated accessors for byTask
extension Tag {

    @objc(addByTaskObject:)
    @NSManaged public func addToByTask(_ value: Task)

    @objc(removeByTaskObject:)
    @NSManaged public func removeFromByTask(_ value: Task)

    @objc(addByTask:)
    @NSManaged public func addToByTask(_ values: NSSet)

    @objc(removeByTask:)
    @NSManaged public func removeFromByTask(_ values: NSSet)

}
