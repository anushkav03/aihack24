//
//  Stress_PenguinApp.swift
//  Stress Penguin
//
//  Created by Mishtu on 23/6/24.
//

import SwiftUI
import SwiftUI

extension Color {
    static let peach = Color(red: 1.0, green: 0.85, blue: 0.70)
    static let softPink = Color(red: 0.85, green: 0.5, blue: 0.5)
    static let darkPeach = Color(red: 0.85, green: 0.5, blue: 0.5)
}

@main
struct Stress_PenguinApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                LoadingView()
            }
        }
    }
}
