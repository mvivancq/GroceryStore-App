//
//  CartManager.swift
//  GroceryApp
//
//  Created by Viktor on 2023-11-09.
//


import SwiftUI

struct CartItem: Identifiable, Codable {
    var id = UUID()
    var product: Product
    var quantity: Int
    
    enum CodingKeys: String, CodingKey {
        case id, product, quantity
    }
}

class CartManager: ObservableObject {
    private var cartItemIDs: Set<UUID> = []
    @Published var cartItems: [CartItem] = [] {
        didSet {
            saveItems()
        }
    }

    init() {
        loadItems()
        updateCartItemIDs()
    }

    // Load items from UserDefaults
    private func loadItems() {
        if let data = UserDefaults.standard.data(forKey: "cartItems"),
            let cartItems = try? JSONDecoder().decode([CartItem].self, from: data) {
            self.cartItems = cartItems
        }
        updateCartItemIDs()
    }

    // Save items to UserDefaults
    func saveItems() {
        if let data = try? JSONEncoder().encode(cartItems) {
            UserDefaults.standard.set(data, forKey: "cartItems")
        }
        updateCartItemIDs()
    }

    // Update the set of cart item IDs for efficient lookup
    func updateCartItemIDs() {
        cartItemIDs = Set(cartItems.map { $0.product.id })
    }

    // Add a product to the cart
    func addToCart(product: Product) {
        if cartItemIDs.contains(product.id) {
            // If the product is already in the cart, update its quantity
            if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
                cartItems[index].quantity += 1
            }
        } else {
            // If the product is not in the cart, add it with quantity 1
            let newItem = CartItem(product: product, quantity: 1)
            cartItems.append(newItem)
            cartItemIDs.insert(product.id)
        }
        saveItems()
    }
    // Get total quantity of a specific product in the cart
    func getTotalQuantity(for product: Product) -> Int {
        if let cartItem = cartItems.first(where: { $0.product.id == product.id }) {
            return cartItem.quantity
        }
        return 0
    }
    
    // Get total price of a specific product in the cart
    func getTotalPrice(for product: Product) -> Double {
        if let cartItem = cartItems.first(where: { $0.product.id == product.id }) {
            return Double(cartItem.quantity) * cartItem.product.price
        }
        return 0
    }
    
    func getTotal() -> Double {
        return cartItems.reduce(0) { $0 + $1.product.price * Double($1.quantity) }
    }
    
    func getTotalItems() -> Int {
            return cartItems.reduce(0) { $0 + $1.quantity }
        }
    
    func removeOne(from product: Product) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[index].quantity -= 1
            if cartItems[index].quantity <= 0 {
                cartItems.remove(at: index)
                cartItemIDs.remove(product.id)
            }
            saveItems()
        }
    }

    // Remove all quantities of a specific product from the cart
    func removeAll(of product: Product) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems.remove(at: index)
            cartItemIDs.remove(product.id)
            saveItems()
        }
    }
    
    func deleteAll() {
        cartItems.removeAll()
        cartItemIDs.removeAll()
        saveItems()
    }
}

