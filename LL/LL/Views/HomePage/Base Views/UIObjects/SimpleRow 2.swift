//
//  SimpleRow.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/10/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct SimpleRow: View {
    var name: String
    var loanType: String
    var origin: String
    var startDate: Date
    var dueAmount: Double
    var currentDueDate: String
    let valueSpecifier: String = "%.2f"
    let dateFormatter = DateFormatter()
    
    init(name: String, loanType: String, origin: String, startDate: Date, dueAmount: Double){
        self.name = name
        self.loanType = loanType
        self.origin = origin
        self.startDate = startDate
        self.dueAmount = dueAmount
        
        dateFormatter.dateStyle = .long
        dateFormatter.dateFormat = "MMMM d, y"
        
        let currentMonthIndex = Calendar.current.dateComponents([.month, .day], from: startDate, to: Date()).month!
        self.currentDueDate = dateFormatter.string(from: (Calendar.current.date(byAdding: .month, value: currentMonthIndex + 1, to: startDate)!))
    }
        
    var body: some View {
        ZStack {
            VStack {
                VStack(alignment: .leading) {
                    HStack{
                        Text(loanType)
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        Spacer()
                        Text(origin)
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }.padding(.bottom, 5.0)
                    Group{
                        HStack{
                            VStack(alignment: .leading) {
                                Text(name)
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                    .font(.system(size: 25))
                                Text(dateFormatter.string(from: startDate))
                                    .font(.footnote)
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                            }
                            Spacer()
                            
                            Text("\(dueAmount, specifier: valueSpecifier)")
                                .fontWeight(.bold)
                                .font(.headline)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .padding(5)
                                .foregroundColor(.accentColor)
                                .padding(5)
                        }
                    }
                    Divider()
                    Group{
                        HStack{
                            Text("Pay Day")
                                .font(.headline)
                                .foregroundColor(.accentColor)
                            
                            Spacer()
                            
                            Text(currentDueDate)
                                .fontWeight(.bold)
                                .font(.headline)
                                .padding(5)
                                .foregroundColor(.accentColor)
                                .padding(5)
                        }
                    }
                }
            }.padding()
        }
    }
}

struct SimpleRow_Previews: PreviewProvider {
    static var previews: some View {
        List{
            SimpleRow(name: "This is the footer", loanType: "Student", origin: "West Bank", startDate: Date() -  15632561, dueAmount: 1000.00)
            SimpleRow(name: "This is the footer", loanType: "Student", origin: "West Bank", startDate: Date() - 10000, dueAmount: 1000.00)
            SimpleRow(name: "This is the footer", loanType: "Student", origin: "West Bank", startDate: Date() - 10000, dueAmount: 1000.00)
        }
    }
}
