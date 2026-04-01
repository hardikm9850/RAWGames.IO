//
//  RAWGamesApp.swift
//  RAWGames
//
//  Created by Hardik Mehta on 31/03/26.
//

import SwiftUI

@main
struct RAWGamesApp: App {
    
    // One container for the entire app lifetime
    @State private var container = DependencyContainer.shared
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(container)
        }
    }
}
