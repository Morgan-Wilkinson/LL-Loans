//
//  Card.swift
//  LL
//
//  Created by Morgan Wilkinson on 3/8/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct Card: View {
    var subtitle: String
    var title: String
    var overview: String
    var briefSummary: String
    var description: String?
    var month: String
    let textColor = Color("Text")
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack{
                    Text("Payment's At A Glance")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                    Spacer()
                    Text("\(subtitle)")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                }
                Text(title)
                    .font(.title)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                Text(overview)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
                
                Divider()
                Text("Payment Breakdown")
                    .font(.headline)
                    .foregroundColor(.accentColor)
                Text(briefSummary)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(textColor)
                
                if description?.isEmpty != true {
                    Divider()// Maybe say breakdown
                    Text(description!)
                        .font(.footnote)
                        .foregroundColor(textColor)
                }
            }
            Spacer()
        }
        .padding()
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Card(subtitle: "Test", title: "Loan A", overview: "Overview", briefSummary: "Next Payment - 24th June, 2020 for $124.95", description: "Principal: $64.95 \nInterest: $60.96 \nBalance: $12,000", month: "Jan")
            Card(subtitle: "", title: "Loan A", overview: "Overview", briefSummary: "This is a test Loan", description: "This loan card is a sample from the testing data. If you see this then yoy are experiencing an error. Please reload the app or submit  a feedback form explaining the error.", month: "April")
            Card(subtitle: "You", title: "Loan A", overview: "Overview", briefSummary: "This is a test Loan", description: "", month: "March")
        }
    }
}
