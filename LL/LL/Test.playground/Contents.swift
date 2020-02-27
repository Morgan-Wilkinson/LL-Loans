import UIKit

var principal = 10000
var months = 24
var annualRate = 0.05
var perodicRate: Double = annualRate / Double(months)

principal/(((1+perodicRate)(months))-1)/(perodicRate(1+perodicRate)(months))

