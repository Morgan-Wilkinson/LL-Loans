//
//  DebtToIncomeCalculator.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/18/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import Foundation

/** Debt to Income  Calculator. Mainly used to calculate the ratio of debt to income.

# Usage
This class is used mainly in the DebtToIncome View. It's purpose is to return the ratio of debt to income.

# Parameters
income: Double
debt: Double

# Code
 **Initilaiztion**
```
// More Code Here

let calculator = DebtToIncomeCalculator(income: Double, debt: Double)

// More Code Here
```

 **Data Calculation**

To revieve the the calculated data do the following:
```
// Mode Code Here

let calculator = DebtToIncomeCalculator(income: Double, debt: Double)
.
.
let result = calculator.Ratio()

// More Code Here
```

*/
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
