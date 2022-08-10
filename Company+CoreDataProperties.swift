//
//  Company+CoreDataProperties.swift
//  CoreDataIntro
//
//  Created by Eduardo Ceron on 03/04/22.
//
//

import Foundation
import CoreData


extension Company {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Company> {
        return NSFetchRequest<Company>(entityName: "Company")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var sumaDeArticulos: Int32
    @NSManaged public var listCount: Int16
    @NSManaged public var employees: NSSet?
    @NSManaged public var timestamp: Date?
    
    public var unwrappedName: String {
        name ?? "Unknown name"
    }
    public var unwrappedDate: Date {
        timestamp ?? Date.now
    }
    
    public var employeesArray: [Employee] {
        let employeeSet = employees as? Set<Employee> ?? []
        
        return employeeSet.sorted {
            $0.unwrappedName < $1.unwrappedName
        }
    }
    
}

// MARK: Generated accessors for employees
extension Company {
    
    @objc(addEmployeesObject:)
    @NSManaged public func addToEmployees(_ value: Employee)
    
    @objc(removeEmployeesObject:)
    @NSManaged public func removeFromEmployees(_ value: Employee)
    
    @objc(addEmployees:)
    @NSManaged public func addToEmployees(_ values: NSSet)
    
    @objc(removeEmployees:)
    @NSManaged public func removeFromEmployees(_ values: NSSet)
    
}

extension Company : Identifiable {
    
}
