//
//  AlertItem.swift
//  Recipes-App
//
//  Created by Igor Max de Lima Nunes on 24/01/24.
//

import SwiftUI

struct AlertItem: Identifiable {
    var id = UUID()
    var title: String
    var message: Text
    var dismissButton: Alert.Button?
}

enum AlertContext {
    static let invalidURL = AlertItem(title: "Error no Servidor", message: Text("Houve um erro ao tentar acessar o servidor. Se isso persistir, entre em contato com o suporte."), dismissButton: .default(Text("Ok")))
    
    static let unableToComplete = AlertItem(title: "Error no Servidor", message: Text("Não foi possível completar sua solicitação no momento. Verifique sua conexão com a internet."), dismissButton: .default(Text("Ok")))
    
    static let invalidResponse = AlertItem(title: "Error no Servidor", message: Text("Resposta inválida do servidor. Por favor, tente novamente ou entre em contato com o suporte."), dismissButton: .default(Text("Ok")))
    
    static let invalidData = AlertItem(title: "Error no Servidor", message: Text("Os dados recebidos do servidor eram inválidos. Por favor, tente novamente ou entre em contato com o suporte."), dismissButton: .default(Text("Ok")))
    
    static let unknown = AlertItem(title: "Error Inesperado", message: Text("Ocorreu um erro inesperado. Por favor, tente novamente ou entre em contato com o suporte."), dismissButton: .default(Text("Ok")))
}
