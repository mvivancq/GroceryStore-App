//
//  CartView.swift
//  GroceryApp
//
//  Created by Viktor on 2023-11-09.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject private var cartManager: CartManager
    @State private var isDeleteAllAlertPresented = false
    
    var body: some View {
        NavigationView {
            VStack{
                List {
                    ForEach(cartManager.cartItems, id: \.product.id) { cartItem in
                        HStack {
                            Image(cartItem.product.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                            VStack(alignment: .leading) {
                                HStack{
                                    Text("\(cartItem.product.name)")
                                        .font(.headline)
                                    Spacer()
                                    Text("Items: \(cartManager.getTotalQuantity(for: cartItem.product))")
                                        .font(.subheadline)
                                        
                                }
                                HStack{
                                    Text("Total Price:")
                                        .font(.subheadline)
                                    Spacer()
                                    Text(" $\(cartManager.getTotalPrice(for: cartItem.product), specifier: "%.2f")")
                                        .font(.headline)
                                        
                                }
                             
                            }
                        }
                    }
                    .onDelete { indices in
                        cartManager.cartItems
                            .remove(atOffsets: indices)
                        cartManager.saveItems()
                        
                    }
                }
                .listStyle(PlainListStyle())

                
                Spacer()
                
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.green)
                        .opacity(0.7)
                        .frame(width: 380, height: 120)
                    
                    HStack {
                        VStack(alignment: .leading){
                            Text("Total Price")
                                .font(.title3)
                                .foregroundStyle(.white)
                            Text("$\(cartManager.getTotal(), specifier: "%.2f")")
                                .foregroundStyle(.white)
                                .font(.title.bold())
                        }
                        
                        Spacer()
                        Button() {
                            
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder()
                                    .frame(width: 120, height: 50)
                                    .foregroundColor(.white)
                                Text("Check Out >")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        }
                        
                    }
                    .padding(25)
                    
                    
                    
                }
                .padding()
                
            }
            .navigationTitle("My Cart")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isDeleteAllAlertPresented = true
                    }) {
                        ZStack {
                            Image(systemName: "trash")
                            if cartManager.getTotalItems() > 0 {
                                Circle()
                                    .fill(Color.pink)
                                    .frame(width: 20, height: 20)
                                    .overlay(
                                        Text("\(cartManager.getTotalItems())")
                                            .font(.caption)
                                            .foregroundStyle(.white)
                                    ).offset(x: 10, y: -10)
                            }
                        }
                    }
                }
            }
            .alert(isPresented: $isDeleteAllAlertPresented) {
                Alert(
                    title: Text("Clearing Cart"),
                    message: Text("You are about to delete all items from your cart. Do you want to proceed?"),
                    primaryButton: .destructive(Text("Delete All")) {
                        cartManager.deleteAll()
                        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                                                impactHeavy.impactOccurred()
                    },
                    secondaryButton: .cancel(Text("Cancel"))
                )
            }
        }
    }
}



struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
            .environmentObject(CartManager())
    }
}
