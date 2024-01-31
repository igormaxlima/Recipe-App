//
//  AddRecipeView.swift
//  Recipes-App
//
//  Created by Igor Max de Lima Nunes on 13/01/24.
//

import SwiftUI
import PhotosUI

struct RecipeFormView: View {
 
    @StateObject var recipeFormViewModel = RecipeFormViewModel()
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Form {
                Section("Sobre") {
                    NameFormView(recipeFormViewModel: recipeFormViewModel)
                    
                    DescriptionFormView(recipeFormViewModel: recipeFormViewModel)
                }
                 
                TimeFormView(recipeFormViewModel: recipeFormViewModel)
                
                PortionsFormView(recipeFormViewModel: recipeFormViewModel)

                DifficultyLevelFormView(recipeFormViewModel: recipeFormViewModel)
                
                CostLevelFormView(recipeFormViewModel: recipeFormViewModel)
                
                IngredientFormView(recipeFormViewModel: recipeFormViewModel)
                
                StepsFormView(recipeFormViewModel: recipeFormViewModel)
                
                ImageFormView(recipeFormViewModel: recipeFormViewModel)
                
            }
            .background(Color("bg-color"))
            .scrollContentBackground(.hidden)
            
            CreateRecipeButtonView(buttonText: "Criar Receita", recipeFormViewModel: recipeFormViewModel)
            
        }
        .background(Color("bg-color"))
        .navigationTitle("Nova Receita")
        .alert(recipeFormViewModel.alertItem?.title ?? "Unknown Error",
               isPresented: $recipeFormViewModel.showAlert,
               actions: {
            Button("OK") { recipeFormViewModel.showAlert = false }
        },
               message: { recipeFormViewModel.alertItem?.message ?? Text("Unexpected Error")
        })
        
    }
}

#Preview {
    RecipeFormView()
}


struct NameFormView: View {
    @ObservedObject var recipeFormViewModel: RecipeFormViewModel
    
    var body: some View {
        TextField("Nome da Receita", text: $recipeFormViewModel.recipe.name)
    }
}

struct DescriptionFormView: View {
    @ObservedObject var recipeFormViewModel: RecipeFormViewModel
    
    var body: some View {
        TextField("Descrição da Receita", text: $recipeFormViewModel.recipe.description)
    }
}

struct TimeFormView: View {
    @ObservedObject var recipeFormViewModel: RecipeFormViewModel
    
    var body: some View {
        Section("Tempo Estimado em Minutos") {
            TextField("Tempo", value: $recipeFormViewModel.recipe.time, formatter: NumberFormatter())
        }
    }
}

struct PortionsFormView: View {
    @ObservedObject var recipeFormViewModel: RecipeFormViewModel
    
    var body: some View {
        Section("Serve Quantas Pessoas") {
            TextField("Porção", text: $recipeFormViewModel.recipe.portions)
        }
    }
}

struct DifficultyLevelFormView: View {
    @ObservedObject var recipeFormViewModel: RecipeFormViewModel
    
    var body: some View {
        Section(header: Text("Nível de Dificuldade da Receita")) {
            Picker("Dificuldade", selection: $recipeFormViewModel.recipe.difficulty) {
                ForEach(Difficulty.allCases) { difficulty in
                    Text(difficulty.translatedString)
                        .tag(difficulty)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

struct CostLevelFormView: View {
    @ObservedObject var recipeFormViewModel: RecipeFormViewModel
    
    var body: some View {
        Section(header: Text("Custo Total da Receita")) {
            Picker("Custo", selection: $recipeFormViewModel.recipe.cost) {
                ForEach(Cost.allCases) { cost in
                    Text(cost.translatedString)
                        .tag(cost)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

struct IngredientFormView: View {
    @ObservedObject var recipeFormViewModel: RecipeFormViewModel
    
    var body: some View {
        Section(header: Text("Ingredientes")) {
            ForEach(recipeFormViewModel.recipe.ingredients) { ingredient in
                IngredientRowView(ingredient: ingredient)
            }
            if recipeFormViewModel.isAddingIngredient {
                VStack(spacing: 20) {
                    TextField("Nome do Ingrediente", text: $recipeFormViewModel.ingredient.name)
                    TextField("Tempo", value: $recipeFormViewModel.ingredient.quantity, formatter: NumberFormatter())
                    Picker("Medição", selection: $recipeFormViewModel.ingredient.measurement) {
                        ForEach(Measurement.allCases) { measurement in
                            Text(measurement.formattedString)
                        }
                    }
                    .pickerStyle(.menu)
                }
                Button("Adicionar Ingrediente") { recipeFormViewModel.addIngredient() }
                .disabled(recipeFormViewModel.ingredient.name.isEmpty || recipeFormViewModel.ingredient.quantity <= 0)
            } else {
                Button("Adicionar Ingrediente") { recipeFormViewModel.isAddingIngredient.toggle() }
            }
        }
    }
}

struct StepsFormView: View {
    @ObservedObject var recipeFormViewModel: RecipeFormViewModel
    
    var body: some View {
        Section(header: Text("Passos")) {
            ForEach(recipeFormViewModel.recipe.steps.indices, id: \.self) { index in
                Text("Passo \(index + 1): \(recipeFormViewModel.recipe.steps[index])")
            }
            if recipeFormViewModel.isAddingStep  {
                TextField("Instrução", text: $recipeFormViewModel.step)
                Button("Inserir Passo") { recipeFormViewModel.addStep(step: recipeFormViewModel.step) }
                .disabled(recipeFormViewModel.step.isEmpty)
            } else {
                Button("Adicionar Passo") { recipeFormViewModel.isAddingStep.toggle() }
            }
        }
    }
}

struct IngredientRowView: View {
    var ingredient: Ingredient

    var body: some View {
        HStack {
            Text("\(ingredient.name):")
            Text("\(Int(ingredient.quantity)) -")
            Text("\(ingredient.measurement.formattedString)")
            Spacer()
        }
    }
}


struct ImageFormView: View {
    @ObservedObject var recipeFormViewModel: RecipeFormViewModel
    @State private var photosPickerItem: PhotosPickerItem?
    
    var body: some View {
        Section("Imagem da Receita") {
            PhotosPicker(selection: $photosPickerItem, matching: .images) {
                HStack {
                    Image(systemName: recipeFormViewModel.selectedPhoto == nil ? "photo" : "checkmark.circle.fill")
                    Text(recipeFormViewModel.selectedPhoto == nil ? "Adicionar Imagem" : "Adicionado")
                }
                .foregroundStyle(recipeFormViewModel.selectedPhoto == nil ? Color.blue : Color("chef-cartoon-color"))
            }
        }
        .onChange(of: photosPickerItem) { _, _ in
            Task {
                if let photosPickerItem, let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) {
                        recipeFormViewModel.selectedPhoto = image
                    }
                }
                photosPickerItem = nil
            }
        }
    }
}


struct CreateRecipeButtonView: View {
    let buttonText: String
    @ObservedObject var recipeFormViewModel: RecipeFormViewModel
    
    var body: some View {
        Button{ recipeFormViewModel.sendData() } label: {
            Text(buttonText)
                .fontWeight(.bold)
            
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .tint(Color("chef-cartoon-color"))
        .disabled(recipeFormViewModel.disableForm)
        .navigationDestination(isPresented: $recipeFormViewModel.navigateToHome) { HomeView() }
    }
}
