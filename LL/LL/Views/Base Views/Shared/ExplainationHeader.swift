//
//  ExplainationHeader.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/20/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct ExplainationHeader: View{
    var title: String
    var nameIcon: String?
    var moreInfoIcon: String?
    var explanation: String?
    let textBoxColor = Color("TextFieldBox")
    
    var body: some View{
        HStack {
            HStack(spacing: 6) {
                if nameIcon != nil {
                    Image(systemName: nameIcon!)
                        .imageScale(.medium)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.llHeaderText)
                }
                
                Text(LocalizedStringKey(title))
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.llHeaderText)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 14)
            .mask(RoundedRectangle(cornerRadius: 3, style: .continuous))
            .padding(.leading, -9)
            .padding(.bottom, -10)
            
            Spacer()
            // Choose different icon for exclamiation
            HStack {
                if explanation?.isEmpty == false {
                    Image(systemName: moreInfoIcon!)
                        .foregroundColor(.accentColor)
                        .imageScale(.large)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 15)
                        .mask(RoundedRectangle(cornerRadius: 3, style: .continuous))
                        .contextMenu{
                            Text(explanation!)
                                .font(.headline)
                                .foregroundColor(.accentColor)
                        }
                }
            }
            .padding(.leading, -9)
        }.listRowInsets(EdgeInsets())
        .buttonStyle(PlainButtonStyle())

    }
}

struct ExplainationHeader_Previews: PreviewProvider {
    static var previews: some View {
        ExplainationHeader(title: "Origin", nameIcon: "globe", moreInfoIcon: "questionmark.circle", explanation: "Where is the loan from?")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

// Old Design
/*
 if nameIcon?.isEmpty == false{
     Image(systemName: nameIcon!)
         .foregroundColor(.accentColor)
         .imageScale(.medium)
         .padding(.leading)
     Text(title)
         .font(.headline)
         .foregroundColor(.accentColor)
         .padding([.top, .bottom, .trailing])
 }
 else{
     Text(title)
         .font(.headline)
         .foregroundColor(.accentColor)
         .padding()
 }
 */
