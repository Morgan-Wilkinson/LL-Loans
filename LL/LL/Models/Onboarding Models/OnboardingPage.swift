//
//  OnboardingPage.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/26/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import Foundation

struct OnboardingPage: Identifiable {
    
    let id: UUID
    let image: String
    let heading: String
    let subSubheading: String
    
    static var getAll: [OnboardingPage] {
        [
            OnboardingPage(id: UUID(), image: "Overwhelmed-image", heading: "Form new habits", subSubheading: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna."),
            OnboardingPage(id: UUID(), image: "Person1-image", heading: "Keep track of your progress", subSubheading: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna.")
        ]
    }
}
