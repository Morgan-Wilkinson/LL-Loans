//
//  SimpleRow.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/10/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct SimpleRow: View {
    var subtitle: String?
    var bodyText: String
    var footer: String?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(Color.white)
                //VStack {
                    VStack(alignment: .leading) {
                        Text("\(self.subtitle ?? "")")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                        
                        Text("\(self.bodyText)")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                        
                        Text("\(self.footer ?? "")")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                    }.frame(width: geometry.size.width ,height: geometry.size.height)
                    //Spacer()
                //}
                
                
            }
            .frame(height: geometry.size.height / 10)
            .padding()
            .shadow(radius: 10)
        }
    }
}

struct SimpleRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            SimpleRow(subtitle: "This is a subheader", bodyText: "This is the body", footer: "This is the footer")
            SimpleRow(subtitle: "This is a subheader", bodyText: "This is the body", footer: "This is the footer")
            SimpleRow(subtitle: "This is a subheader", bodyText: "This is the body", footer: "This is the footer")
            SimpleRow(subtitle: "This is a subheader", bodyText: "This is the body", footer: "This is the footer")
            SimpleRow(subtitle: "This is a subheader", bodyText: "This is the body", footer: "This is the footer")
            SimpleRow(subtitle: "This is a subheader", bodyText: "This is the body", footer: "This is the footer")
        }
    }
}
