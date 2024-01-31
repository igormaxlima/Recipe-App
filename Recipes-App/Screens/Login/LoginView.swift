//
//  ContentView.swift
//  Recipes-App
//
//  Created by Igor Max de Lima Nunes on 12/01/24.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ImageLoginView()
                
                Spacer()
                
                VStack(alignment: .leading) {
                    FirstTextView(text: "Torne-se um")
                    
                    TitleTextView(titleText: "Masterchef 👨🏼‍🍳")
                    
                    
                    SubscriptionTextView(text: "Obtenha receitas deliciosas dos Masterchefs de todo o mundo para satisfazer seus desejos.")
                }
                .padding(.horizontal)
                
                Spacer()
                
                HStack {
                    ThreeRectanglesView()
                    
                    Spacer()
                    ButtonLoginView(buttonText: "Iniciar")

                }
                .padding(25)
            }
            .background(Color("bg-color"))
        }
    }
}

#Preview {
    LoginView()
}

struct ImageLoginView: View {
    var body: some View {
        Image("login-image")
            .resizable()
            .scaledToFit()
    }
}

struct FirstTextView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 24)).fontWeight(.regular)
    }
}

struct TitleTextView: View {
    let titleText: String
    
    var body: some View {
        Text(titleText)
            .font(.system(size: 38)).fontWeight(.semibold)
    }
}

struct SubscriptionTextView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 14)).fontWeight(.light)
            .padding(.vertical, 10)
    }
}

struct ThreeRectanglesView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color("chef-cartoon-color"))
            .frame(width: 19, height: 7)
        
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.5))
            .frame(width: 7, height: 7)
        
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.5))
            .frame(width: 7, height: 7)
    }
}

struct ButtonLoginView: View {
    let buttonText: String
    
    var body: some View {
        NavigationLink(destination: HomeView(), label: {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color("chef-cartoon-color"))
                .frame(width: 125, height: 60)
                .shadow(color: Color("chef-cartoon-color").opacity(0.3),radius: 2, x: 5,y: 5)
                .overlay {
                    HStack(spacing: 15) {
                        Text(buttonText)
                            .bold()
                        Image(systemName: "arrow.right")
                    }
                    .foregroundStyle(Color.white)
                }
        })
    }
}
