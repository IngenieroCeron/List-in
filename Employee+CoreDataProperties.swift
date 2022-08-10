//
//  Employee+CoreDataProperties.swift
//  CoreDataIntro
//
//  Created by Eduardo Ceron on 03/04/22.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var completion: Bool
    @NSManaged public var name: String?
    @NSManaged public var monto: String?
    @NSManaged public var company: Company?
    @NSManaged public var timestamp: Date?
    
    public var unwrappedName: String {
            name ?? "Unknown name"
    }
    public var unwrappedMonto: String {
        monto ?? "Unknown monto"
    }

}

extension Employee : Identifiable {

}
