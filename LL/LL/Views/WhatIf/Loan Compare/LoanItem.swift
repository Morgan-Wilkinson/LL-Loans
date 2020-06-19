//
//  LoanItem.swift
//  LL
//
//  Created by Morgan Wilkinson on 6/18/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI

struct LoanItem: Identifiable, Hashable {
    let id: Int
    var principal: String?
    var interest: String?
    var years: String?
    var months: String?
}
