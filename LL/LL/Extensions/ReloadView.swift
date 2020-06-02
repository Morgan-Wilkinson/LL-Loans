//
//  ReloadApp.swift
//  LL
//
//  Created by Morgan Wilkinson on 6/2/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import Foundation

final class ReloadView : ObservableObject {
    @Published var reload = false {
        didSet {
            print("View reload: \(reload)")
        }
    }
}
