//
//  ShopView.swift
//  GroceryApp
//
//  Created by Viktor on 2023-11-09.
//

import SwiftUI

struct ShopView: View {
    
    @State var goToCart = false
    @EnvironmentObject private var cartManager: CartManager
    
    var columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading){
                Text("Good Morning!")
                    .foregroundStyle(.secondary)
                Text("Let's order some fresh Products for you")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .padding(.bottom, 20)
                Text("Products of the Today:")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
            }
            .padding(.top, 1)
            
            
            Spacer().frame(height:25)
            
            ScrollView() {
                LazyVGrid(columns: columns, spacing: 20){
                    
                    ForEach(productItem) { product in
                        ProductItemView(product: product)
                    }
                    
                }
                .padding()
                
            }
            .navigationDestination(isPresented: $goToCart) {
                CartView()
            }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button() {
                                goToCart = true
                            }label: {
                                
                                ZStack {
                                    Image(systemName: "cart")
                                    if cartManager.getTotalItems() > 0 {
                                        Circle()
                                            .fill(Color.blue)
                                            .frame(width: 20, height: 20)
                                            .overlay(
                                        Text("\(cartManager.getTotalItems())")
                                            .font(.caption)
                                            .foregroundStyle(.white)
                                            ).offset(x:10, y: -10)
                                    }
                                }
                            }
                        }
                    }
                
        }
        .navigationBarBackButtonHidden(true)
        
     
            
        }
    
}





#Preview {
    ShopView()
        .environmentObject(CartManager())
}
