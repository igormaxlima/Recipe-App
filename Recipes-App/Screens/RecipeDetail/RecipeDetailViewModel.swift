//
//  RecipeDetailViewModel.swift
//  Recipes-App
//
//  Created by Igor Max de Lima Nunes on 28/01/24.
//

import Foundation

class RecipeDetailViewModel: ObservableObject {
    @Published var selectedTab: String = "ingredient"
    @Published var recipe = Recipe(
        name: "",
        description: "",
        time: 0,
        difficulty: .NORMAL,
        cost: .NORMAL,
        portions: "teste",
        imagePath: "",
        ingredients: [],
        steps: []
    )
}

extension RecipeDetailViewModel {
    @MainActor
    func loadRecipeData(recipeID: String) {
        Task {
            do {
              let recipe = try await fetchRecipeByID(recipeID: recipeID)
              self.recipe = recipe
            } catch {
                print(error)
            }
        }
    }
}
