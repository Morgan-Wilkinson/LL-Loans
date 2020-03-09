import UIKit
import SwiftUI

var principal: NSNumber = 10000
var months: NSNumber = 24
var annualRate: NSNumber = 0.1

// P = prinicpal[monthlyIntRate(1 + monthlyIntRate)^n]/[(1 + monthlyIntRate^n - 1]

var ann = Double(truncating: (annualRate))
var prin = Double(truncating: (principal))
var monthsNum = Int(truncating: months)
var monthlyIntRate = ann / 12

var power = Double(truncating: pow((Decimal)(1 + monthlyIntRate), monthsNum) as NSNumber)
var numerator = prin * (monthlyIntRate * power)
let denominator = power - 1

let roundedMonthly = ((numerator / denominator) * 100).rounded() / 100

// B = L[(1 + c)n - (1 + c)p]/[(1 + c)n - 1]

var power2 = Double(truncating: pow((Decimal)(1 + monthlyIntRate), monthsNum) as NSNumber)
var Ppower3 = Double(truncating: pow((Decimal)(1 + monthlyIntRate), 5) as NSNumber) // 5 months left
var numerator2 = prin * (power - Ppower3)
var denominator2 = power2 - 1

let roundedMonthly2 = ((numerator2 / denominator2) * 100).rounded() / 100
