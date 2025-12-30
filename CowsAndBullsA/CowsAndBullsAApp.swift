//
//  CowsAndBullsAApp.swift
//  CowsAndBullsA
//
//  Created by Weerawut on 30/12/2568 BE.
//

import SwiftUI

@main
struct CowsAndBullsAApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizability(.contentSize)
        
        Settings {
            SettingsView()
        }
    }
}
