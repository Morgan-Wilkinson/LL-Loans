//
//  DebtToIncomeCalculator.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/18/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import Foundation

class DebtToIncomeCalculator {
    var income: Double
    var debt: Double
    
    init (income: Double, debt: Double) {
        self.income = income
        self.debt = debt
    }
    
    func Ratio() -> Int {
        let result = Int((self.debt / self.income) * 100)
        
        return result
    }
}
