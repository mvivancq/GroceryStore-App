//
//  Checkout.swift
//  GroceryApp
//
//  Created by martin vivanco palacios on 24/10/24.
//
import SwiftUI
import WebKit

struct Checkout: View {
    @EnvironmentObject private var cartManager: CartManager
    @State private var webViewURL: IdentifiableURL? // URL envuelta en Identifiable para evitar conflictos
    @State private var successMessage: String? // Mensaje de éxito o fallo
    
    var body: some View {
        VStack {
            Text("Checkout Page")
                .font(.largeTitle)
                .padding()
            
            // Botón para abrir WebView después de obtener la URL
            Button(action: {
                fetchCheckoutURL()
            }) {
                Text("Paga con CoDi")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
            if let message = successMessage {
                Text(message)
                    .font(.title2)
                    .foregroundColor(message.contains("Success") ? .green : .red)
                    .padding()
            }
        }
        .sheet(item: $webViewURL) { identifiableURL in
            WebView(url: identifiableURL.url) { success in
                handleSuccess(success: success)
            }
        }
    }

    private func handleSuccess(success: Bool) {
        successMessage = success ? "Payment Success!" : "Payment Failed!"
        webViewURL = nil // Cierra el WebView estableciendo webViewURL en nil
    }
    
    private func fetchCheckoutURL() {
        guard let url = URL(string: "https://calten-raffle-back-beta.vercel.app/api/postGroceryPayment") else {
            print("Error: URL no válida.")
            return
        }
        
        // Construye el cuerpo dinámicamente basado en los datos de cartManager
        let items = cartManager.cartItems.map { $0.product.name }
        
        // Calcula el precio total basado en la cantidad de cada producto y su precio
        let amount = cartManager.cartItems.reduce(0) { total, cartItem in
            total + (Double(cartItem.quantity) * cartItem.product.price)
        }

        let body: [String: Any] = [
            "items": items.joined(separator: ", "), // Lista de nombres de productos separados por coma
            "amount": amount // Precio total acumulado
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al hacer la solicitud: \(error)")
                return
            }
            
            if let data = data {
                print("Datos recibidos: \(String(data: data, encoding: .utf8) ?? "Datos inválidos")")
                
                if let result = try? JSONDecoder().decode([String: String].self, from: data),
                   let urlString = result["paymentId"],
                   let url = URL(string: "https://calten-frontend-beta.vercel.app/checkout/" + urlString) {
                        DispatchQueue.main.async {
                            self.webViewURL = IdentifiableURL(url: url) // Asigna la URL envuelta para mostrar WebView
                            print("URL obtenida y configurada: \(self.webViewURL?.url.absoluteString ?? "URL inválida")")
                        }
                    } else {
                        print("Error: No se pudo decodificar la respuesta JSON o URL inválida.")
                    }
            }
        }.resume()
    }
}


struct WebView: UIViewControllerRepresentable {
    let url: URL
    var successHandler: ((Bool) -> Void)?

    func makeUIViewController(context: Context) -> UIViewController {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        let viewController = UIViewController()
        viewController.view = webView
        webView.load(URLRequest(url: url))
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No necesita actualización por ahora
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(successHandler: successHandler)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var successHandler: ((Bool) -> Void)?
        
        init(successHandler: ((Bool) -> Void)?) {
            self.successHandler = successHandler
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            guard let currentURL = webView.url?.absoluteString else { return }

            // Detecta éxito o fallo según la URL actual
            if currentURL.contains("success") {
                successHandler?(true)
            } else if currentURL.contains("fail") {
                successHandler?(false)
            }
        }
    }
}


struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
}
