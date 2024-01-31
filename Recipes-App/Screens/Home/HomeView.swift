//
//  HomeView.swift
//  Recipes-App
//
//  Created by Igor Max de Lima Nunes on 12/01/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            HeaderHomeView(title: "O que você está cozinhando hoje?")
            
            ScrollView {
                SearchBarView(placeholder: "Pesquise sua Receita...",searchText: $homeViewModel.searchText)
                    .padding()
                
                if homeViewModel.searchText.isEmpty { ChefCartoonView() }
                
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 0) {
                    HeadlineTextView(text: "Receitas Disponiveis: ")
                    
                    DivisionLineView()
                }
                .padding(.horizontal, 20)
                
                if homeViewModel.filteredRecipes.isEmpty {
                    ContentUnavailableView(
                        "Nenhuma Receita Encontrada",
                        systemImage: "exclamationmark.magnifyingglass",
                        description: Text("Que tal criar uma nova receita para começar?")
                    )
                } else {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(homeViewModel.filteredRecipes.reversed()) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipeID: "\(recipe.id)")) {
                                RecipeRowView(recipe: recipe)
                                    .padding(5)
                            }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .refreshable { homeViewModel.handleRefresh() }
        }
        .background(Color("bg-color"))
        .navigationBarHidden(true)
        .onAppear { homeViewModel.loadData() }
        .alert(homeViewModel.alertItem?.title ?? "Unknown Error",
               isPresented: $homeViewModel.showAlert,
               actions: {
            Button("OK") { homeViewModel.showAlert = false }
        },
               message: { homeViewModel.alertItem?.message ?? Text("Unexpected Error")
        })
    }
}

#Preview {
    HomeView()
}

struct HeaderHomeView: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title).bold()
                .padding()
            Spacer()
            
            NavigationLink {
                RecipeFormView()
            } label: {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: Color.gray.opacity(0.15),radius: 10)
                    .overlay {
                        Image(systemName: "plus")
                            .foregroundStyle(Color(.label))
                            .imageScale(.large)
                    }
                    .frame(width: 44, height: 44)
                    .padding()
                
            }
            .accentColor(Color(.label))
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            
        }
    }
}

struct ChefCartoonView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(Color("chef-cartoon-color"))
            .frame(width: 370, height: 150)
            .padding()
            .overlay {
                HStack(spacing: 0) {
                    Image("Chef-bro")
                        .resizable()
                        .scaledToFit()
                    
                    Text("Cozinhe as melhores receitas em casa")
                        .font(.title2).bold()
                        .foregroundStyle(Color.white)
                        .padding(.trailing, 14)
                }
                .padding(.horizontal)
            }
    }
}

struct HeadlineTextView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.title2).fontWeight(.semibold)
            .foregroundStyle(Color.black.opacity(0.9))
            .padding(.bottom, 10)
    }
}

struct DivisionLineView: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.5))
            .frame(maxWidth: .infinity, maxHeight: 1)
            .padding(.bottom)
    }
}
