//
//  Loans.swift
//  LL
//
//  Created by Morgan Wilkinson on 1/7/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI
import Combine

public class Loans: NSManagedObject, Identifiable{
    
    @NSManaged public var startDate: Date
    @NSManaged public var termMonths: NSNumber
    @NSManaged public var interestRate: NSNumber
    @NSManaged public var originalPrincipal: NSNumber
    @NSManaged public var regularPayments: Double
    @NSManaged public var typeOfLoan: String
    @NSManaged public var name: String
    @NSManaged public var about: String
    @NSManaged public var origin: String
    
    // Unique ID
    //@NSManaged public var id: UUID
    
    // Big Arrays Holds All Values
    @NSManaged public var balanceArray: [Double]
    @NSManaged public var interestArray: [Double]
    @NSManaged public var principalArray: [Double]
    @NSManaged public var interestTotalsArray: [Double]
    @NSManaged public var monthsSeries: [String]
    
    // Small Arrays
    @NSManaged public var smallBalanceArray: [Double]
    @NSManaged public var smallInterestArray: [Double]
    @NSManaged public var smallPrincipalArray: [Double]
    @NSManaged public var smallMonthsSeries: [String]
    
    // All 3 Small arrays
    @NSManaged public var allThreeSmallArray: [[Double]]
    // all 3 small array values normilzed
    @NSManaged public var normalizedValueArray: [[Double]]
}

extension Loans {
    // The @FetchRequest property wrapper in the ContentView will call this function
    static func allLoansFetchRequest() -> NSFetchRequest<Loans> {
        let request: NSFetchRequest<Loans> = Loans.fetchRequest() as! NSFetchRequest<Loans>
        
        // The @FetchRequest property wrapper in the ContentView requires a sort descriptor
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
          
        return request
    }
}

