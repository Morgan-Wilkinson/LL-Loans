//
//  CubeSymbol.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/28/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct CubeSymbol: View {
    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(AngularGradient(gradient: Gradient(colors: [ Self.gradientStart, Self.gradientMiddle, Self.gradientMiddle2, .black]), center: .bottomTrailing))
                .aspectRatio(1, contentMode: .fit)
                .padding()
            
        }
    }
    static let gradientMiddle = Color(red: 5.0 / 255, green: 121.0 / 255, blue: 128.0 / 255)
    static let gradientMiddle2 = Color(red: 12.0 / 255, green: 60.0 / 255, blue: 62.0 / 255)
    static let gradientStart = Color(red: 27.0 / 255, green: 96.0 / 255, blue: 100.0 / 255)
}

struct CubeSymbol_Previews: PreviewProvider {
    static var previews: some View {
        CubeSymbol()
    }
}
