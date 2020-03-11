//
//  BarView.swift
//  LL
//
//  Created by Morgan Wilkinson on 3/10/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import Foundation
import SwiftUI

struct BarView: View {

    var value: CGFloat
    var length: CGFloat
    var cornerRadius: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack (alignment: .bottom) {
                    RoundedRectangle(cornerRadius: self.cornerRadius)
                        .frame(width: self.length / geometry.size.width, height: 200).foregroundColor(.clear)
                    RoundedRectangle(cornerRadius: self.cornerRadius).fill(LinearGradient(gradient: Gradient(colors: [.purple, .red, .blue]), startPoint: .top, endPoint: .bottom))
                        .frame(width: self.length / geometry.size.width, height: (geometry.size.height.truncatingRemainder(dividingBy: self.value)))
                    
                }.padding(.bottom, 8)
            }
        }
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView(value: 200, length: 25, cornerRadius: 10)
    }
}
