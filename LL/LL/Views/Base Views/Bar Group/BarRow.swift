//
//  CardChart.swift
//  LL
//
//  Created by Morgan Wilkinson on 3/10/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct BarRow: View {
    
    @Binding var data: [Double]
    var maxValue: Double {
        data.max() ?? 0
    }
    @Binding var touchLocation: CGFloat
    public var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: (geometry.frame(in: .local).width-22)/CGFloat(self.data.count * 3)){
                ForEach(0..<self.data.count, id: \.self) { i in
                    BarCell(value: self.normalizedValue(index: i),
                            index: i,
                            width: Float(geometry.frame(in: .local).width - 22),
                            numberOfDataPoints: self.data.count,
                            touchLocation: self.$touchLocation)
                        .scaleEffect(self.touchLocation > CGFloat(i)/CGFloat(self.data.count) && self.touchLocation < CGFloat(i+1)/CGFloat(self.data.count) ? CGSize(width: 1.4, height: 1.1) : CGSize(width: 1, height: 1), anchor: .bottom)
                        .animation(.spring())
                    
                }
            }
            .padding([.top, .leading, .trailing], 10)
        }
    }
    
    func normalizedValue(index: Int) -> Double {
        if (self.data[index] == 0 || self.maxValue == 0){
            return 0
        }
        else {
            return Double(self.data[index])/Double(self.maxValue)
        }
    }
}

struct BarRow_Previews: PreviewProvider {
    static var previews: some View {
        BarRow(data: .constant([8,23,54,32,12,37,7]), touchLocation: .constant(-1))
    }
}

/*
 RoundedRectangle(cornerRadius: 25, style: .continuous)
 .fill(Color.white)
 */
