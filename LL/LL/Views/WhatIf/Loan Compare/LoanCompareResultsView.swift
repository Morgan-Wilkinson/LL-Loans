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
        @State var principal: Double
        @State var loans: [LoanItem]
        @State var loanResults: [LoanCompareResults]
        @State var maxWidth: CGFloat = 0
        
        
        public var body: some View {
            return List(){
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
                ForEach(0..<self.loanResults.count, id: \.self) { i in
                    CompareListRow(loanName: "\(self.loans[i].id)", monthlyPayment: self.loanResults[i].monthlyPayment!, principal: self.principal, interest: self.loanResults[i].totalInterest!, balance: self.loanResults[i].totalPayments!, maxWidth: self.$maxWidth)
                        .listRowBackground(i % 2 == 0 ?  Color.amortizationRow1 : Color.amortizationRow2)
                }
            }
            //.listStyle(GroupedListStyle())
            //.environment(\.horizontalSizeClass, .regular)
            
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
                    Text("\(self.loanName)")
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
        }
    }
}


struct LoanCompareResultsView_Previews: PreviewProvider {
    static var previews: some View {
        LoanCompareResultsView(principal: 1000.00, loans: [LoanItem(id: 0, interest: 5, years: 12, months: 3), LoanItem(id: 1, interest: 5, years: 12, months: 3)], loanResults: [LoanCompareResults(id: 0, monthlyInterestRate: 0.1, monthlyPayment: 100, totalInterest: 200, totalPayments: 300)])
    }
}

