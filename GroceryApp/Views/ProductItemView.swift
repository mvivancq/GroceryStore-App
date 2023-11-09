//
//  ProductItemView.swift
//  GroceryApp
//
//  Created by Viktor on 2023-11-09.
//

import SwiftUI
import Foundation

struct ProductItemView: View {
    
    @State var product: Product
    @EnvironmentObject var cartManager: CartManager
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(product.color)
                    .frame(width: 170, height: 230)
                    .opacity(0.25)
                    .shadow(radius: 5)// Set the desired width and height for your product card
                
                VStack {
                    Image(product.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100) // Set the desired image size
                    
                    Text(product.name)
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Button(action: {
                        cartManager.addToCart(product: product)
                        let itemAdded = UIImpactFeedbackGenerator(style: .soft)
                        itemAdded.impactOccurred()
                        print("Item added to cart: \(product.name)")
                    }){
                        
                            Text("$\(String(format: "%.2f", product.price))")
                            .font(.subheadline.bold())
                                .foregroundColor(.white)
                                .frame(width: 100, height: 40)
                                .background(product.color)
                        }
                    }
                }
            }
            
        }
    

struct ProductItemView_Previews: PreviewProvider {
    static var previews: some View {
        ProductItemView(product: productItem[1])
            .environmentObject(CartManager())
    }
}
