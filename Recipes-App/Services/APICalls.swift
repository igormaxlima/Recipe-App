//
//  APICalls.swift
//  Recipes-App
//
//  Created by Igor Max de Lima Nunes on 16/01/24.
//

import Foundation

private let BASE_URL = "http://localhost:8080"

func fetchAllRecipes() async throws -> [RecipeList] {
    let endpoint = BASE_URL + "/recipes"
    
    guard let url = URL(string: endpoint) else { throw APIError.invalidURL }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw APIError.invalidResponse }
    
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([RecipeList].self, from: data)
    } catch {
        throw APIError.invalidData
    }
}

func fetchRecipeByID(recipeID: String) async throws -> Recipe {
    let endpoint = BASE_URL + "/recipes/\(recipeID)"
    
    guard let url = URL(string: endpoint) else { throw APIError.invalidURL }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw APIError.invalidResponse }
    
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(Recipe.self, from: data)
    } catch {
        throw APIError.invalidData
    }
}

func postRecipeData(recipe: Recipe) async throws {
    let endpoint = BASE_URL + "/recipes"
    
    guard let url = URL(string: endpoint) else { throw APIError.invalidURL }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    
    let jsonData = try JSONEncoder().encode(recipe)
    
    do {
        let (_, response) = try await URLSession.shared.upload(for: request, from: jsonData)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else { throw APIError.invalidResponse }
    } catch {
        throw APIError.invalidData
    }
}


enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case serverError
    case unknown(Error)
}

