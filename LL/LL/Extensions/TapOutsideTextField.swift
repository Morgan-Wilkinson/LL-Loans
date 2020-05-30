//
//  TapOutsideTextField.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/29/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

extension View {
    func endEditing(_ force: Bool) {
        UIApplication.shared.windows.forEach { $0.endEditing(force)}
    }
}
