//
//  AdaptsToSoftwareKeyboard.swift
//  LL
//
//  Created by Morgan Wilkinson on 5/29/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import SwiftUI
import Combine

// See https://gist.github.com/scottmatthewman/722987c9ad40f852e2b6a185f390f88d
struct AdaptsToSoftwareKeyboard: ViewModifier {
    @State var currentHeight: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(.bottom, currentHeight)
            .edgesIgnoringSafeArea(currentHeight == 0 ? [] : .bottom)
            .onAppear(perform: subscribeToKeyboardEvents)
        }

    private func subscribeToKeyboardEvents() {
      NotificationCenter.Publisher(
        center: NotificationCenter.default,
        name: UIResponder.keyboardWillShowNotification
      ).compactMap { notification in
          notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect
      }.map { rect in
        rect.height
      }.subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))

      NotificationCenter.Publisher(
        center: NotificationCenter.default,
        name: UIResponder.keyboardWillHideNotification
      ).compactMap { notification in
        CGFloat.zero
      }.subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
    }
}

extension View {
    var keyboardAware: some View {
        self.modifier(AdaptsToSoftwareKeyboard())
    }
}
