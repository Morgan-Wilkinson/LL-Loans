//
//  LoanCompareResultsView.swift
//  LL
//
//  Created by Morgan Wilkinson on 6/19/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct LoanCompareResultsView: View {
    let valueSpecifier: String = "%.2f"
    @Binding var principal: Double
    var loanResults: [LoanCompareResults]
    @State var maxWidth: CGFloat = 0
    
    public var body: some View {
        return Group {
            GeometryReader { geometry in
                HStack(){
                    Group {
                        Text("#")
                            .fontWeight(.regular)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .frame(width: self.maxWidth)
                        Divider()
                        Spacer()
                    }.onAppear(perform: {self.maxWidth = geometry.size.width / 6})
                    
                    Group{
                        Text("Monthly Payment")
                            .fontWeight(.regular)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .frame(width: self.maxWidth)
                        Divider()
                        Spacer()
                    }
                    
                    Group{
                        Text("Principal")
                            .fontWeight(.regular)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .frame(width: self.maxWidth)
                        Divider()
                        Spacer()
                    }
                    
                    Group{
                        Text("Total Interest")
                            .fontWeight(.regular)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .frame(width: self.maxWidth)
                        Divider()
                        Spacer()
                    }
                    
                    Group{
                        Text("Total Cost")
                            .fontWeight(.regular)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .frame(width: self.maxWidth)
                        Spacer()
                    }
                }
            }
            ForEach(self.loanResults) { loan in
                CompareListRow(loanName: "\(loan.name)", monthlyPayment: loan.monthlyPayment!, principal: self.principal, interest: loan.totalInterest!, balance: loan.totalPayments!, maxWidth: self.$maxWidth)
                    .listRowBackground(loan.name % 2 == 0 ?  Color.amortizationRow1 : Color.amortizationRow2)
            }
        }
    }
}

struct CompareListRow: View {
    var loanName: String
    var monthlyPayment: Double
    var principal: Double
    var interest: Double
    var balance: Double
    var valueSpecifier: String = "%.2f"
    @Binding var maxWidth: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            HStack{
                Group {
                    Text("Loan \(self.loanName)")
                        .fontWeight(.regular)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(width: self.maxWidth)
                    Divider()
                    Spacer()
                }
                
                Group{
                    Text("\(self.monthlyPayment, specifier: self.valueSpecifier)")
                        .fontWeight(.regular)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(width: self.maxWidth)
                    Divider()
                    Spacer()
                }
                
                Group{
                    Text("\(self.principal, specifier: self.valueSpecifier)")
                        .fontWeight(.regular)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(width: self.maxWidth)
                    Divider()
                    Spacer()
                }
                
                Group{
                    Text("\(self.interest, specifier: self.valueSpecifier)")
                        .fontWeight(.regular)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(width: self.maxWidth)
                    Divider()
                    Spacer()
                }
                
                Group{
                    Text("\(self.balance, specifier: self.valueSpecifier)")
                        .fontWeight(.regular)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(width: self.maxWidth)
                    Spacer()
                }
            }
            .foregroundColor(Color.black)
        }
    }
}

struct LoanCompareResultsView_Previews: PreviewProvider {
    static var previews: some View {
        LoanCompareResultsView(principal: .constant(1000.00), loanResults: [LoanCompareResults(id: UUID(), name: 0, monthlyInterestRate: 0.1, monthlyPayment: 100, totalInterest: 200, totalPayments: 300)])
    }
}

