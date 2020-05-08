//
//  BarView.swift
//  LL
//
//  Created by Morgan Wilkinson on 3/10/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import Foundation
import SwiftUI

struct BarCell: View {
    var currentMonth: Int
    var value: Double
    var index: Int = 0
    var width: Float
    var numberOfDataPoints: Int
    var cellWidth: Double {
        return Double(width)/(Double(numberOfDataPoints) * 1.5)
    }
    
    @State var scaleValue: Double = 0
    @Binding var touchLocation: CGFloat
    
    public var body: some View {
        let gradientColor: LinearGradient = index == currentMonth ? LinearGradient(gradient: Gradient(colors: [.orange, .yellow, .blue, .purple]), startPoint: .top, endPoint: .bottom): LinearGradient(gradient: Gradient(colors: [.purple, .red, .blue]), startPoint: .top, endPoint: .bottom)
        return ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(gradientColor)
            }
            .frame(width: CGFloat(self.cellWidth))
            .scaleEffect(CGSize(width: 1, height: self.scaleValue), anchor: .bottom)
            .onAppear(){
                self.scaleValue = self.value
            }
        .animation(Animation.spring().delay(self.touchLocation < 0 ?  Double(self.index) * 0.04 : 0))
    }
}

struct BarCell_Previews: PreviewProvider {
    static var previews: some View {
        BarCell(currentMonth: 4, value: Double(0.75), width: 320, numberOfDataPoints: 12, touchLocation: .constant(-1))
    }
}
