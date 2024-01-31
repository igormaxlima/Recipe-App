//
//  RecipeDetailView.swift
//  Recipes-App
//
//  Created by Igor Max de Lima Nunes on 28/01/24.
//

import SwiftUI

struct RecipeDetailView: View {
    
    @StateObject var recipeDetailViewModel = RecipeDetailViewModel()
    let recipeID: String
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 0) {
                RecipeImageView(recipeDetailViewModel: recipeDetailViewModel)
                
                Group {
                    RecipeTitleView(recipeDetailViewModel: recipeDetailViewModel)
                    
                    RecipeDescriptionView(recipeDetailViewModel: recipeDetailViewModel)
                    
                    RecipeCustomizationView(recipeDetailViewModel: recipeDetailViewModel)
                    
                    RecipeButtonView(recipeDetailViewModel: recipeDetailViewModel)
                    
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                
                if recipeDetailViewModel.selectedTab == "ingredient" { RecipeIngredientsView(recipeDetailViewModel: recipeDetailViewModel)
                } else {
                    RecipeInstructionsView(recipeDetailViewModel: recipeDetailViewModel)
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .task { recipeDetailViewModel.loadRecipeData(recipeID: recipeID) }
    }
}

#Preview {
    RecipeDetailView(recipeID: "257da4ba-aa3a-4f14-957d-1052a20c50c7")
}

struct RecipeImageView: View {
    @ObservedObject var recipeDetailViewModel: RecipeDetailViewModel
    
    var body: some View {
        AsyncImage(url: URL(string: recipeDetailViewModel.recipe.imagePath)) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            Rectangle()
                .fill(Color.gray.opacity(0.5))
                .frame(height: 250)
                .overlay {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                
        }
    }
}

struct RecipeTitleView: View {
    @ObservedObject var recipeDetailViewModel: RecipeDetailViewModel
    
    var body: some View {
        HStack {
            Text(recipeDetailViewModel.recipe.name)
                .font(.largeTitle).bold()
                .foregroundStyle(Color(.black))
                .padding(.top, 10)
            
            Spacer()
            
            Label("Serve: \(recipeDetailViewModel.recipe.portions)", systemImage: "person.2")
                .foregroundStyle(Color.gray)
        }
    }
}

struct RecipeDescriptionView: View {
    @ObservedObject var recipeDetailViewModel: RecipeDetailViewModel
    
    var body: some View {
        Text(recipeDetailViewModel.recipe.description)
            .font(.subheadline)
            .padding(.vertical, 5)
    }
}

struct RecipeCustomizationView: View {
    @ObservedObject var recipeDetailViewModel: RecipeDetailViewModel
    
    var body: some View {
        HStack(spacing: 25) {
            Label("\(Int(recipeDetailViewModel.recipe.time)) min", systemImage: "clock")
            Label("\(recipeDetailViewModel.recipe.cost.translatedString)", systemImage: "dollarsign.circle")
            Label("\(recipeDetailViewModel.recipe.difficulty.translatedString)", systemImage: "brain")
        }
        .foregroundStyle(Color.gray)
    }
}

struct RecipeButtonView: View {
    @ObservedObject var recipeDetailViewModel: RecipeDetailViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                recipeDetailViewModel.selectedTab = "ingredient"
            } label: {
                RoundedRectangle(cornerRadius: 20)
                    .fill(recipeDetailViewModel.selectedTab == "ingredient" ? Color("chef-cartoon-color") : Color.clear)
                    .frame(width: (UIScreen.main.bounds.width / 2) - 20, height: 50)
                    .overlay {
                        Text("Ingredientes")
                            .foregroundStyle(recipeDetailViewModel.selectedTab == "ingredient" ? Color.white : Color.black.opacity(0.5))
                            .fontWeight(.bold)
                    }
            }
            
            Button {
                recipeDetailViewModel.selectedTab = "instructions"
            } label: {
                RoundedRectangle(cornerRadius: 20)
                    .fill(recipeDetailViewModel.selectedTab == "instructions" ? Color("chef-cartoon-color") : Color.clear)
                    .frame(width: (UIScreen.main.bounds.width / 2) - 20, height: 50)
                    .overlay {
                        Text("Instruções")
                            .foregroundStyle(recipeDetailViewModel.selectedTab == "instructions" ? Color.white : Color.black.opacity(0.5))
                            .fontWeight(.bold)
                    }
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.secondary.opacity(0.2))
        }
        .padding(.top, 10)
    }
}

struct RecipeIngredientsView: View {
    @ObservedObject var recipeDetailViewModel: RecipeDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(recipeDetailViewModel.recipe.ingredients) { ingredient in
                HStack {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 5)
                        .foregroundStyle(Color("chef-cartoon-color"))
                    Text("\(ingredient.name):")
                        .fontWeight(.regular)
                    Text("\(Int(ingredient.quantity)) -")
                        .fontWeight(.light)
                    Text("\(ingredient.measurement.formattedString)")
                        .fontWeight(.light)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .shadow(color: Color("chef-cartoon-color").opacity(0.3), radius: 2)
                }
                
            }
        }
        .padding(.horizontal, 10)
    }
}

struct RecipeInstructionsView: View {
    @ObservedObject var recipeDetailViewModel: RecipeDetailViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            ForEach(recipeDetailViewModel.recipe.steps.indices, id: \.self) { index in
                Image(systemName: "chevron.down.circle")
                    .resizable()
                    .frame(width: 42, height: 42, alignment: .center)
                    .fontWeight(.ultraLight)
                    .padding(.vertical, 5)
                    .foregroundStyle(Color("chef-cartoon-color"))
                
                HStack(alignment: .center) {
                    Text("\(recipeDetailViewModel.recipe.steps[index])")
                        .fontWeight(.regular)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .shadow(color: Color("chef-cartoon-color").opacity(0.3), radius: 3)
                }
            }
        }
        .padding(.horizontal, 10)
    }
}
