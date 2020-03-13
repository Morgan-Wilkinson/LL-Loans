//
//  ChartRow.swift
//  ChartView
//
//  Created by András Samu on 2019. 06. 12..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

public struct BarChartRow : View {
    //@Binding var data: [Double]
    var data: [Double]
    @Binding var normalizedData: [Double]
    var accentColor: Color
    var gradient: GradientColor?
    var maxValue: Double {
        data.max() ?? 0
    }
    @Binding var touchLocation: CGFloat
    public var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: (geometry.frame(in: .local).width-22)/CGFloat(self.normalizedData.count * 3)){
                ForEach(0..<self.normalizedData.count, id: \.self) { i in
                    BarChartCell(value: self.$normalizedData[i],
                                 index: i,
                                 width: Float(geometry.frame(in: .local).width - 22),
                                 numberOfDataPoints: self.normalizedData.count,
                                 accentColor: self.accentColor,
                                 gradient: self.gradient,
                                 touchLocation: self.$touchLocation)
                        .scaleEffect(self.touchLocation > CGFloat(i)/CGFloat(self.normalizedData.count) && self.touchLocation < CGFloat(i+1)/CGFloat(self.normalizedData.count) ? CGSize(width: 1.4, height: 1.1) : CGSize(width: 1, height: 1), anchor: .bottom)
                        .animation(.spring())
                    
                }
            }
            .padding([.top, .leading, .trailing], 10)
        }
    }
    
    func normalizedValue(index: Int) -> Double {
        print(self.data[index])
        return Double(self.data[index])/Double(self.maxValue)
    }
}

#if DEBUG
struct ChartRow_Previews : PreviewProvider {
    static var previews: some View {
        //BarChartRow(data: .constant([8.0,23.0,54.0,32.0,12.0,37.0,7.0]), accentColor: Colors.OrangeStart, touchLocation: .constant(-1))
        
        BarChartRow(data: [8.0, 23.0, 54.0], normalizedData: .constant([0.03, 0.7, 0.25]), accentColor: Colors.OrangeStart, touchLocation: .constant(-1))
    }
}
#endif
