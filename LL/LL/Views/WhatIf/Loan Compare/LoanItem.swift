//
//  LoanItem.swift
//  LL
//
//  Created by Morgan Wilkinson on 6/18/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

class LoanItem: ObservableObject, Identifiable, Equatable {
    static func == (lhs: LoanItem, rhs: LoanItem) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
    
    @Published var id: UUID
    @Published var name: Int
    @Published var interest: Double?
    @Published var months: Int?
    
    init(id: UUID, name: Int, interest: Double?, months: Int?) {
        self.id = id
        self.name = name
        self.interest = interest ?? nil
        self.months = months ?? nil
    }
}

class LoanCompareResults: ObservableObject, Identifiable {
    @Published var id: UUID
    @Published var name: Int
    @Published var monthlyInterestRate: Double?
    @Published var monthlyPayment: Double?
    @Published var totalInterest: Double?
    @Published var totalPayments: Double?
    
    init(id: UUID, name: Int, monthlyInterestRate: Double?, monthlyPayment: Double?, totalInterest: Double?, totalPayments: Double?) {
        self.id = id
        self.name = name
        self.monthlyInterestRate = monthlyInterestRate ?? nil
        self.monthlyPayment = monthlyPayment ?? nil
        self.totalInterest = totalInterest ?? nil
        self.totalPayments = totalPayments ?? nil
    }
}
