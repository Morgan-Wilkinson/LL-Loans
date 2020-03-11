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

    var value: Double
    var cornerRadius: CGFloat
    var width: Float
    var numberOfDataPoints: Int
    var index: Int = 0
    @State var scaleValue: Double = 0
    @Binding var touchLocation: CGFloat
    
    var cellWidth: Double {
        return Double(width)/(Double(numberOfDataPoints) * 1.5)
    }
    
    var body: some View {
        VStack {
            ZStack (alignment: .bottom) {
                RoundedRectangle(cornerRadius: self.cornerRadius).fill(LinearGradient(gradient: Gradient(colors: [.purple, .red, .blue]), startPoint: .top, endPoint: .bottom))
            }.frame(width: CGFloat(self.cellWidth))
                .scaleEffect(CGSize(width: 1, height: self.scaleValue), anchor: .bottom)
                .onAppear(){
                    self.scaleValue = self.value
                }
            .animation(Animation.spring().delay(self.touchLocation < 0 ?  Double(self.index) * 0.04 : 0))
        }
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView(value: 0.1, cornerRadius: 0, width: 320, numberOfDataPoints: 12, touchLocation: .constant(-1))
    }
}
