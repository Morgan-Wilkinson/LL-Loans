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

/** Core Data Class for saved Loan Records.

 # Usage
 This class is used in the LL.xcdatamodeld as the companion class the attribute model in the Core Data scheme. A new instance of this class will be created when a new loan record is created in the LoanAdder View.
 
 # Parameters
 Class does not take any.
 
 # User Editable Variables
    - startDate
    - termMonths
    - interestRate
    - typeOfLoan
    - name
    - about
    - origin
  
**Note:** All other variables of this class can only be changed through system processes.
 
 # Code
  **Initilaiztion**
 ```
 // Needed imports
 import SwiftUI
 import CoreData
 
 // Needed Context
 @Environment(\.managedObjectContext) var managedObjectContext
 
 // Mode Code Here
 
 Loans(context: self.managedObjectContext)
 
 ```
 
  **Retrieval**
 
 To revieve the save Core Data of the Loans class call the Fetch Request
 ```
 // Needed imports
 import SwiftUI
 import CoreData
 
 // Mode Code Here
 
 @FetchRequest(entity: Loans.entity(), sortDescriptors: []) var loans: FetchedResults<Loans>
 ```
 
 */
public class Loans: NSManagedObject, Identifiable{
    
    @NSManaged public var willDelete: Bool
    @NSManaged public var startDate: Date
    @NSManaged public var termMonths: NSNumber
    @NSManaged public var interestRate: NSNumber
    @NSManaged public var originalPrincipal: NSNumber
    @NSManaged public var regularPayments: Double
    @NSManaged public var typeOfLoan: String
    @NSManaged public var name: String
    @NSManaged public var about: String
    @NSManaged public var origin: String
    
    // Big Arrays Holds All Values
    @NSManaged public var balanceArray: [Double]
    @NSManaged public var interestArray: [Double]
    @NSManaged public var principalArray: [Double]
    @NSManaged public var interestTotalsArray: [Double]
    // All Values and months.
    @NSManaged public var allValuesArray: [[Double]]
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
        request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
          
        return request
    }
}

