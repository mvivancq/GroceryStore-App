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
    @State private var showWebView = false // Controla la presentación del WebView
    @State private var webViewURL: IdentifiableURL? // URL envuelta en Identifiable para evitar conflictos
    
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
        }
        .sheet(item: $webViewURL) { identifiableURL in
            WebView(url: identifiableURL.url)
        }
    }

    private func fetchCheckoutURL() {
        guard let url = URL(string: "https://calten-raffle-back-beta.vercel.app/api/postGroceryPayment") else {
            print("Error: URL no válida.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "items": "Apples",
            "amount": 1
        ]
        
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

    func makeUIViewController(context: Context) -> UIViewController {
        let webView = WKWebView()
        let viewController = UIViewController()
        viewController.view = webView
        
        // Carga la URL en el WebView
        print("Cargando URL en WebView: \(url.absoluteString)")
        webView.load(URLRequest(url: url))
        
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No necesita actualización por ahora
    }
}

struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
}

