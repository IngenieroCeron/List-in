//
//  CoreDataIntroApp.swift
//  CoreDataIntro
//
//  Created by Eduardo Ceron on 03/04/22.
//

import SwiftUI
import FirebaseCore
import StoreKit

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct CoreDataIntroApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    let persistenceController = PersistenceController.shared
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Esto lo agregué por el tutorial de youtube de blue-berry y lemon-berry
    // @StateObject private var store = Store()
    
    @StateObject private var storeViewModel = StoreViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            // Esto lo agregué por el tutorial de youtube de blue-berry y lemon-berry
                .environmentObject(storeViewModel)
            // -------------------
                .environment(\.managedObjectContext, persistenceController.viewContext)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }.onChange(of: scenePhase) { _ in
            persistenceController.saveContext()
        }
    }
}
