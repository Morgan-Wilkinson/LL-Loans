//
//  CompoundInterestCalculator.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/21/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import Foundation

class CompoundInterestCalculator {
    var prinicipal: Double
    var interest: Double
    var years: Double
    var compoundType: Double
    var variableInterestRate: Double
    let percentConvertor: Double = 100
    
    init(prinicipal: Double, interest: Double, years: Double, compoundType: Double) {
        self.prinicipal = prinicipal
        self.interest = interest
        self.years = years
        self.compoundType = compoundType
        variableInterestRate = (self.interest / percentConvertor) / Double(compoundType)
    }
    
    // https://www.calculatorsoup.com/calculators/financial/compound-interest-calculator.php
    // A = P(1 + r/n)^(nt)
    func getAccuredAmount() -> Double {
        let result = self.prinicipal * (pow((1 + self.variableInterestRate), (self.compoundType * self.years)))
        return result
    }
}
