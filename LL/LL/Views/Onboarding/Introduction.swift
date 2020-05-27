//
//  Introduction.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/26/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct Introduction: View {
    var page = OnboardingPage.getAll.first!
    
    var body: some View {
        VStack{
            Image(page.image)
            VStack{
                Text(page.heading).font(.title).bold().layoutPriority(1).multilineTextAlignment(.center)
                Text(page.subSubheading)
                    .multilineTextAlignment(.center)
            }.padding()
        }
    }
}

struct Introduction_Previews: PreviewProvider {
    static var previews: some View {
        Introduction()//.environment(\.colorScheme, .dark)
    }
}
