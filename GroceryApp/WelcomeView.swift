//
//  ContentView.swift
//  GroceryApp
//
//  Created by Viktor on 2023-11-09.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var cartManager: CartManager
    @State private var navigateToShopView = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Image("avocado")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350)
                        .padding(30)
                    
                    VStack(alignment: .center) {
                        Text("WELCOME")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                        
                        Text("To your local store")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .padding(.bottom)
                        
                        Text("Get your fresh products with us Today!")
                            .foregroundStyle(.secondary)
                            .padding(.bottom, 50)
                    }
                    .frame(width: 350)
                    
                    NavigationLink(destination: ShopView(), isActive: $navigateToShopView) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 50)
                                .foregroundColor(.pink)
                            Text("Go To Store")
                                .foregroundColor(.white)
                        }
                        .frame(width: 250, height: 50)
                    }
                    .padding()
                    .simultaneousGesture(TapGesture().onEnded {
                        navigateToShopView = true
                    })
                }
            }
            
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environmentObject(CartManager())
    }
}
