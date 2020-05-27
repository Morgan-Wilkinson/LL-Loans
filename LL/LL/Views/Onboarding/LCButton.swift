//
//  LCButton.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/26/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct LCButton: View {
    var text = "Next"
    var action: (()->()) = {}
    
    var body: some View {
      Button(action: {
        self.action()
      }) {
        HStack {
            Text(text)
                .bold()
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.vertical)
                .accentColor(Color.white)
                .background(Color.bigButton)
                .cornerRadius(10)
            }
        }
    }
}

struct LCButton_Previews: PreviewProvider {
    static var previews: some View {
        LCButton()
            .environment(\.colorScheme, .dark)
            //.previewLayout(.sizeThatFits)
    }
}
