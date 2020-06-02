//
//  BookmarkSymbol.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/27/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct BookmarkSymbol: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = min((geometry.size.width), (geometry.size.height))
                let height = width * 0.75
                let spacing = width * 0.03
                let middle = width / 2
                let topWidth = 0.25 * width
                let bottomHeight = 1.25 * height
               
                // Top Middle
                path.move(to: CGPoint(x: middle, y: spacing))
                // Left Top Curve
                path.addQuadCurve(to: CGPoint(x: middle / 2, y: spacing * 8), control: CGPoint(x: (middle), y: spacing * 8))
                // Bottom Left
                path.addLine(to:CGPoint(x: middle - topWidth, y: bottomHeight))
                // Middle arrow
                path.addLine(to:CGPoint(x: middle, y: bottomHeight / 1.5 + spacing))
                // right bottom edge
                path.addLine(to:CGPoint(x: middle + topWidth, y: bottomHeight))
                // Right Top
                path.addLine(to:CGPoint(x: middle * 1.5, y: spacing))
            }.fill(LinearGradient(
                gradient: .init(colors: [.gradientStartSS, .gradientStartSS, .gradientStartSS, .gradientEndSS, .gradientEndSS]),
                startPoint: .leading,
                endPoint: .trailing
            ))
        }
    }
}

struct BookmarkSymbol_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkSymbol().environment(\.colorScheme, .dark)
        
    }
}
