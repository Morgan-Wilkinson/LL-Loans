//
//  CardChart.swift
//  LL
//
//  Created by Morgan Wilkinson on 3/10/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct BarRow: View {
    @ObservedObject var loan: Loans
    @State var pickerSelection: Int
    @Binding var touchLocation: CGFloat
    var currentMonthIndex: Int
   
    public var body: some View {
        let smallThree = self.loan.allThreeSmallArray[self.pickerSelection]
        
        return GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: (geometry.frame(in: .local).width-22)/CGFloat(self.loan.allThreeSmallArray[self.pickerSelection].count * 3)){
                ForEach(0..<self.loan.allThreeSmallArray[self.pickerSelection].count, id: \.self) { i in
                    BarCell(currentMonth: self.currentMonthIndex, value: self.loan.normalizedValueArray[self.pickerSelection][i],
                            index: i,
                            width: Float(geometry.frame(in: .local).width - 22),
                            numberOfDataPoints: self.loan.allThreeSmallArray[self.pickerSelection].count,
                            touchLocation: self.$touchLocation)
                        .scaleEffect(self.touchLocation > CGFloat(i)/CGFloat(self.loan.allThreeSmallArray[self.pickerSelection].count) && self.touchLocation < CGFloat(i+1)/CGFloat(self.loan.allThreeSmallArray[self.pickerSelection].count) ? CGSize(width: 1.4, height: 1.1) : CGSize(width: 1, height: 1), anchor: .bottom)
                        .animation(.spring())
                }// Fix it in the cell
            }
            .padding([.top, .leading, .trailing], 10)
        }
    }
}

/*
struct BarRow_Previews: PreviewProvider {
    static var previews: some View {
        BarRow(currentMonthIndex: 4, data: [8,23,54,32,12,37,7], touchLocation: .constant(-1))
    }
}
*/
