//
//  Recipe.swift
//  Recipes-App
//
//  Created by Igor Max de Lima Nunes on 13/01/24.
//

import Foundation

enum Difficulty: String, Codable, CaseIterable, Identifiable {
    case EASY
    case NORMAL
    case HARD
    
    var id: Self { self }
    
    var translatedString: String {
        switch self {
        case .EASY: return "Fácil"
        case .NORMAL: return "Médio"
        case .HARD: return "Difícil"
        }
    }
}

enum Cost: String, Codable, CaseIterable, Identifiable {
    case CHEAP
    case NORMAL
    case EXPENSIVE
    
    var id: Self { self }
    
    var translatedString: String {
        switch self {
        case .CHEAP: return "Baixo"
        case .NORMAL: return "Médio"
        case .EXPENSIVE: return "Alto"
        }
    }
}

enum Measurement: String, Codable, CaseIterable, Identifiable {
    case XICARA
    case COLHER_DE_SOPA
    case COLHER_DE_CHA
    case GRAMA
    case QUILOGRAMA
    case UNIDADE
    
    var id: Self { self }
    
    var formattedString: String {
        switch self {
        case .COLHER_DE_CHA: return "Colher de Chá"
        case .COLHER_DE_SOPA: return "Colher de Sopa"
        case .GRAMA: return "Gramas"
        case .QUILOGRAMA: return "Quilogramas"
        case.UNIDADE: return "Unidade"
        case .XICARA: return "Xícara"
        }
    }
}

struct Recipe: Identifiable, Codable {
    var id = UUID()
    var name: String
    var description: String
    var time: Float
    var difficulty: Difficulty
    var cost: Cost
    var portions: String
    var imagePath: String
    var ingredients: [Ingredient]
    var steps: [String]
}

struct RecipeList: Identifiable, Codable {
    var id = UUID()
    var name: String
    var description: String
    var time: Float
    var difficulty: Difficulty
    var cost: Cost
    var portions: String
    var imagePath: String
    var steps: [String]
}

struct Ingredient: Identifiable, Codable {
    var id = UUID()
    var name: String
    var quantity: Float
    var measurement: Measurement
}


