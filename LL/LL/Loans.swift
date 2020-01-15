//
//  Loans.swift
//  LL
//
//  Created by Morgan Wilkinson on 1/7/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import Foundation
import CoreData

public class Loans: NSManagedObject, Identifiable{
    @NSManaged public var remainingMonths: Date?
    @NSManaged public var startDate: Date?
    @NSManaged public var nextDueDate: Date?
    @NSManaged public var prevDueDate: Date?
    @NSManaged public var currentDueDate: Date?
    @NSManaged public var termMonths: NSNumber?
    @NSManaged public var interestRate: NSNumber?
    @NSManaged public var currentPrincipal: NSNumber?
    @NSManaged public var originalPrincipal: NSNumber?
    @NSManaged public var name: String?
    @NSManaged public var about: String?
    @NSManaged public var id: UUID?
}

extension Loans {
    // ❇️ The @FetchRequest property wrapper in the ContentView will call this function
    static func allLoansFetchRequest() -> NSFetchRequest<Loans> {
        let request: NSFetchRequest<Loans> = Loans.fetchRequest() as! NSFetchRequest<Loans>
        
        // ❇️ The @FetchRequest property wrapper in the ContentView requires a sort descriptor
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
          
        return request
    }
}

