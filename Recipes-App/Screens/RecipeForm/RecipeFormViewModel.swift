//
//  RecipeFormViewModel.swift
//  Recipes-App
//
//  Created by Igor Max de Lima Nunes on 13/01/24.
//

import Foundation
import SwiftUI
import Amplify

class RecipeFormViewModel: ObservableObject {
    @Published var navigateToHome: Bool = false
    @Published var isAddingIngredient: Bool = false
    @Published var isAddingStep: Bool = false
    @Published var step: String = ""
    @Published var selectedPhoto: UIImage?
    @Published var alertItem: AlertItem?
    @Published var showAlert = false
    
    @Published var recipe = Recipe(
        name: "",
        description: "",
        time: 0,
        difficulty: .NORMAL,
        cost: .NORMAL,
        portions: "",
        imagePath: "",
        ingredients: [],
        steps: []
    )
    
    @Published var ingredient = Ingredient(name: "", quantity: 0.0, measurement: .GRAMA)
    var disableForm: Bool {
        recipe.name.isEmpty || recipe.description.isEmpty || recipe.time <= 0 || recipe.portions.isEmpty || recipe.ingredients.isEmpty || recipe.steps.isEmpty || selectedPhoto == nil
    }
    
    
    func addIngredient() {
        let newIngredient = Ingredient(
            name: ingredient.name,
            quantity: ingredient.quantity,
            measurement: ingredient.measurement
        )
        
        recipe.ingredients.append(newIngredient)

        ingredient = Ingredient(name: "", quantity: 0.0, measurement: .GRAMA)
        isAddingIngredient.toggle()
    }
    
    
    func addStep(step: String) {
        recipe.steps.append(step)
        
        self.step = ""
        isAddingStep.toggle()
        
    }
    
    func uploadImageToS3() async throws {
        let imageKey: String = "\(recipe.id)"
        
        guard let image = selectedPhoto else {
            print("No Image to Upload")
            return
        }
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Failed to convert image to data")
            return
        }
        
        let uploadTask = Amplify.Storage.uploadData(key: imageKey, data: imageData)
        let value = try await uploadTask.value
        print("Completed: \(value)")
        
        recipe.imagePath = "https://recipesapp-images220153-dev.s3.amazonaws.com/public/\(imageKey)"
    }
    
}

extension RecipeFormViewModel {
    @MainActor
    func sendData() {
        Task {
            do {
                try await uploadImageToS3()
                try await postRecipeData(recipe: self.recipe)
                
                navigateToHome = true
            } catch {
                mapErrorToAlert(error)
            }
        }
    }
    
    private func mapErrorToAlert(_ error: Error) {
        switch error {
        case APIError.invalidURL:
            alertItem = AlertContext.invalidURL
        case APIError.invalidData:
            alertItem = AlertContext.invalidData
        case APIError.invalidResponse:
            alertItem = AlertContext.invalidResponse
        case APIError.serverError:
            alertItem = AlertContext.unableToComplete
        case APIError.unknown(_):
            alertItem = AlertContext.unknown
        default:
            break;
        }
        self.showAlert = true
    }
}
