//
//  HideKeyboardExtension.swift
//  CoreDataIntro
//
//  Created by Eduardo Ceron on 03/04/22.
//

import SwiftUI

#if canImport(UIKit)
extension View {
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
#endif
