//
//  LoanItem.swift
//  LL
//
//  Created by Morgan Wilkinson on 6/18/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct LoanItem: Identifiable, Hashable {
    let id: Int
    var interest: Double?
    var years: Double?
    var months: Int?
}

struct LoanCompareResults: Identifiable, Hashable {
    let id: Int
    var monthlyInterestRate: Double?
    var monthlyPayment: Double?
    var totalInterest: Double?
    var totalPayments: Double?
}
