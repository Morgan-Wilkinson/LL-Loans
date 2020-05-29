//
//  SplashScreen.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/27/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                VStack{
                    Spacer()
                    BookmarkSymbol()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 100, height: 100, alignment: .center)
                    Spacer()
                    Text("LL: Loans")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                }
            }.padding()
            .frame(width: geometry.size.width, height: geometry.size.height)
        }.background(Color.splashScreen)
        .edgesIgnoringSafeArea(.all)
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()//.environment(\.colorScheme, .dark)
    }
}
