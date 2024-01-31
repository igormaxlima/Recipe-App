//
//  HomeViewModel.swift
//  Recipes-App
//
//  Created by Igor Max de Lima Nunes on 13/01/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var recipes: [RecipeList] = []
    @Published var alertItem: AlertItem?
    @Published var showAlert = false
    @Published var searchText = ""
    
    var filteredRecipes: [RecipeList] {
        guard !searchText.isEmpty else {
            return self.recipes
        }
        return self.recipes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    
    
}

extension HomeViewModel {
    @MainActor
    func loadData() {
        Task(priority: .medium) {
            do {
                let recipes = try await fetchAllRecipes()
                self.recipes = recipes
            } catch {
                mapErrorToAlert(error)
            }
        }
    }
    
    func handleRefresh() {
        recipes.removeAll()
        Task {
            await loadData()
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
