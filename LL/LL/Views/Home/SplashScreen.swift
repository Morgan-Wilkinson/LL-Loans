//
//  SplashScreen.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/27/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct SplashScreen: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Loans.entity(), sortDescriptors: []) var loans: FetchedResults<Loans>
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                VStack{
                    Spacer()
                    BookmarkSymbol()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 100, height: 100, alignment: .center)
                    Spacer()
                    Text("Loan Record")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                }
            }.padding()
            .frame(width: geometry.size.width, height: geometry.size.height)
        }.background(Color.splashScreen)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            for loan in self.loans {
                if loan.willDelete {
                    self.deleteLoans(loan: loan)
                }
            }
        }
    }
    
    func deleteLoans(loan: Loans) {
        
        self.managedObjectContext.delete(loan)
        
        try? self.managedObjectContext.save()
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()//.environment(\.colorScheme, .dark)
    }
}
