//
//  Person+CoreDataProperties.swift
//  CRUD-Label-Image
//
//  Created by Shivam Pandya on 28/04/23.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var photo: Data?

}

extension Person : Identifiable {

}
