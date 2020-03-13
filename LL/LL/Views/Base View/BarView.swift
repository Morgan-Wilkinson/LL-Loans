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
    var width: Float
    var numberOfPoints: Int
    var cornerRadius: CGFloat
    var cellWidth: Double {
        return Double(width)/(Double(numberOfPoints) * 1.75)
    }
    
    @State var scaleValue: Double = 0
    
    var body: some View {
        VStack {
            ZStack (alignment: .bottom) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(LinearGradient(gradient: Gradient(colors: [.purple, .red, .blue]), startPoint: .top, endPoint: .bottom))
                    .frame(width: CGFloat(self.cellWidth))
                    .gesture(TapGesture().onEnded{print("\(self.value)")}) // Works
            }.padding(.bottom)
            .scaleEffect(CGSize(width: 1, height: self.scaleValue), anchor: .bottom)
            .onAppear() {
                self.scaleValue = Double(self.value)
            }
        }
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView(value: 0.9, width: 10, numberOfPoints: 12, cornerRadius: 0)
    }
}
