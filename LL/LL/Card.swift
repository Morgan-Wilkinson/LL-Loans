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
    //var backgroundImage: Image
    var briefSummary: String
    var description: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.white)
            VStack {
                VStack(alignment: .leading) {
                    Text(subtitle)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(title)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                    
                    Text(briefSummary)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Divider() // Maybe say breakdown
                    Text(description)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding()
            
        }
        .padding()
        .shadow(radius: 10)
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Card(subtitle: "West Bank", title: "Loan A", briefSummary: "Next Payment - 24th June, 2020 for $124.95", description: "Principal: $64.95 \nInterest: $60.96 \nBalance: $12,000")
            Card(subtitle: "West Bank", title: "Loan A", briefSummary: "This is a test Loan", description: "This loan card is a sample from the testing data. If you see this then yoy are experiencing an error. Please reload the app or submit  a feedback form explaining the error.")
            Card(subtitle: "", title: "Loan A", briefSummary: "This is a test Loan", description: "")
        }
    }
}
