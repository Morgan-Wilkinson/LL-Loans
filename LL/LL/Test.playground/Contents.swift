import UIKit
import SwiftUI

//let formatter2 = DateFormatter()
//let calendar = Calendar.current
let date = Date()
let format = DateFormatter()
format.dateFormat = "MMM yy"

var lastMonthDate = Calendar.current.date(byAdding: .month, value: 12, to: date)
format.string(from: lastMonthDate!)
