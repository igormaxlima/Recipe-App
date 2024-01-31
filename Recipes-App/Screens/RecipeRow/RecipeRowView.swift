//
//  RecipeRowView.swift
//  Recipes-App
//
//  Created by Igor Max de Lima Nunes on 25/01/24.
//

import SwiftUI

struct RecipeRowView: View {
    let recipe: RecipeList
    
    var body: some View {
        VStack(alignment: .leading) {
            
            RecipeRowImageView(recipe: recipe)
            
            RecipeRowTitleView(recipe: recipe)
            
            RecipeRowCustomizationView(recipe: recipe)
        }
        .frame(width: 330)
        .background(Color(.white))
        .clipShape(.rect(cornerRadius: 10))
        .shadow(color: Color(.systemGray).opacity(0.25), radius: 3, x: 0, y: 0)
    }

}

#Preview {
    RecipeRowView(recipe: RecipeList(name: "Pato", description: "Melhor", time: 32, difficulty: .NORMAL, cost: .EXPENSIVE, portions: "6", imagePath: "https://recipesapp-images220153-dev.s3.amazonaws.com/public/764A415C-177B-4681-906B-19E47E0C0936", steps: []))
}

struct RecipeRowImageView: View {
    let recipe: RecipeList
    
    var body: some View {
        if let url = URL(string: recipe.imagePath) {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Rectangle()
                    .fill(Color.secondary.opacity(0.5))
                    .frame(width: 330, height: 200)
                    .overlay {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
            }
        } else {
            Image(systemName: "xmark")
                .frame(width: 330, height: 200)
        }
    }
}

struct RecipeRowTitleView: View {
    let recipe: RecipeList
    
    var body: some View {
        Text(recipe.name)
            .font(.title3).bold()
            .foregroundStyle(Color(.black))
            .padding(.horizontal, 15)
            .padding(.vertical, 2)
    }
}

struct RecipeRowCustomizationView: View {
    let recipe: RecipeList
    
    var body: some View {
        HStack(spacing: 25){
            Label("\(Int(recipe.time)) min", systemImage: "clock")
            
            Label("\(recipe.difficulty.translatedString)", systemImage: "lightbulb.max")
            
            Label("\(recipe.portions) Pessoas", systemImage: "fork.knife")
        }
        .foregroundStyle(Color(.gray))
        .padding(10)
        .font(.subheadline)
    }
}
