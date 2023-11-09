

import Foundation
import SwiftUI

struct Product: Identifiable, Codable, Hashable {
    let id = UUID()
    var name: String
    var price: Double
    var image: String
    var colorName: String // Store color name as a string identifier
    
    var color: Color {
        switch colorName {
        case "red":
            return Color.red
        case "yellow":
            return Color.yellow
        case "green":
            return Color.green
        case "brown":
            return Color.brown
        case "purple":
            return Color.purple
        case "orange":
            return Color.orange
        default:
            return Color.black // Default color in case of unknown color name
        }
    }
}

let productItem: [Product] = [
    Product(name: "Avocado", price: 1.99, image: "avocado", colorName: "green"),
    Product(name: "Strawberry", price: 3.49, image: "strawberry", colorName: "red"),
    Product(name: "Cola", price: 2.39, image: "cola", colorName: "purple"),
    Product(name: "Cheese", price: 5.99, image: "cheese", colorName: "yellow"),
    Product(name: "Milk", price: 3.49, image: "milk", colorName: "brown"),
    Product(name: "Orange", price: 2.39, image: "orange", colorName: "orange")
]
