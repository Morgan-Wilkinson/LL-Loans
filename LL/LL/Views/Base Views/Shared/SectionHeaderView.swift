//
//  SectionHeaderView.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/19/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct SectionHeaderView: View {
    let text: String
    var icon: String?
    
    init(text: String, icon: String? = nil) {
        self.text = text
        self.icon = icon
    }
    
    var body: some View {
        HStack(spacing: 6) {
            if icon != nil {
                Image(systemName: icon!)
                    .imageScale(.medium)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.llHeaderText)
            }
            
            Text(LocalizedStringKey(text))
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.llHeaderText)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 14)
        .mask(RoundedRectangle(cornerRadius: 3, style: .continuous))
        .padding(.leading, -9)
        .padding(.bottom, -10)
    }
}

struct SectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeaderView(text: "Preview", icon: "questionmark.circle")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

