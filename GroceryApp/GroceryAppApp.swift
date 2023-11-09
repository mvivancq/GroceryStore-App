//
//  GroceryAppApp.swift
//  GroceryApp
//
//  Created by Viktor on 2023-11-09.
//

import SwiftUI

@main
struct GroceryAppApp: App {
    @EnvironmentObject private var cartManager: CartManager
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environmentObject(CartManager())
        }
    }
}
