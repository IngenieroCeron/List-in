//
//  Constant.swift
//  CoreDataIntro
//
//  Created by Eduardo Ceron on 03/04/22.
//

import SwiftUI

// MARK: - FORMATTER

let itemFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .short
  formatter.timeStyle = .medium
  return formatter
}()

// MARK: - UI

var backgroundGradient: LinearGradient {
  return LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
}

// MARK: - UX

let feedback = UINotificationFeedbackGenerator()

// Mark - Premium

let productID = "com.eduardoceron.CoreDataIntroRoster.PremiumListin"
